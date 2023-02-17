/*
*
*
* Creates Account hierarchy with Premises and Service points as mentioned in this doc:
    https://salesforce.quip.com/lqaiApcO58BU
* Nodes as per: https://docs.google.com/document/d/1w_fTqPSztPFCoIAAJ_ubioUCF1-EXKJPkO5GdwSgnw8/edit
* Also creates Opportunity and Quotes under the City level Business-Accounts
* Make sure to have the products setup before running this script
*
* Workarounds 
*  You might want to turn off following Triggers before executing the script temporarily: Party.EnablePartyModel, Contract.EnableStateModel
*  for Setting up addresses : Add an entry in locToAddress map with last word(assuming location) of account-name as the key
*  Verify if picklist values in Lead-status is aligned. If not update the following lists: lstatus, rstatus
*  To setup vlocity one-time total pricing field on Quote: 
*       List<QuoteLineItem> qlis = [Select Id,TotalPrice, vlocity_cmt__OneTimeTotal__c from QuoteLineItem WHERE CreatedDate > 2022-03-13T09:11:43.000Z]; // update the filter as per your need
        for (QuoteLineItem i: qlis)
        {   
	        i.vlocity_cmt__OneTimeTotal__c = i.TotalPrice;
        }
        update qlis;

*   To update AccountContactRelations
        List<AccountContactRelation> ac = [SELECT Account.Name,Id,Roles FROM AccountContactRelation WHERE CreatedDate > 2022-03-13T09:11:43.000Z and Roles = ''];
        for (AccountContactRelation a: ac)
        {
            a.Roles ='Business User';
        }
        update ac;

*   If PrimaryContactId isn't linked on the Account
        List<Account> accounts = [Select Id from Account where createdDate > 2022-03-15T15:18:26.000Z]; // update the filter as per your need
        List<Id> accountIds = new List<Id>();
        for (Account a:accounts)
        {
            accountIds.add(a.Id);
        }
        List<Account> acs = new List<Account>();
        List<Contact> cs = [Select Id, AccountId, Account.Name from Contact where AccountId IN :accountIds];
        Map<Id,Contact> aToc= new Map<Id, contact>();
        for (Contact c: cs)
        {
            aToc.put(c.AccountId, c);
        }
        for (Contact c:aToc.values())
        {
            Account a = new Account();
            a.Id = c.AccountId;
            a.vlocity_cmt__PrimaryContactId__c = c.Id;
            acs.add(a);
        }
        update acs;
*
*
*
*
* Sample invocation: 
* 1. Copy DatagenSales from: https://github.com/sf-industries/vex_express_energy/blob/salesDataSetup/dataSetup/DatagenSales.cls
* 2. Replace vlocity_cmt__ with namespace in non-prod envs
* 3. (Optional) Replace pricebookId.
* 4. Execute:
*   DatagenSales d = new DatagenSales();
*   d.setupLargeHierarchyAccounts();
*   d.setupMediumHierarchyAccounts();
*   d.setupMediumHierarchyAccounts2();
*   d.setupStandaloneAccounts();
*   d.setupStandaloneAccounts2();
*   d.setupLeads();
* 5. Optional: Execute -
*    DatagenSales d = new DatagenSales();
*    d.createBulkOpportunities(accountId, opptyCount);
*/


