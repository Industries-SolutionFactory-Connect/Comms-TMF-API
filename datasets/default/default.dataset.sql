BEGIN TRANSACTION;
CREATE TABLE "vlocity_cmt__AttributeCategory__c" (
	id INTEGER NOT NULL, 
	"vlocity_cmt__IsActive__c" VARCHAR(255), 
	"vlocity_cmt__ApplicableSubType__c" VARCHAR(255), 
	"vlocity_cmt__ApplicableTypes__c" VARCHAR(255), 
	"vlocity_cmt__ApplicableTypesFilter__c" VARCHAR(255), 
	"vlocity_cmt__LockedFlg__c" VARCHAR(255), 
	"vlocity_cmt__Code__c" VARCHAR(255), 
	"vlocity_cmt__ColorCode__c" VARCHAR(255), 
	"vlocity_cmt__Description__c" VARCHAR(255), 
	"vlocity_cmt__DisplaySequence__c" VARCHAR(255), 
	"vlocity_cmt__EffectiveUntilDate__c" VARCHAR(255), 
	"vlocity_cmt__EffectiveFromDate__c" VARCHAR(255), 
	"vlocity_cmt__DisplayFilter__c" VARCHAR(255), 
	"vlocity_cmt__GlobalKey__c" VARCHAR(255), 
	"vlocity_cmt__IndustryVertical__c" VARCHAR(255), 
	"Name" VARCHAR(255), 
	"vlocity_cmt__IsPrivate__c" VARCHAR(255), 
	"vlocity_cmt__Status__c" VARCHAR(255), 
	"vlocity_cmt__UIControlType__c" VARCHAR(255), 
	"vlocity_cmt__IsUserAttributesCreatedPrivate__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "vlocity_cmt__AttributeCategory__c" VALUES(1,'True','Product Attribute','Product2','','False','014a17c6-61a1-f484-f10a-7a67e371f991','','The Attribute defines the type of product','10.0','','','False','61ff949a-7be7-6a09-8c70-d8bd30f10d43','','Wearable','False','Draft','On-Off','False');
INSERT INTO "vlocity_cmt__AttributeCategory__c" VALUES(2,'True','Profile Attribute','Any','','False','TMForum','','','12.0','','','False','766c863e-35e6-c617-a247-54953f313816','','TMForum','False','Production','On-Off','False');
CREATE TABLE "vlocity_cmt__Attribute__c" (
	id INTEGER NOT NULL, 
	"vlocity_cmt__ActiveFlg__c" VARCHAR(255), 
	"vlocity_cmt__ApplicableToAllRecords__c" VARCHAR(255), 
	"vlocity_cmt__ApplicableToEntity__c" VARCHAR(255), 
	"vlocity_cmt__AttributeGroupType__c" VARCHAR(255), 
	"vlocity_cmt__IsCloneable__c" VARCHAR(255), 
	"vlocity_cmt__Code__c" VARCHAR(255), 
	"vlocity_cmt__Configurable__c" VARCHAR(255), 
	"vlocity_cmt__CopyMode__c" VARCHAR(255), 
	"vlocity_cmt__CustomConfigUiTemplate__c" VARCHAR(255), 
	"vlocity_cmt__Value__c" VARCHAR(255), 
	"vlocity_cmt__Description__c" VARCHAR(255), 
	"vlocity_cmt__DesignTime__c" VARCHAR(255), 
	"vlocity_cmt__DisplaySequence__c" VARCHAR(255), 
	"vlocity_cmt__EditMode__c" VARCHAR(255), 
	"vlocity_cmt__EffectiveUntilDate__c" VARCHAR(255), 
	"vlocity_cmt__EffectiveFromDate__c" VARCHAR(255), 
	"vlocity_cmt__IsEncrypted__c" VARCHAR(255), 
	"vlocity_cmt__ExcludeFromBasketCache__c" VARCHAR(255), 
	"vlocity_cmt__Filterable__c" VARCHAR(255), 
	"vlocity_cmt__GlobalKey__c" VARCHAR(255), 
	"vlocity_cmt__HelpText__c" VARCHAR(255), 
	"vlocity_cmt__isDefaultHidden__c" VARCHAR(255), 
	"Name" VARCHAR(255), 
	"vlocity_cmt__IsNotAssetizable__c" VARCHAR(255), 
	"vlocity_cmt__Overridable__c" VARCHAR(255), 
	"vlocity_cmt__IsPrivate__c" VARCHAR(255), 
	"vlocity_cmt__RunTime__c" VARCHAR(255), 
	"vlocity_cmt__UniqueNameField__c" VARCHAR(255), 
	"vlocity_cmt__ValueType__c" VARCHAR(255), 
	"vlocity_cmt__AttributeCategoryId__c" VARCHAR(255), 
	"vlocity_cmt__PicklistId__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(1,'True','False','','','True','ATT_RT_BT','True','','','','','','1.0','','','','False','False','True','ab63872a-21e6-7bea-92a9-8f6554650818','','False','Band Type','False','','False','','','Text','1','1');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(2,'True','False','','','True','TMF_Color-1_ATTR_35956','True','','','White','Color of the Firewall housing','','1.0','','','','False','False','True','71239162-511e-be59-4492-e1ab1a70492b','','False','Color-1','False','','False','','','string','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(3,'True','False','','','True','TMF_CLONED_01t5e000002XxBQAA0_B2CCmex_ATTR_HASDISCOUNT_CHAR_ATTR_64549','True','','','false','HasDiscount : Has Discount','','1.0','','','','False','False','True','383ae852-3779-a624-9f3d-9131201d3ba2','','False','CLONED_01t5e000002XxBQAA0_B2CCmex_ATTR_HASDISCOUNT_CHAR','False','','False','','','Checkbox','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(4,'True','False','','','True','TMF_NumberofPorts_ATTR_88950','True','','','8','The total Number of Ports for this product','','1.0','','','','False','False','True','e7092a9f-8253-4255-a776-6d5bab2604ca','','False','Number of Ports','False','','False','','','Number','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(5,'True','False','','','True','TMF_NumberofPorts_ATTR_38983','True','','','8','The total Number of Ports for this product','','1.0','','','','False','False','True','8f05fdf0-9749-91bd-64f8-557d254d8d85','','False','Number of Ports','False','','False','','','Number','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(6,'True','False','','','True','TMF_Color_ATTR_25727','True','','','Black','Color of the Firewall housing','','1.0','','','','False','False','True','705b1c1c-8fee-5a13-444c-4d2787c2d80f','','False','Color','False','','False','','','string','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(7,'True','False','','','True','TMF_CLONED_01t5e000002XxBQAA0_B2CCmex_ATTR_HASDISCOUNT_CHAR_ATTR_89073','True','','','false','HasDiscount : Has Discount','','1.0','','','','False','False','True','4ff6f332-3316-3dec-e2dd-7100ac7d46d8','','False','CLONED_01t5e000002XxBQAA0_B2CCmex_ATTR_HASDISCOUNT_CHAR','False','','False','','','Checkbox','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(8,'True','False','','','True','TMF_NumberofPorts_ATTR_33827','True','','','8','The total Number of Ports for this product','','1.0','','','','False','False','True','2c5f6be5-d751-d30d-a7be-7f6c03cddad3','','False','Number of Ports','False','','False','','','Number','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(9,'True','False','','','True','TMF_Color-1_ATTR_92725','True','','','White','Color of the Firewall housing','','1.0','','','','False','False','True','7ce1c84e-10eb-bfd8-427f-e45afcd8f1a3','','False','Color-1','False','','False','','','string','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(10,'True','False','','','True','TMF_CLONED_01t5e000002XxBQAA0_B2CCmex_ATTR_HASDISCOUNT_CHAR_ATTR_42027','True','','','false','HasDiscount : Has Discount','','1.0','','','','False','False','True','2b760dc7-c78a-b084-07bc-3a0dcc60c446','','False','CLONED_01t5e000002XxBQAA0_B2CCmex_ATTR_HASDISCOUNT_CHAR','False','','False','','','Checkbox','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(11,'True','False','','','True','TMF_NumberofPorts_ATTR_76459','True','','','8','The total Number of Ports for this product','','1.0','','','','False','False','True','71dde9ef-06f6-f1cd-2954-c202b5c3b266','','False','Number of Ports','False','','False','','','Number','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(12,'True','False','','','True','TMF_NumberofPorts_ATTR_65547','True','','','8','The total Number of Ports for this product','','1.0','','','','False','False','True','926a6e06-4bd1-0e86-823a-0e78f7e8da80','','False','Number of Ports','False','','False','','','Number','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(13,'True','False','','','True','TMF_B2Bapp_ATTR_20919','True','','','Free','B2b ready go app','','1.0','','','','False','False','True','ae068846-e70b-91df-e1c4-fe665a42e4ea','','False','B2B app','False','','False','','','string','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(14,'True','False','','','True','TMF_NumberofPorts_ATTR_63853','True','','','8','The total Number of Ports for this product','','1.0','','','','False','False','True','e15ff965-ef02-b101-b0c3-726bdc17e02b','','False','Number of Ports','False','','False','','','Number','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(15,'True','False','','','True','TMF_Color-1_ATTR_82318','True','','','White','Color of the Firewall housing','','1.0','','','','False','False','True','28c4b210-ec85-4308-34d2-e344d5ecea74','','False','Color-1','False','','False','','','string','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(16,'True','False','','','True','TMF_CLONED_01t5e000002XxBQAA0_B2CCmex_ATTR_HASDISCOUNT_CHAR_ATTR_34516','True','','','false','HasDiscount : Has Discount','','1.0','','','','False','False','True','661b528c-887b-85a2-cd23-ff077d7c9e76','','False','CLONED_01t5e000002XxBQAA0_B2CCmex_ATTR_HASDISCOUNT_CHAR','False','','False','','','Checkbox','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(17,'True','False','','','True','TMF_Color_ATTR_35447','True','','','Black','Color of the Firewall housing','','1.0','','','','False','False','True','01816d3c-905e-90a7-ea5e-1e5b5fb999b1','','False','Color','False','','False','','','string','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(18,'True','False','','','True','TMF_CLONED_01t5e000002XxBQAA0_B2CCmex_ATTR_HASDISCOUNT_CHAR_ATTR_73477','True','','','false','HasDiscount : Has Discount','','1.0','','','','False','False','True','df1b1858-f1b3-bfd2-7d1b-e9ad24cbd63b','','False','CLONED_01t5e000002XxBQAA0_B2CCmex_ATTR_HASDISCOUNT_CHAR','False','','False','','','Checkbox','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(19,'True','False','','','True','TMF_NumberofPorts_ATTR_99467','True','','','8','The total Number of Ports for this product','','1.0','','','','False','False','True','5d7f2ad2-1596-8ad3-04d0-1ca482da1a02','','False','Number of Ports','False','','False','','','Number','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(20,'True','False','','','True','TMF_Color-1_ATTR_96660','True','','','White','Color of the Firewall housing','','1.0','','','','False','False','True','5022fc6d-0f09-bfc3-dac6-dffb6668c4e8','','False','Color-1','False','','False','','','string','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(21,'True','False','','','True','TMF_CLONED_01t5e000002XxBQAA0_B2CCmex_ATTR_HASDISCOUNT_CHAR_ATTR_53311','True','','','false','HasDiscount : Has Discount','','1.0','','','','False','False','True','d30bc9a4-943c-b76f-0574-12125c38a5f7','','False','CLONED_01t5e000002XxBQAA0_B2CCmex_ATTR_HASDISCOUNT_CHAR','False','','False','','','Checkbox','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(22,'True','False','','','True','TMF_NumberofPorts_ATTR_3600','True','','','8','The total Number of Ports for this product','','1.0','','','','False','False','True','e0d777ce-c4ca-aa5d-be76-e5a7572e08f6','','False','Number of Ports','False','','False','','','Number','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(23,'True','False','','','True','TMF_Color_ATTR_24760','True','','','Black','Color of the Firewall housing','','1.0','','','','False','False','True','0ffc9748-e72b-65fe-62d5-642639cfe358','','False','Color','False','','False','','','string','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(24,'True','False','','','True','TMF_CLONED_01t5e000002XxBQAA0_B2CCmex_ATTR_HASDISCOUNT_CHAR_ATTR_65687','True','','','false','HasDiscount : Has Discount','','1.0','','','','False','False','True','51ccdf43-4311-3404-3ff1-93960048d429','','False','CLONED_01t5e000002XxBQAA0_B2CCmex_ATTR_HASDISCOUNT_CHAR','False','','False','','','Checkbox','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(25,'True','False','','','True','TMF_NumberofPorts_ATTR_85172','True','','','8','The total Number of Ports for this product','','1.0','','','','False','False','True','f8365884-74ac-4355-1048-8bd5ea15859a','','False','Number of Ports','False','','False','','','Number','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(26,'True','False','','','True','TMF_Color_ATTR_36882','True','','','Black','Color of the Firewall housing','','1.0','','','','False','False','True','fb01f7b1-9605-0dc1-8508-0ce60269c85f','','False','Color','False','','False','','','string','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(27,'True','False','','','True','TMF_CLONED_01t5e000002XxBQAA0_B2CCmex_ATTR_HASDISCOUNT_CHAR_ATTR_79158','True','','','false','HasDiscount : Has Discount','','1.0','','','','False','False','True','cbb158d8-bdd5-28f5-22c9-ce878dd0433b','','False','CLONED_01t5e000002XxBQAA0_B2CCmex_ATTR_HASDISCOUNT_CHAR','False','','False','','','Checkbox','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(28,'True','False','','','True','TMF_NumberofPorts_ATTR_22327','True','','','8','The total Number of Ports for this product','','1.0','','','','False','False','True','b9cfd2d9-abe2-d497-52b1-b52e10878725','','False','Number of Ports','False','','False','','','Number','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(29,'True','False','','','True','TMF_Color_ATTR_83593','True','','','Black','Color of the Firewall housing','','1.0','','','','False','False','True','0a21a2b1-cd89-2016-4777-d11896bcae08','','False','Color','False','','False','','','string','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(30,'True','False','','','True','TMF_CLONED_01t5e000002XxBQAA0_B2CCmex_ATTR_HASDISCOUNT_CHAR_ATTR_26983','True','','','false','HasDiscount : Has Discount','','1.0','','','','False','False','True','d4e4b1ce-305f-2a29-0fcd-450f692ad650','','False','CLONED_01t5e000002XxBQAA0_B2CCmex_ATTR_HASDISCOUNT_CHAR','False','','False','','','Checkbox','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(31,'True','False','','','True','TMF_NumberofPorts_ATTR_10139','True','','','8','The total Number of Ports for this product','','1.0','','','','False','False','True','66d77890-5ccc-10c4-4711-e2023a5e865b','','False','Number of Ports','False','','False','','','Number','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(32,'True','False','','','True','TMF_Color-1_ATTR_68908','True','','','White','Color of the Firewall housing','','1.0','','','','False','False','True','a97344fb-be65-a443-5b9c-30b15684a554','','False','Color-1','False','','False','','','string','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(33,'True','False','','','True','TMF_CLONED_01t5e000002XxBQAA0_B2CCmex_ATTR_HASDISCOUNT_CHAR_ATTR_49404','True','','','false','HasDiscount : Has Discount','','1.0','','','','False','False','True','c6f5b123-93ff-4195-84dc-0a12e76c2abc','','False','CLONED_01t5e000002XxBQAA0_B2CCmex_ATTR_HASDISCOUNT_CHAR','False','','False','','','Checkbox','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(34,'True','False','','','True','TMF_NumberofPorts_ATTR_47873','True','','','8','The total Number of Ports for this product','','1.0','','','','False','False','True','9aa1aca7-0b85-793c-fc30-53b3166901ec','','False','Number of Ports','False','','False','','','Number','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(35,'True','False','','','True','TMF_Color_ATTR_2212','True','','','Black','Color of the Firewall housing','','1.0','','','','False','False','True','d72b685c-43b6-7472-c2d3-316cbc75a61b','','False','Color','False','','False','','','string','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(36,'True','False','','','True','TMF_CLONED_01t5e000002XxBQAA0_B2CCmex_ATTR_HASDISCOUNT_CHAR_ATTR_67528','True','','','false','HasDiscount : Has Discount','','1.0','','','','False','False','True','3c7f8a84-ca29-1d07-bf6a-f9856d991b64','','False','CLONED_01t5e000002XxBQAA0_B2CCmex_ATTR_HASDISCOUNT_CHAR','False','','False','','','Checkbox','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(37,'True','False','','','True','TMF_NumberofPorts_ATTR_355','True','','','8','The total Number of Ports for this product','','1.0','','','','False','False','True','b35cf8d6-b170-308f-bd91-8516b5b9e1ca','','False','Number of Ports','False','','False','','','Number','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(38,'True','False','','','True','TMF_Color-1_ATTR_98323','True','','','White','Color of the Firewall housing','','1.0','','','','False','False','True','5917d999-b300-e008-f663-959c7043d0e2','','False','Color-1','False','','False','','','string','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(39,'True','False','','','True','TMF_CLONED_01t5e000002XxBQAA0_B2CCmex_ATTR_HASDISCOUNT_CHAR_ATTR_40481','True','','','false','HasDiscount : Has Discount','','1.0','','','','False','False','True','13c4fcbb-d2b0-2611-579a-05800057def4','','False','CLONED_01t5e000002XxBQAA0_B2CCmex_ATTR_HASDISCOUNT_CHAR','False','','False','','','Checkbox','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(40,'True','False','','','True','TMF_NumberofPorts_ATTR_19096','True','','','8','The total Number of Ports for this product','','1.0','','','','False','False','True','f2661c30-e833-ef9c-b714-2f4cc1dd145f','','False','Number of Ports','False','','False','','','Number','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(41,'True','False','','','True','TMF_Color-1_ATTR_88773','True','','','White','Color of the Firewall housing','','1.0','','','','False','False','True','a0d27cc0-92a7-e83c-1a8f-fc535d2eae1d','','False','Color-1','False','','False','','','string','2','');
INSERT INTO "vlocity_cmt__Attribute__c" VALUES(42,'True','False','','','True','TMF_CLONED_01t5e000002XxBQAA0_B2CCmex_ATTR_HASDISCOUNT_CHAR_ATTR_53511','True','','','false','HasDiscount : Has Discount','','1.0','','','','False','False','True','ecb87fc4-52cf-334f-a9cc-6bf8b5e0e071','','False','CLONED_01t5e000002XxBQAA0_B2CCmex_ATTR_HASDISCOUNT_CHAR','False','','False','','','Checkbox','2','');
CREATE TABLE "vlocity_cmt__PicklistValue__c" (
	id INTEGER NOT NULL, 
	"vlocity_cmt__Abbreviation__c" VARCHAR(255), 
	"vlocity_cmt__IsActive__c" VARCHAR(255), 
	"vlocity_cmt__BooleanValue__c" VARCHAR(255), 
	"vlocity_cmt__Code__c" VARCHAR(255), 
	"vlocity_cmt__DateTimeValue__c" VARCHAR(255), 
	"vlocity_cmt__DateValue__c" VARCHAR(255), 
	"vlocity_cmt__IsDefault__c" VARCHAR(255), 
	"vlocity_cmt__EffectiveFromDate__c" VARCHAR(255), 
	"vlocity_cmt__EffectiveUntilDate__c" VARCHAR(255), 
	"vlocity_cmt__GlobalKey__c" VARCHAR(255), 
	"Name" VARCHAR(255), 
	"vlocity_cmt__NumberValue__c" VARCHAR(255), 
	"vlocity_cmt__Sequence__c" VARCHAR(255), 
	"vlocity_cmt__TextValue__c" VARCHAR(255), 
	"vlocity_cmt__UnitOfMeasureName__c" VARCHAR(255), 
	"vlocity_cmt__PicklistId__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "vlocity_cmt__PicklistValue__c" VALUES(1,'','True','False','PKL_GPS','','','False','2023-02-17','','76cee4bd-211e-33a4-fd30-7d0482d8560d','GPS','','10.0','GPS','','1');
CREATE TABLE "vlocity_cmt__Picklist__c" (
	id INTEGER NOT NULL, 
	"Name" VARCHAR(255), 
	"vlocity_cmt__Code__c" VARCHAR(255), 
	"vlocity_cmt__DataType__c" VARCHAR(255), 
	"vlocity_cmt__Description__c" VARCHAR(255), 
	"vlocity_cmt__EffectiveFromDate__c" VARCHAR(255), 
	"vlocity_cmt__EffectiveUntilDate__c" VARCHAR(255), 
	"vlocity_cmt__GlobalGroupKey__c" VARCHAR(255), 
	"vlocity_cmt__GlobalId__c" VARCHAR(255), 
	"vlocity_cmt__GlobalKey__c" VARCHAR(255), 
	"vlocity_cmt__IsActive__c" VARCHAR(255), 
	"vlocity_cmt__IsPublic__c" VARCHAR(255), 
	"vlocity_cmt__IsShared__c" VARCHAR(255), 
	"vlocity_cmt__LifecycleStatus__c" VARCHAR(255), 
	"vlocity_cmt__Type__c" VARCHAR(255), 
	"vlocity_cmt__UnitOfMeasureName__c" VARCHAR(255), 
	"vlocity_cmt__VersionLabel__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "vlocity_cmt__Picklist__c" VALUES(1,'Connectivity Type','PKL_Conn_Type','Text','','2023-02-17','','bca95829-320b-bb47-a572-7d432fcc0c29','','559320b5-b5e1-accf-8511-536025b6d152','True','False','False','Draft','','','');
COMMIT;
