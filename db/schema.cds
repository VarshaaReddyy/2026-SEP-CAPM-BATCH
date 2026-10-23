namespace demo1.db;

using { cuid, Currency } from '@sap/cds/common';
using { demo1.common as common } from './common';


context master {
    entity BusinessPartners {
        key NODE_KEY : common.Guid @(title: '{i18n>NODE_KEY}');
        BP_ROLE : common.Role @(title: '{i18n>BP_ROLE}');
        EMAIL : common.Email @(title: '{i18n>EMAIL}');
        MOBILE : common.PhoneNumber @(title: '{i18n>MOBILE}');
        FAX: common.String32 @(title: '{i18n>FAX}');
        WEB : common.String255 @(title: '{i18n>WEB}');
        BP_ID : common.Guid @(title: '{i18n>BP_ID}');
        COMPANY_NAME : common.String255 @(title: '{i18n>COMPANY_NAME}');
        AD : Association to Addresses ;
        
    }
    entity Addresses : common.Address{
        key NODE_KEY : common.Guid @(title: '{i18n>NODE_KEY}');
        ADDRESS_TYPE : common.String32 @(title: '{i18n>ADDRESS_TYPE}');
        VAL_START : Date @(title: '{i18n>VAL_START}');
        VAL_END: Date @(title: '{i18n>VAL_END}');
        LATITUDE : Decimal @(title: '{i18n>LATITUDE}');
        LONGITUDE : Decimal @(title: '{i18n>LONGITUDE}');
        BP : Association to one BusinessPartners on BP.AD = $self;

        
    }
    entity  Products {
        key NODE_KEY : common.Guid @(title: '{i18n>NODE_KEY}');
        PRODUCT_ID : common.String32 @(title: '{i18n>PRODUCT_ID}');
        TYPE_CODE : String(2) @(title: '{i18n>TYPE_CODE}');
        CATEGORY : common.String32 @(title: '{i18n>CATEGORY}');
        DESCRIPTION : common.String255 @(title: '{i18n>DESCRIPTION}');
        TAX_TARIF_CODE : Integer @(title: '{i18n>TAX_TARIF_CODE}');
        MEASURE_UNIT : String(2) @(title: '{i18n>MEASURE_UNIT}');
        WEIGHT_MEASURE : Decimal(5,2) @(title: '{i18n>WEIGHT_MEASURE}');
        WEIGHT_UNIT : String(2) @(title: '{i18n>WEIGHT_UNIT}');
        PRICE : Decimal(15,2) @(title: '{i18n>PRICE}');
        CURRENCY_CODE : String(5) @(title: '{i18n>CURRENCY_CODE}');
        WIDTH : Decimal(5, 2) @(title: '{i18n>WIDTH}');
        DEPTH : Decimal(5, 2) @(title: '{i18n>DEPTH}');
        HEIGHT : Decimal(5, 2) @(title: '{i18n>HEIGHT}');
        DIM_UNIT : String(2) @(title: '{i18n>DIM_UNIT}');
        SUPPLIERS : Association to BusinessPartners  @(title: '{i18n>SUPPLIERS_GUID}');
}
    entity Employees : cuid{
        nameFirst : common.String64;
        nameLast : common.String64;
        nameInitials : common.String64;
        nameMiddle : common.String64;
        gender : common.Gender;
        language : String(2);
        loginName : String(16);
        phoneNumber : common.PhoneNumber;
        email : common.Email;
        Currency : Currency;
        salaryAmount : common.AmountT;
        accountNumber : common.String32;
        bankId : String(16);
        bankName : common.String64;
    }

    
}

context transaction{
    entity PurchaseOrders : common.Amount {
        key NODE_KEY : common.Guid @(title: '{i18n>NODE_KEY}');
        PO_ID : common.Guid @(title: '{i18n>PO_ID}');
        
        PARTNER : Association to master.BusinessPartners @(title: '{i18n>PARTNER_GUID}');
        LIFECYCLE_STATUS : String(1) @(title: '{i18n>LIFECYCLE_STATUS}');
        OVERALL_STATUS : String(1) @(title: '{i18n>OVERALL_STATUS}');
        
        Items : Association to many PurchaseItems on Items.PARENT = $self;
    }
    entity PurchaseItems : common.Amount{
        key NODE_KEY : common.Guid @(title: '{i18n>NODE_KEY}');
        
        PARENT : Association to PurchaseOrders @(title: '{i18n>PARENT_KEY}');
        PO_ITEM_POS : Integer @(title: '{i18n>PO_ITEMS_POS}');
        
        PRODUCT : Association to master.Products @(title: '{i18n>PRODUCT_GUID}');
    }
}
 
entity Countries{
    key code : String(2);
    description : String(200);
}

entity BPRoleFltr{
    code : Integer @(title: '{i18n>BP_ROLE}');
    description :String(80) @(title: '{i18n>BP_ROLE}');

}

entity lifecyclestatus{
    key code : String(1);
    description : String(20);
}

entity overallStatus{
    key code : String(1);
    description : String(20);
}
entity Cities{
    key Description : String(200);
}