public class DatagenSales
{
    static final String NSP = 'vlocity_cmt__';//ApplicationUtilities.getNameSpacePrefix();//vlocity_cmt__
    static final String pricebookId = [SELECT Id FROM Pricebook2 where isActive = true Limit 1].Id; //AND isDefault__c = true //'01s8Y000001Y1V3QAK';
    //static final String AccountNamePrefix = 'Imperial Motors ';
    static List<Account> accList = new List<Account>();
    static List<User> users = new List<User>();
    static String accountIndustry = '';
    static String matchAccountName = '';
    static Map<String, List<Map<String, String>>> locToAddress = new Map<String, List<Map<String, String>>>{
        'Office' => new List<Map<String, String>>{
            new Map<String, String> {
                'street' => 'Bath Street',
                'city' => 'Nottingham',
                'state' => 'Nottinghamshire',
                'country' => 'England',
                'postalCode' => 'NG1 1BZ'
            }
        },
        'England' => new List<Map<String, String>>{
            new Map<String, String> {
                'street' => '1 Pioneer Close, Abbey Lane',
                'city' => 'Leicester',
                'state' => 'Leicestershire',
                'country' => 'England',
                'postalCode' => 'LE4 5QY'
            }
        },
        'Bristol' => new List<Map<String, String>>{
            new Map<String, String> {
                'street' => '78-86 Pennywell Road, Old Market',
                'city' => 'Bristol',
                'state' => 'Bristol',
                'country' => 'England',
                'postalCode' => 'BS5 0TG'
            }
        },
        'Coventry' => new List<Map<String, String>>{
            new Map<String, String> {
                'street' => 'Unit 1, Cyan Business Park, Jimmy Hill Way',
                'city' => 'Coventry',
                'state' => 'West Midlands',
                'country' => 'England',
                'postalCode' => 'CV2 4QP'
            }
        },
        'Luton' => new List<Map<String, String>>{
            new Map<String, String> {
                'street' => 'Unit 12, Cosgrove Way',
                'city' => 'Luton',
                'state' => 'Bedfordshire',
                'country' => 'England',
                'postalCode' => 'LU1 1XL'
            }
        },
        'Peterborough' => new List<Map<String, String>>{
            new Map<String, String> {
                'street' => 'Padholme Road East',
                'city' => 'Peterborough',
                'state' => 'Peterborough',
                'country' => 'England',
                'postalCode' => 'PE1 5XL'
            }
        },
        'Scotland' => new List<Map<String, String>>{
            new Map<String, String> {
                'street' => '1 Carron Place, Salamander Street',
                'city' => 'Edinburgh',
                'state' => 'Lothian',
                'country' => 'Scotland',
                'postalCode' => 'EH6 7RE'
            }
        },
        'Edinburgh' => new List<Map<String, String>>{
            new Map<String, String> {
                'street' => 'Unit 1-3, Eastern Industrial Estate, 62-66 Newcraighall Road',
                'city' => 'Edinburgh',
                'state' => 'Lothian',
                'country' => 'Scotland',
                'postalCode' => 'EH15 3HS'
            }
        },
        'Glasgow' => new List<Map<String, String>>{
            new Map<String, String> {
                'street' => '9 Canal Street',
                'city' => 'Glasgow',
                'state' => 'Lanarkshire',
                'country' => 'Scotland',
                'postalCode' => 'G4 0AD'
            }
        },
        'Wales' => new List<Map<String, String>>{
            new Map<String, String> {
                'street' => 'Unit 1-2, Davis Street',
                'city' => 'Cardiff',
                'state' => 'Glamorgan',
                'country' => 'Wales',
                'postalCode' => 'CF24 2FU'
            }
        },
        'Cardiff' => new List<Map<String, String>>{
            new Map<String, String> {
                'street' => 'Unit 1-2, Davis Street',
                'city' => 'Cardiff',
                'state' => 'Glamorgan',
                'country' => 'Wales',
                'postalCode' => 'CF24 2FU'
            }
        },
        'Swansea' => new List<Map<String, String>>{
            new Map<String, String> {
                'street' => 'Ashford House, Abergelly Road, Swansea West Industrial Estate',
                'city' => 'Swansea',
                'state' => 'Glamorgan',
                'country' => 'Wales',
                'postalCode' => 'SA54DY'
            }
        },
        'Derby' =>  new List<Map<String, String>>{
            new Map<String, String> {
                'street' => '22 Crown Walk, West Mall,, Intu Centre',
                'city' => 'Derby',
                'state' => 'Derbyshire',
                'country' => 'England',
                'postalCode' => 'DE1 2NP'
            }
        },
        'Evesham' =>  new List<Map<String, String>>{
            new Map<String, String> {
                'street' => '24 Bridge Street',
                'city' => 'Evesham',
                'state' => 'Worcestershire',
                'country' => 'England',
                'postalCode' => 'WR11 4RR'
            }
        },
        'London' =>  new List<Map<String, String>>{
            new Map<String, String> {
                'street' => '114 Strand',
                'city' => 'London',
                'state' => 'Greater London',
                'country' => 'England',
                'postalCode' => 'WC2R 0AG'
            }
        },
        'Manchester' =>  new List<Map<String, String>>{
            new Map<String, String> {
                'street' => '24 Briar Hill Way',
                'city' => 'Salford',
                'state' => 'Greater Manchester',
                'country' => 'England',
                'postalCode' => 'M6 5FD'
            }
        },
        'Chichester' => new List<Map<String, String>>{
            new Map<String, String> {
                'street' => '21 College Lane',
                'city' => 'Chichester',
                'state' => 'West Sussex',
                'country' => 'England',
                'postalCode' => 'PO19 6PE'
            }
        },
        'Worcester' => new List<Map<String, String>>{
            new Map<String, String> {
                'street' => '9-13 Pump Street',
                'city' => 'Worcester',
                'state' => 'Worcestershire',
                'country' => 'England',
                'postalCode' => 'WR1 2QX'
            }
        },
        'Birmingham' => new List<Map<String, String>>{
            new Map<String, String> {
                'street' => 'Unit 31 Stephenson Place',
                'city' => 'Birmingham',
                'state' => 'West Midlands',
                'country' => 'England',
                'postalCode' => 'B2 4BF'
            }
        },
        'Lewes' => new List<Map<String, String>>{
            new Map<String, String> {
                'street' => 'Unit 3 The Friars',
                'city' => 'Lewes',
                'state' => 'East Sussex',
                'country' => 'England',
                'postalCode' => 'BN7 2LE'
            }
        },
        'Solihull' => new List<Map<String, String>>{
            new Map<String, String> {
                'street' => '8 Crescent Arcade Touchwood Centre',
                'city' => 'Solihull',
                'state' => 'West Midlands',
                'country' => 'England',
                'postalCode' => 'B91 3GZ'
            }
        },
        'Warrington' => new List<Map<String, String>>{
            new Map<String, String> {
                'street' => 'SU50 Golden Square 48 The Mall',
                'city' => 'Warrington',
                'state' => 'Cheshire',
                'country' => 'England',
                'postalCode' => 'WA1 1QP'
            }
        },
        'Cafe' => new List<Map<String, String>>{
            new Map<String, String> {
                'street' => 'Palatine Centre, 4 Stockton Rd',
                'city' => 'Durham',
                'state' => 'Durham',
                'country' => 'England',
                'postalCode' => 'DH1 3DX'
            }
        },
        'Club' => new List<Map<String, String>>{
            new Map<String, String> {
                'street' => '36-38 Mosley St',
                'city' => 'Newcastle upon Tyne',
                'state' => 'Tyne and Wear',
                'country' => 'England',
                'postalCode' => 'NE1 1DF'
            }
        },
        'Deli' => new List<Map<String, String>>{
            new Map<String, String> {
                'street' => '65 Main St',
                'city' => 'Bingley',
                'state' => 'West Yorkshire',
                'country' => 'England',
                'postalCode' => 'BD16 2HZ'
            }
        },
        'Works' => new List<Map<String, String>>{
            new Map<String, String> {
                'street' => '29 Hurlbutt Rd, Heathcote Industrial Estate',
                'city' => 'Leamington Spa',
                'state' => 'Warwickshire',
                'country' => 'England',
                'postalCode' => 'CV34 6TB'
            }
        },
        'Styles' => new List<Map<String, String>>{
            new Map<String, String> {
                'street' => '26 Southgate',
                'city' => 'Chichester',
                'state' => 'West Sussex',
                'country' => 'England',
                'postalCode' => 'PO19 1ES'
            }
        },
        'Shed' => new List<Map<String, String>>{
            new Map<String, String> {
                'street' => 'Hartley House',
                'city' => 'Gretton',
                'state' => 'Gloucestershire',
                'country' => 'England',
                'postalCode' => 'GL54 2AL'
            }
        },
        'Room' => new List<Map<String, String>>{
            new Map<String, String> {
                'street' => 'New Market, King Street',
                'city' => 'Maidenhead',
                'state' => 'Berkshire',
                'country' => 'England',
                'postalCode' => 'SL6 1DS'
            }
        },
        'Restaurant' => new List<Map<String, String>>{
            new Map<String, String> {
                'street' => '36-38 Mayflower St',
                'city' => 'Plymouth',
                'state' => 'Devon',
                'country' => 'England',
                'postalCode' => 'PL1 1QX'
            }
        }
    };

    static List<Opportunity> opportunities = new List<Opportunity>();
    static List<Quote> quotes = new List<Quote>();

    List<Node> nodes = new List<Node>();
    public class Node
    {
        public Account businessAccount;
        public List<Contact> businessContacts;
        public List<Contract> businessContracts;

        public Account serviceAccount;

        public Account billingAccount;

        public vlocity_cmt__Premises__c premises;
        public List<vlocity_cmt__ServicePoint__c> servicePoints;
    }

    public List<Account> setupLargeHierarchyAccounts()
    {
        // If it breaks for SOQL query limit, we can split it in 2 runs. 
        //  comment r3Office nodes in first run
        //  execute only r3Office nodes in next run, pass the head-office's business account Id as parent
        preSetup();
        matchAccountName = 'National Storage';
        accountIndustry = 'Retail';
        //Each level to have Business + Billing + Service Account
        //1 Premises (linked to Service Account), 2 service points per premises (1 Elec, 1 Gas)
        
        //Head-office
        Node headoffice = createNode(null, 'National Storage Head Office', true, 5);

        //Regional-office
        Node r1Office = createNode(headoffice.businessAccount.Id, 'National Storage England', true, 3, 2);
        Node r2Office = createNode(headoffice.businessAccount.Id, 'National Storage Scotland', true, 3, 2);
        Node r3Office = createNode(headoffice.businessAccount.Id, 'National Storage Wales', true, 3, 2);

        //City-office
        nodes.add(createNode(r1Office.businessAccount.Id, 'National Storage Bristol', true, 2));
        nodes.add(createNode(r1Office.businessAccount.Id, 'National Storage Coventry', true, 2));
        nodes.add(createNode(r1Office.businessAccount.Id, 'National Storage Luton', true, 2));
        nodes.add(createNode(r1Office.businessAccount.Id, 'National Storage Peterborough', true, 2));

        nodes.add(createNode(r2Office.businessAccount.Id, 'National Storage Edinburgh', true, 2));
        nodes.add(createNode(r2Office.businessAccount.Id, 'National Storage Glasgow', true, 2));

        nodes.add(createNode(r3Office.businessAccount.Id, 'National Storage Cardiff', true, 2));
        nodes.add(createNode(r3Office.businessAccount.Id, 'National Storage Swansea', true, 2));

        updateAccountContactIds();
        nodes.addAll(new List<Node>{headoffice,r1Office,r2Office,r3Office});

        for (Node node: nodes)
        {
            accList.add(node.businessAccount);
        }
        createOpptyQuoteBundle();

        postSetup();
        return accList;

    }

    public List<Account> setupMediumHierarchyAccounts()
    {
        preSetup();
        accountIndustry = 'Apparel';
        matchAccountName = 'SpecSavers';

        User temp = users[0];
        users[0] = users[1];
        users[1] = temp;
        locToAddress.get('Office').remove(0);
        locToAddress.get('Office').add(new Map<String, String> {
                'street' => 'Foley House, Unit 4, Foley Grove, Foley Business Park',
                'city' => 'Kidderminster',
                'state' => 'Worcestershire',
                'country' => 'England',
                'postalCode' => 'DY11 7PT'
            });
        //Each level to have Business + Billing + Service Account
        //1 Premises (linked to Service Account), 2 service points per premises (1 Elec, 1 Gas)
        
        //Agent userId: 0054x0000050x1k, 0054x0000050xm7
        //Head-office
        Node headoffice = createNode(null, 'SpecSavers Head Office', true, 5, 2);

        //City-office
        nodes.add(createNode(headoffice.businessAccount.Id, 'SpecSavers Derby', true, 2));
        nodes.add(createNode(headoffice.businessAccount.Id, 'SpecSavers Evesham', true, 2));
        nodes.add(createNode(headoffice.businessAccount.Id, 'SpecSavers London', true, 2));
        nodes.add(createNode(headoffice.businessAccount.Id, 'SpecSavers Manchester', true, 2));
        nodes.add(createNode(headoffice.businessAccount.Id, 'SpecSavers Worcester', true, 2));

        updateAccountContactIds();
        nodes.addAll(new List<Node>{headoffice});

        for (Node node: nodes)
        {
            accList.add(node.businessAccount);
        }
        createOpptyQuoteBundle();

        postSetup();
        return accList;

    }

    public List<Account> setupMediumHierarchyAccounts2()
    {
        preSetup();
        accountIndustry = 'Retail';
        matchAccountName = 'Paper Chase';

        User temp = users[0];
        users[0] = users[2];
        users[2] = temp;
        locToAddress.get('Office').remove(0);
        locToAddress.get('Office').add(new Map<String, String> {
                'street' => 'Farringdon',
                'city' => 'London',
                'state' => 'Greater London',
                'country' => 'England',
                'postalCode' => 'EC1M 5TX'
            });
        locToAddress.get('London').remove(0);
        locToAddress.get('London').add(new Map<String, String> {
                'street' => 'Unit C 107 Cheapside',
                'city' => 'London',
                'state' => 'Greater London',
                'country' => 'England',
                'postalCode' => 'EC2V 6DN'
            });

        //Each level to have Business + Billing + Service Account
        //1 Premises (linked to Service Account), 2 service points per premises (1 Elec, 1 Gas)
        
        //Agent userId: 0054x0000050x1k, 0054x0000050xm7
        //Head-office
        Node headoffice = createNode(null, 'Paper Chase Head Office', true, 5, 2);

        //City-office
        nodes.add(createNode(headoffice.businessAccount.Id, 'Paper Chase Birmingham', true, 2));
        nodes.add(createNode(headoffice.businessAccount.Id, 'Paper Chase Lewes', true, 2));
        nodes.add(createNode(headoffice.businessAccount.Id, 'Paper Chase London', true, 2));
        nodes.add(createNode(headoffice.businessAccount.Id, 'Paper Chase Solihull', true, 2));
        nodes.add(createNode(headoffice.businessAccount.Id, 'Paper Chase Warrington', true, 2));

        updateAccountContactIds();
        nodes.addAll(new List<Node>{headoffice});

        for (Node node: nodes)
        {
            accList.add(node.businessAccount);
        }
        createOpptyQuoteBundle();

        postSetup();
        return accList;

    }

    public void setupStandaloneAccount(String name, String industry)
    {
        preSetup();
        accountIndustry = industry;
        matchAccountName = name;
        nodes.clear();
        accList.clear();
        opportunities.clear();
        quotes.clear();
        Integer contactCount = 4;
        Double random = Math.random();
        if (random<0.3)
        {
            contactCount = 5;
            User temp = users[0];
            users[0] = users[1];
            users[1] = temp;
        }
        else if (random>=0.3 && random <0.6)
        {
            contactCount = 2;
            User temp = users[0];
            users[0] = users[2];
            users[2] = temp;
        }

        Node node = createNode(null, name, true, contactCount, 2);
        updateAccountContactIds(new List<Account>{node.businessAccount, node.serviceAccount, node.billingAccount});
        accList.add(node.businessAccount);
        createOpptyQuoteBundle();

        postSetup();
    }


    public void setupStandaloneAccounts()
    {
        setupStandaloneAccount('Hair Styles', 'Hospitality');
        setupStandaloneAccount('Granite Works', 'Hospitality');
        setupStandaloneAccount('The Deli', 'Hospitality');

        setupStandaloneAccount('University Cafe', 'Hospitality');
        setupStandaloneAccount('Geordie Club', 'Hospitality');
    }

    public void setupStandaloneAccounts2()
    {
        locToAddress.get('Works').remove(0);
        locToAddress.get('Works').add(new Map<String, String> {
                'street' => '5, Queens Arcade',
                'city' => 'Leeds',
                'state' => 'West Yorkshire',
                'country' => 'England',
                'postalCode' => 'LS1 6LF'
            });
        locToAddress.get('Cafe').remove(0);
        locToAddress.get('Cafe').add(new Map<String, String> {
                'street' => 'Palatine Centre, 4 Stockton Rd',
                'city' => 'Durham',
                'state' => 'Durham',
                'country' => 'England',
                'postalCode' => 'DH1 3DX'
            });

        setupStandaloneAccount('Leather Works', 'Hospitality');
        setupStandaloneAccount('The Chip Shed', 'Hospitality');
        setupStandaloneAccount('Maggies Tea Room', 'Hospitality');
        setupStandaloneAccount('Corner Cafe', 'Hospitality');
        setupStandaloneAccount('Pier Head Restaurant', 'Hospitality');
    }

    private void preSetup()
    {
        //Turn off Party-trigger
        //Todo: update list,query
        List<String> profiles = new List<String>{'Sales Agent', 'Sales Team Lead'};
        users = [select Id from user where Profile.Name in :profiles And isActive = true];
    }

    private void postSetup()
    {
        //Turn on Party-trigger
    }

    private Node createNode(Id parentAccountId, String name, Boolean hasBillingAccount, Integer contactCount)
    {
        return createNode(parentAccountId, name, hasBillingAccount, 'Corporate Tower', contactCount, 0);
    }

    private Node createNode(Id parentAccountId, String name, Boolean hasBillingAccount, Integer contactCount, Integer contractCount)
    {
        return createNode(parentAccountId, name, hasBillingAccount, 'Corporate Tower', contactCount, contractCount);
    }

    private Node createNode(Id parentAccountId, String name, Boolean hasBillingAccount, String premisesName, Integer contactCount, Integer contractCount)
    {
        Node node = new Node();
        node.businessContacts = new List<Contact>();
        node.businessContracts = new List<Contract>();
        node.businessAccount = formNewAccount(name, 'Business');
        for (Integer i=0;i<contactCount;i++)
        {
            node.businessContacts.add(formNewContact());
        }

        node.serviceAccount = formNewAccount(name, 'Service');

        if (null != parentAccountId)
        {
            node.businessAccount.ParentId = parentAccountId;
        }
        if (hasBillingAccount)
        {
            node.billingAccount = formNewAccount(name, 'Billing');
        }
        System.debug(node);
        insertAccounts(node);
        for (Contact c: node.businessContacts)
        {
            c.AccountId = node.businessAccount.Id;
        }

        Insert node.businessContacts;

        node.businessContracts.addAll(formNewContracts(node.businessAccount, contractCount));
        insert node.businessContracts;
        Date dateI = Date.newInstance(2020, 1, 1);
        Integer years = 1;
        for (Contract c: node.businessContracts)
        {
            c.StartDate = dateI.addYears(years++);
            c.Status = 'Activated';
        }
        update node.businessContracts;

        //1 Premises (linked to Service Account), 2 service points per premises (1 Elec, 1 Gas)
        node.premises = formPremises(premisesName, node.serviceAccount);
        insert node.premises;

        node.servicePoints = formServicePoints(node.premises);
        insert node.servicePoints;

        node.serviceAccount.vlocity_cmt__PremisesId__c =  node.premises.Id;
        update node.serviceAccount;
        return node;
    }

    private void insertAccounts(Node node)
    {
        insert node.businessAccount;

        node.serviceAccount.ParentId = node.businessAccount.Id;

        List<Account> accounts = new List<Account>();

        accounts.add(node.serviceAccount);

        if (null != node.billingAccount)
        {
            node.billingAccount.ParentId = node.businessAccount.Id;
            accounts.add(node.billingAccount);
            //System.debug()
        }
       // System.debug(accounts);
        insert accounts;
    }

    private static Contact formNewContact()
    {
        List<String> fname = new List<String>{'Mason', 'Jackson',   'Harper', 'Jack', 'Avery', 'Wyatt', 'Carter', 'Grayson', 'Lincoln', 'Hudson', 'Riley', 'Madison', 'Jaxon', 'Parker', 'Hazel', 'Hunter', 'Colton', 'Landon', 'Cooper', 'Easton', 'Everly',   'Addison', 'Jameson', 'Sawyer', 'Greyson', 'Willow', 'River', 'Jaxson', 'Everett', 'Ivy', 'Wesley', 'Kinsley', 'Audrey', 'Waylon', 'Ryder', 'Weston', 'Ruby', 'Emery', 'Hayden', 'Harrison', 'Kingston', 'Hailey',  'Autumn', 'Blake', 'Emerson', 'Myles', 'Tyler', 'Piper', 'Ashton', 'Milo'};
        Integer fnameSize = fname.size()-1;
        List<String> lname = new List<String>{'Adams', 'Wilson', 'Burton', 'Harris', 'Stevens', 'Robinson', 'Lewis', 'Walker', 'Payne', 'Baker', 'Owen', 'Holmes', 'Chapman',   'Webb', 'Allen', 'Jones', 'Davidson', 'Foster', 'Matthews', 'White', 'Griffiths', 'Knight', 'Corbyn', 'Young', 'Evans', 'Smith', 'Wright', 'Jenkins', 'Green',  'Hughes', 'Taylor', 'Hall', 'Anderson', 'Armstrong', 'Cox', 'Atkinson', 'Bell', 'Carter', 'Cole', 'Collins', 'Dawson', 'Bailey', 'Ball', 'Dixon', 'Edwards', 'Brown', 'Clarke', 'Yates', 'Zelly', 'Zouch', 'Fisher', 'Fletcher'};
        Integer lnameSize = lname.size()-1;
        //To-Do: city, state, pin based on location
        List<String> city = new List<String>{'Bath', 'Birmingham', 'Bradford', 'Brighton and Hove', 'Bristol', 'Cambridge', 'Canterbury', 'Carlisle',  'Chester', 'Chelmsford', 'Chichester', 'Coventry', 'Derby', 'Durham', 'Ely', 'Exeter', 'Gloucester', 'Hereford', 'Kingston upon Hull', 'Lancaster', 'Leeds', 'Leicester', 'Lichfield', 'Lincoln', 'Liverpool', 'London', 'Manchester', 'Norwich', 'Nottingham', 'Oxford', 'Peterborough', 'Plymouth', 'Portsmouth', 'Preston', 'Ripon', 'Salford', 'Salisbury', 'Sheffield', 'Southampton', 'St Albans', 'Sunderland', 'Truro', 'Wakefield', 'Wells', 'Westminster', 'Winchester', 'Wolverhampton', 'Worcester', 'York'};
        Integer citySize = city.size()-1;
        List<String> state = new List<String>{'Bedfordshire',   'Berkshire', 'Bristol', 'Buckinghamshire',  'Cambridgeshire', 'Cheshire',   'Cornwall', 'Cumbria',  'Derbyshire', 'Devon', 'Dorset', 'County Durham', 'East Sussex', 'Essex', 'Gloucestershire', 'Greater Manchester', 'Hampshire', 'Herefordshire', 'Hertfordshire', 'Isle of Wight', 'Kent', 'Lancashire', 'Leicestershire', 'Lincolnshire', 'London', 'Merseyside', 'Norfolk', 'North Yorkshire', 'Northamptonshire', 'Northumberland', 'Nottinghamshire', 'Oxfordshire', 'Rutland', 'Shropshire', 'Somerset', 'South Yorkshire', 'Staffordshire', 'Suffolk', 'Surrey', 'Tyne and Wear', 'Warwickshire', 'West Midlands', 'West Sussex', 'West Yorkshire', 'Wiltshire', 'Worcestershire', 'Winchester', 'Wolverhampton', 'Worcester'};
        Integer stateSize = state.size()-1;
        List<String> pincode = new List<String>{'CF62 9HE', 'EH12 8SS', 'LN2 2RY', 'S2 3AW', 'NG17 8NL', 'DN8 4LJ', 'NE9 6RD', 'DT6 3EA', 'M3 6BB', 'CH45 8NW', 'AB10 7AJ', 'W1S 1NG', 'PL3 4QR',   'ST7 2YF', 'AL8 7RB', 'SG2 9PS', 'BT67 9AU', 'TF1 6JZ', 'NE49 9JZ', 'PR26 6QE', 'CB5 8QR',  'TN25 4DB', 'PL1 5AF', 'G14 0NN', 'PE22 0UH', 'SE1P 5YF', 'WA2 7QL', 'BN17 5EE', 'BT41 2RZ', 'NG8 6AU', 'BD22 6QJ', 'M26 3WJ', 'HA9 7QH', 'BT79 0PR', 'IP3 9NF', 'BL3 3JQ', 'PE32 2BT', 'SS8 9EW',  'LS23 6ZA', 'HU11 5BN', 'AL7 2DJ', 'LS17 5HX', 'TN31 7QH', 'PR3 0YY', 'EX4 5EB', 'GL5 4TF', 'DH7 0EB',  'SE4 2NH', 'W5 4SG', 'HR8 2GL'};
        Integer pinSize = pincode.size()-1;

        Contact ct = new Contact();
        Integer randomfname = Integer.valueOf(Math.random()*fnameSize);
        Integer randomlname = Integer.valueOf(Math.random()*lnameSize);
        Integer randomcity = Integer.valueOf(Math.random()*citySize);
        Integer randomstate = Integer.valueOf(Math.random()*stateSize);
        Integer randompin = Integer.valueOf(Math.random()*pinSize);

        ct.Birthdate = Date.newInstance((Integer.valueOf(Math.random()*20) + 1970),Integer.valueOf(Math.random()*10),Integer.valueOf(Math.random()*30));
        //ct.Description = 'Desc'+(concount+i+1);
        ct.Email = fname[randomfname]+'@'+lname[randomlname]+'.com';
        ct.FirstName = fname[randomfname];
        ct.LastName = lname[randomlname];
        ct.LeadSource = 'Web';
        ct.MailingStreet = Integer.valueOf(1 + Math.random()*100) + ', Street';
        ct.MailingCity = city[randomcity];
        ct.MailingState = state[randomstate];
        ct.MailingCountry = 'UK';
        ct.MailingPostalCode = pincode[randompin];
        ct.OtherStreet = ct.MailingStreet;
        ct.OtherCity = ct.MailingCity;
        ct.OtherState = ct.MailingState;
        ct.OtherCountry = 'UK';
        ct.OtherPostalCode = ct.MailingPostalCode;
        ct.MobilePhone = '0' + (Integer.valueOf(Math.random()*100000000) + 100000000);
        ct.HomePhone = ct.MobilePhone;
        ct.Phone = ct.MobilePhone;
        ct.Salutation = 'Mr.';
        ct.put(NSP + 'IsActive__c', true);

        return ct;
    }

    private static List<Contract> formNewContracts(Account a, Integer count)
    {
        List<Contract> ctrs = new List<Contract>();
        for (Integer i = count; i>0; i--)
        {
            Contract ctr = new Contract();
            ctr.AccountId = a.Id;
            ctr.ContractTerm = Integer.valueOf(12);
            //ctr.CurrencyIsoCode = 'USD';
            ctrs.add(ctr);
        }

        return ctrs;
    }

    private static Account formNewAccount(String name, String recType)
    {
        //name = 'A4: ' + name;
        String recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recType).getRecordTypeId();
        //List<String> industry = new List<String>{'Engineering', 'Banking', 'Electronics', 'Chemicals', 'Communications', 'Construction'};
        Map<String, String> addr = getAddress(name);
        Account ac = new Account();
        ac.AccountNumber = 'AC'+Integer.valueOf(Math.random()*1000000000);
        ac.BillingStreet = addr.get('street');
        ac.BillingCity = addr.get('city');
        ac.BillingState = addr.get('state');
        ac.BillingCountry = addr.get('country');
        ac.BillingPostalCode = addr.get('postalCode');
        ac.Industry = String.isBlank(accountIndustry) ? 'Retail' : accountIndustry;
        //ac.Industry = accountIndustry; //industry[Integer.valueOf(Math.random()*(industry.size()-1))];
        ac.Name = name ;//+ ' (' + recType + ')';
        ac.Ownership = 'Private';
        ac.Phone = '0'+(Integer.valueOf(Math.random()*100000000) + 100000000);
        ac.RecordTypeId = recTypeId;
        ac.ShippingStreet = addr.get('street');
        ac.ShippingCity = addr.get('city');
        ac.ShippingState = addr.get('state');
        ac.ShippingCountry = addr.get('country');
        ac.ShippingPostalCode = addr.get('postalCode');
        ac.put(NSP + 'AccountPaymentType__c', 'Prepaid');
        ac.put(NSP + 'BillCycle__c', '1');
        ac.put(NSP + 'BillDeliveryMethod__c', 'Paper Billing');
        ac.put(NSP + 'BillFormat__c', 'Summary');
        ac.put(NSP + 'BillFrequency__c', 'Monthly');
        // ac.put(NSP + 'BillingEmailAddress__c', ct.Email);
        ac.put(NSP + 'ContactPreferences__c', 'eMail;Phone');
        ac.put(NSP + 'CustomerClass__c', 'Residential');
        ac.put(NSP + 'IsRootResolved__c', false);
        // ac.put(NSP + 'PrimaryContactId__c', ct.Id);
        ac.put(NSP + 'Status__c', 'Active');
        ac.put(NSP + 'TaxExemptionType__c', 'Non-exempt');
        ac.put(NSP + 'TaxID__c', '' + (Integer.valueOf(Math.random()*100000000) + 100000000));

        return ac;
    }

    private vlocity_cmt__Premises__c formPremises(String premName, Account ac)
    {
        vlocity_cmt__Premises__c prem = (vlocity_cmt__Premises__c)Schema.getGlobalDescribe().get(NSP + 'Premises__c').newSObject();
        prem.put('Name', ac.ShippingStreet);
        prem.put(NSP + 'City__c', ac.ShippingCity);
        prem.put(NSP + 'PostalCode__c', ac.ShippingPostalCode);
        prem.put(NSP + 'State__c', ac.ShippingState);
        prem.put(NSP + 'StreetAddress__c', ac.ShippingStreet);
        prem.put(NSP + 'Country__c', ac.ShippingCountry);
        prem.put(NSP + 'PremisesNumber__c', 'PN' + Integer.valueOf(Math.random()*1000000));
        prem.put(NSP + 'PremisesIdentifier__c', '' + Integer.valueOf(Math.random()*1000000));
        return prem;
    }

    private List<vlocity_cmt__ServicePoint__c> formServicePoints(vlocity_cmt__Premises__c prem)
    {
        List<vlocity_cmt__ServicePoint__c> sps = new List<vlocity_cmt__ServicePoint__c>();
        List<String> servTypes = new List<String>{'Electricity', 'Gas'}; //, 'Water'
        List<String> voltLevels = new List<String>{'Low', 'Medium', 'High', 'High'};
        List<String> utilityProvider = new List<String>{'Aqua America', 'Crystal Geiser', '4Change', 'Champion Energy', 'Bounce Energy', 'Southern Company', 'Georgia Gas', 'Pacific Gas and Electric', 'Georgia Gas'};
        Integer i =1;
        for (String servType : servTypes)
        {
            String voltLevel = voltLevels[Integer.valueOf((Math.random()*voltLevels.size()))];
            SObject sp = Schema.getGlobalDescribe().get(NSP + 'ServicePoint__c').newSObject();
            sp.put('Name', (String)prem.get('Name') + ' Floor ' + (i++));
            sp.put(NSP + 'PremisesId__c', prem.Id);
            sp.put(NSP + 'ServiceType__c', servType);
            sp.put(NSP + 'ServicePointNumber__c', 'SP' + Integer.valueOf(Math.random()*1000000));
            sp.put(NSP + 'ActivationDate__c', Date.Today());
            sp.put(NSP + 'AverageMonthlyUsage__c', Integer.valueOf((Math.random()*10000)));
            sp.put(NSP + 'LoadProfile__c', 'Residential ' + voltLevel); //Use Residential or SMB
            sp.put(NSP + 'MarketIdentifier__c', String.valueOf(Math.abs(Integer.valueOf(Math.random()*1000000000) * 1000)));
            sp.put(NSP + 'UtilityProvider__c', utilityProvider[Integer.valueOf((Math.random()*utilityProvider.Size()))]);

            if (servType == 'Electricity')
            {
                sp.put(NSP + 'VoltageLevel__c', voltLevel);
            }
            sps.add((vlocity_cmt__ServicePoint__c)sp);
        }
        return sps;
    }

    private static Map<String, String> getAddress(String name)
    {
        List<String> temp = name.split(' ');
        String office = temp[temp.size() -1];
        return locToAddress.get(office)[0];
    }

    public void createOpptyQuoteBundle()
    {
        String businessAcTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        for (Account ac: accList)
        {
            if (ac.RecordTypeId == businessAcTypeId)
            {
                Integer openOpptyCount = Integer.valueof(Math.random() * 3) + 1;
                Boolean headOffice = false, countryOffice = false;
                if (ac.Name.contains('Head'))
                {
                    headOffice = true;
                }
                else if (ac.Name.contains('England') || ac.Name.contains('Scotland') || ac.Name.contains('Wales'))
                {
                    countryOffice = true;
                }

                for (Integer i=openOpptyCount; i>0; i--)
                {
                    Opportunity op = formNewOpportunity(ac);
                    op.ownerId = (headOffice || countryOffice) ? users[0].Id : (Math.random()<0.5? users[1].Id: users[2].Id);
                    opportunities.add(op);
                }
                Integer closedOpptyCount = headOffice ? 4: (countryOffice ? 2 : 1);
                for (Integer i=closedOpptyCount; i>0; i--)
                {
                    Opportunity op = formNewOpportunity(ac);
                    op.ownerId = (headOffice || countryOffice) ? users[0].Id : (Math.random()<0.5? users[1].Id: users[2].Id);
                    op.StageName = i==closedOpptyCount ? 'Closed Won' : 'Closed Lost';
                    opportunities.add(op);
                }
            }
        }
        if (!opportunities.isEmpty())
        {
            insert opportunities;

            Integer quoteCount = 1 + Integer.valueof((Math.random() * 2));
            for (Opportunity oppty: opportunities)
            {
                for (Integer i=quoteCount; i>0; i--)
                {
                    Quote q = formNewQuote(oppty);
                    q.Name = oppty.Name + ' #' + i;
                    q.OwnerId = oppty.OwnerId;
                    if (oppty.StageName == 'Closed Won')
                    {
                        q.Status = i == quoteCount ? 'Accepted' : 'Rejected';
                    }
                    if (oppty.StageName == 'Closed Lost')
                    {
                        q.Status = 'Rejected';
                    }
                    quotes.add(q);
                }
            }
            if (!quotes.isEmpty())
            {
                insert quotes;
                String query = 'Select Id from PricebookEntry where Pricebook2Id = :pricebookId AND Product2.vlocity_cmt__isOrderable__c = true AND isActive = true Limit 1000';
                List<PricebookEntry> prods = Database.query(query);
                List<QuoteLineItem> xlis = new List<QuoteLineItem>();
                for (Quote quote: quotes)
                {
                    xlis.add(formNewQuoteLineItem(quote, prods[Integer.valueof((Math.random() * prods.size()))]));
                }
                insert xlis;
            }
        }
    }

    private Opportunity formNewOpportunity(Account ac)
    {
        List<String> stages = new List<String>{'Prospecting', 'Qualification', 'Needs Analysis', 'Value Proposition', 'Id. Decision Makers', 'Perception Analysis', 'Proposal/Price Quote', 'Negotiation/Review'};// , 'Closed Won', 'Closed Lost'
        List<String> nameSuffixes = new List<String>{'Installations', 'FY', 'Monthly', 'Charges', 'SLA', 'Small Deal', 'Medium Deal', 'Large Deal', 'Emergency Generator', 'Lab Generators', 'Office Portable Generators', 'Portable Truck Generators', 'Standby Generators', 'Refinery Generators'};
        List<String> types = new List<String>{'Existing Customer - Upgrade', 'Existing Customer - Replacement', 'Existing Customer - Downgrade', 'New Customer'};
        List<String> months = new List<String>{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
        Opportunity op = new Opportunity();
        op.closeDate = Date.newInstance((Integer.valueOf(Math.random()*1) + 2021), Integer.valueOf(Math.random()*10),Integer.valueOf(Math.random()*30));
        op.Name = ac.Name + ' ' + months[op.closeDate.month()-1] + op.closeDate.year();
        op.Description = op.Name;
        op.AccountId = ac.Id;
        op.StageName = stages[Integer.valueof((Math.random() * stages.size()))];
        op.amount = 1000 * Integer.valueOf(Math.random()*1000);
        op.Type = types[Integer.valueof((Math.random() * types.size()))];

        return op;
    }

    private Quote formNewQuote(Opportunity op)
    {
        List<String> allStatus = new List<String>{'Draft', 'In Review', 'Needs Review', 'Approved', 'Rejected', 'Presented', 'Accepted', 'Denied'};
        Quote quote = new Quote();
        quote.Name = 'Quote For ' + op.Name;
        quote.OpportunityId = op.Id;
        quote.Status = allStatus[Integer.valueof((Math.random() * allStatus.size()))];
        quote.vlocity_cmt__NumberOfContractedMonths__c = Integer.valueOf(Math.random()*100);
        quote.pricebook2Id = pricebookId;
        return quote;
    }

    private QuoteLineItem formNewQuoteLineItem(Quote quote, PricebookEntry pbe)
    {
        QuoteLineItem item = new QuoteLineItem();
        item.QuoteId = quote.Id;
        item.PricebookEntryId = pbe.Id;
        item.Quantity = 1 + 10 * Integer.valueOf(Math.random()*100);
        item.UnitPrice = 1 + 100 * Integer.valueOf(Math.random()*100);
        return item;
    }
   private void updateAccountContactIds(List<Account> accounts)
    {
        List<Id> accountIds = new List<Id>();
        for (Account a:accounts)
        {
            accountIds.add(a.Id);
        }
        List<Account> acs = new List<Account>();
        List<AccountContactRole> acRoles = new List<AccountContactRole>();

        //matchAccountName = 'A4: ' + matchAccountName + '%';
        List<Contact> cs = [Select Id, AccountId, Account.Name from Contact where AccountId IN :accountIds];
        Map<Id,Contact> aToc= new Map<Id, contact>();
        for (Contact c: cs)
        {
            aToc.put(c.AccountId, c);
        }
        for (Contact c:aToc.values())
        {
            Account a = new Account();
            a.Id = c.AccountId;
            a.vlocity_cmt__PrimaryContactId__c = c.Id;
            acs.add(a);
            acRoles.add(new AccountContactRole(accountId = a.Id, contactId = c.Id, IsPrimary= true, Role = 'Primary Contact'));

        }
        insert acRoles;
        update acs;
    }
    private void updateAccountContactIds()
    {
        List<Account> acs = new List<Account>();
        List<AccountContactRole> acRoles = new List<AccountContactRole>();

        List<Contact> cs = [Select Id, AccountId, Account.Name from Contact where Account.Name like :matchAccountName];
        Map<Id,Contact> aToc= new Map<Id, contact>();
        for (Contact c: cs)
        {
            aToc.put(c.AccountId, c);
        }
        for (Contact c:aToc.values())
        {
            Account a = new Account();
            a.Id = c.AccountId;
            a.vlocity_cmt__PrimaryContactId__c = c.Id;
            acs.add(a);
            acRoles.add(new AccountContactRole(accountId = a.Id, contactId = c.Id, IsPrimary= true, Role = 'Primary Contact'));

        }
        insert acRoles;
        update acs;
    }

    public void createBulkOpportunities(Id AccountId, Integer opptyCount)
    {
        Account ac = [Select Id, Name From Account where Id = :AccountId];
        for (Integer i=opptyCount; i>0; i--)
        {
            opportunities.add(formNewOpportunity(ac));
        }
        if (!opportunities.isEmpty())
        {
            insert opportunities;
            Integer quoteCount;
            for (Opportunity oppty: opportunities)
            {
                quoteCount = Integer.valueof((Math.random() * 5));
                for (Integer i=quoteCount; i>0; i--)
                {
                    quotes.add(formNewQuote(oppty));
                }
            }
            if (!quotes.isEmpty())
            {
                insert quotes;
                String query = 'Select Id from PricebookEntry where Pricebook2Id = :pricebookId AND Product2.vlocity_cmt__isOrderable__c = true and isActive =true Limit 1000 ';
                List<PricebookEntry> prods = Database.query(query);
                List<QuoteLineItem> xlis = new List<QuoteLineItem>();
                for (Quote quote: quotes)
                {
                    xlis.add(formNewQuoteLineItem(quote, prods[0]));
                }
                insert xlis;
            }
        }
    }


    private static Lead getNewLeadRecord()
    {
        List<String> lstatus = new List<String>{'New', 'Nurturing', 'Contacted', 'Qualified', 'Unqualified'};//New, Nurturing, Contacted, Qualified, Unqualified
        List<String> rstatus = new List<String>{'Contacted', 'Qalified'}; //Contacted, Qalified

        List<String> lrating = new List<String>{'Hot', 'Warm', 'Cold'};
        String jsonMap =  '[{"sal":"Mr","fName":"John","lName":"Jackson","company":"Marble Kitchens"},{"sal":"Mr","fName":"Faizel","lName":"Patel","company":"Coventry Hospital"},{"sal":"Mrs","fName":"Mary","lName":"Smith","company":"Bikers Tattoos"},{"sal":"Mr","fName":"Donghai","lName":"Zhao","company":"White Linen Company"},{"sal":"Ms","fName":"Ingrid","lName":"Scneider","company":"Midlands Dental Clinic"},{"sal":"Ms","fName":"Eleanor","lName":"Pickering","company":"Books on the Square"},{"sal":"Mr","fName":"Vincente","lName":"Fernandez","company":"World Tours Travel"},{"sal":"Mr","fName":"Jose","lName":"Rodriguez","company":"Sports World"},{"sal":"Bongani","fName":"Ibrahim","lName":"Mobile","company":"Fone Accessories"},{"sal":"Mrs","fName":"Janice","lName":"Green","company":"Corner Supermarket"},{"sal":"Mrs","fName":"Bhavna","lName":"Reddy","company":"Home Furnishings"},{"sal":"Mr","fName":"Yiannis","lName":"Georgiou","company":"Classic Car Sales"},{"sal":"Mr","fName":"Ric","lName":"Morales","company":"Used Keyboard Emporium"},{"sal":"Ms","fName":"Elena","lName":"Pandazopolous","company":"Elena’s Kitchen"},{"sal":"Mrs","fName":"Monique","lName":"Capel","company":"Hitech Software"},{"sal":"Mr","fName":"Ettiene","lName":"Garnier","company":"Bistrot Romaine"},{"sal":"Mrs","fName":"Ah","lName":"Lam","company":"Chen Oriental Supermarket"},{"sal":"Mr","fName":"Walter","lName":"Meyer","company":"Autorepair Shop"},{"sal":"Mrs","fName":"Mariana","lName":"Garcia","company":"Craftstore"},{"sal":"Ms","fName":"Imani","lName":"Ali","company":"Designer Dress Shop"}]';
        
        List<Map<String, Object>> cs = new List<Map<String, Object>>();
        List<Object> items = (List<Object>) JSON.deserializeUntyped(jsonMap);
        for(Object o: items)
        {
            cs.add((Map<String, Object>)o);
        }

        Lead l = new Lead();
        l.Status = lStatus[Integer.valueOf(Math.random() * lstatus.size())];
        l.Rating =lrating[Integer.valueOf(Math.random()*3)];
        l.OwnerId = users[Integer.valueOf(Math.random()*3)].Id;
        if (rstatus.contains(l.Status))
        {
            l.AnnualRevenue = 10*(65 + Math.random()* 1350); // 65 - 2 000, 000
            //l.CurrencyIsoCode = 'EUR';
        }
        Integer rand = Integer.valueOf(Math.random() * cs.size());
        l.FirstName = (String)cs[rand].get('fName');
        l.LastName = (String)cs[rand].get('lName');
        l.Salutation = (String)cs[rand].get('sal');
        l.company = (String)cs[rand].get('company');

        return l;
    }

    public void setupLeads()
    {
        preSetup();
        List<Lead> leads = new List<Lead>();
        for (Integer i=0; i<20; i++)
        {
            leads.add(getNewLeadRecord());
        }
        insert leads;
    }
}