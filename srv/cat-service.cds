using { demo1.db as db } from '../db/schema';
using { demo1.common as common } from '../db/common';

type createEmployeeIP {
    Currency_code : String(3);
    ID            : UUID;
    accountNumber : common.String32;
    bankId        : String(16);
    bankName      : common.String64;
    email         : common.Email;
    gender        : common.Gender;
    language      : String(2);
    loginName     : String(16);
    nameFirst     : common.String64;
    nameInitials  : common.String64;
    nameLast      : common.String64;
    nameMiddle    : common.String64;
    phoneNumber   : common.PhoneNumber;
    salaryAmount  : common.AmountT;
}

service CatalogService @(require : 'authenticated-user'){
    @Capabilities : {
        InsertRestrictions.Insertable :true,
        UpdateRestrictions.Updatable : true,
        DeleteRestrictions.Deletable : true,
        ReadRestrictions.Readable : true
    }
    entity EmployeeSrv as projection on db.master.Employees{
        *
    }actions{
        action increaseSalary() returns array of EmployeeSrv;
        function highestPaid() returns  array of EmployeeSrv;
    }
    entity lifecycleStatusSrv as projection on db.lifecyclestatus;
    entity OverallstatusSrv as projection on db.overallStatus;
    entity ProductSrv as projection on db.master.Products{
      *
    } actions {
      action increasePrice() returns array of ProductSrv;
      function getTopProducts() returns array of ProductSrv;
    }

    entity CitySrv as projection on db.Cities;
    
    entity BusinessPartnersSrv as projection on db.master.BusinessPartners;
    
    entity AddressSrv as projection on db.master.Addresses;

    @Capabilities : {
        DeleteRestrictions : {
            $Type : 'Capabilities.DeleteRestrictionsType',
            Deletable : false
        },
        UpdateRestrictions : {
            $Type : 'Capabilities.UpdateRestrictionsType',
            Updatable : false
        },
        InsertRestrictions : {
            $Type : 'Capabilities.InsertRestrictionsType',
            Insertable : false
        },
    }
    
    entity PurchaseOrderSrv as select from db.transaction.PurchaseOrders as po
    inner join db.master.BusinessPartners as bp
        on bp.NODE_KEY = po.PARTNER.NODE_KEY
    inner join db.master.Addresses as addr
        on addr.NODE_KEY = bp.AD.NODE_KEY
    inner join db.Countries as country
        on addr.COUNTRY = country.code
    inner join db.BPRoleFltr as role 
        on bp.BP_ROLE= role.code
    inner join db.lifecyclestatus as ls
        on po.LIFECYCLE_STATUS= ls.code
    inner join db.overallStatus as sr
        on po.OVERALL_STATUS = sr.code
    inner join db.Cities as cs
    on addr.CITY=cs.Description{
        key po.NODE_KEY,
        po.PO_ID,
        po.GROSS_AMOUNT,
        po.NET_AMOUNT,
        po.TAX_AMOUNT,
        po.CURRENCY,
        bp.COMPANY_NAME,
        bp.BP_ID,
        role.description as BP_ROLE,
        bp.MOBILE,
        bp.FAX,
        bp.EMAIL,
        bp.WEB,
        addr.ADDRESS_TYPE,
        addr.BUILDING,
        //addr.CITY @(title: '{i18n>CITY}'),
        addr.LATITUDE,
        addr.COUNTRY,
        addr.LONGITUDE,
        addr.STREET,
        addr.POSTAL_CODE,
        po.Items,
        bp.COMPANY_NAME as partnerName,
        bp.BP_ID as partnerId,
        addr.COUNTRY as partnerCountry @(title: '{i18n>COUNTRY_code}'),
        country.description as partnerCountryDesc @(title: '{i18n>COUNTRY}'),
        ls.description as LSTEXT  @(title: '{i18n>LIFECYCLE_STATUS}'),
        sr.description as OSTEXT  @(title: '{i18n>OVERALL_STATUS}'),
        addr.CITY as partnerCity,
      cs.Description as partnerCityDesc @(title: '{i18n>CITY}'),
      case po.LIFECYCLE_STATUS
      when 'N' then 2
      when 'S' then 3
      when 'C' then 3
      else 1
      end as LSC : Integer,
      case po.OVERALL_STATUS
      when 'R' then 1
      when 'P' then 3
      when 'D' then 3
      else 2
      end as OSC : Integer,
      //case po.LIFECYCLE_STATUS
      //when 'N' then 'Not Started'
      //when 'S' then 'Started'
      //when 'C' then 'Completed'
      //else 'Cancelled'
      //end as LSTEXT : String(20) @(title: '{i18n>LIFECYCLE_STATUS}'),
      //
    } actions{
      //Declare instance bounded action
      action discountPrice() returns array of PurchaseOrderSrv;
 
      //Declare instance bounded function
      function largestOrder() returns array of PurchaseOrderSrv;
    };
    entity CountrySrv as projection on db.Countries;
    
    entity PurchaseItemsSrv as projection on db.transaction.PurchaseItems;
    
    action createEmployee( 
                            @(title: '{i18n>CURRENCY_CODE}')
                            Currency_code: String(3),
                            @(title: '{i18n>ID}')
                            ID : UUID,
                            @(title: '{i18n>ACCOUNT_NUMBER}')
                            accountNumber : common.String32,
                            @(title: '{i18n>BANK_ID}')
                            bankId : String(16),
                            @(title: '{i18n>BANK_NAME}')
                            bankname : common.String64,
                            @(title: '{i18n>EMAIL}')
                            email : common.Email,
                            @(title: '{i18n>GENDER}')
                            gender : common.Gender,
                            @(title: '{i18n>LANGUAGE}')
                            language : String(2),
                            @(title: '{i18n>LOGIN_NAME}')
                            loginName : String(16),
                            @(title: '{i18n>PHONE_NUMBER}')
                            phoneNumber : common.PhoneNumber,
                            //email : common.Email,
                            //Currency : Currency,
                            @(title: '{i18n>SALARY_AMOUNT}')
                            salaryAmount : common.AmountT,
                            //accountNumber : common.String32,
                            //bankId : String(16),
                            @(title: '{i18n>BANK_NAME}')
                            bankName : common.String64,
                            @(title: '{i18n>FIRST_NAME}')
                            nameFirst : common.String64,
                            @(title: '{i18n>LAST_NAME}')
                            nameLast : common.String64,
                            @(title: '{i18n>INITIAL}')
                            nameInitials : common.String64,
                            @(title: '{i18n>MIDDLE_NAME}')
                            nameMiddle : common.String64
        
                            
                            
                        ) returns array of EmployeeSrv;

    //action createEmployee( input : createEmployeeIP) returns String;

    action createAddresses(
        NODE_KEY : common.Guid,
        ADDRESS_TYPE : common.String32,
        VAL_START : Date,
        VAL_END: Date,
        LATITUDE : Decimal,
        LONGITUDE : Decimal,
        STREET : common.String255,
        POSTAL_CODE : String(12),
        CITY : common.String255,
        COUNTRY : common.String255,
        BUILDING : common.String255,
    ) returns array of AddressSrv;

    action updateEmployee(
        ID : UUID,
        nameFirst : common.String64,
        nameLast : common.String64,
        nameInitials : common.String64,
        nameMiddle : common.String64
    )returns String;

    action updateAddress(
        NODE_KEY : common.Guid,
        CITY : common.String255
    )returns String;

    action createProduct(
        NODE_KEY : common.Guid,
        PRODUCT_ID : common.String32,
        TYPE_CODE : String(2),
        CATEGORY : common.String32,
        DESCRIPTION : common.String32,
        TAX_TARIF_CODE : Integer,
        MEASURE_UNIT : String(2),
        WEIGHT_MEASURE : Decimal(5,2),
        WEIGHT_UNIT : String(2),
        PRICE : Decimal(15,2),
        CURRENCY_CODE : String(5),
        WIDTH : Decimal(5, 2),
        DEPTH : Decimal(5, 2),
        HEIGHT : Decimal(5, 2),
        DIM_UNIT : String(2)
    )returns array of ProductSrv;

    action updateProduct(
        NODE_KEY : common.Guid,
        PRODUCT_ID : common.String32,
        TYPE_CODE : String(2),
        CATEGORY : common.String32,
        DESCRIPTION : common.String32,
        TAX_TARIF_CODE : Integer,
        MEASURE_UNIT : String(2),
        WEIGHT_MEASURE : Decimal(5,2),
        WEIGHT_UNIT : String(2),
        PRICE : Decimal(15,2),
        CURRENCY_CODE : String(5),
        WIDTH : Decimal(5, 2),
        DEPTH : Decimal(5, 2),
        HEIGHT : Decimal(5, 2),
        DIM_UNIT : String(2)
    )returns String;

    action deleteProduct(
        NODE_KEY : common.Guid
        
    )returns String;

    action deleteEmployee(
        ID : UUID,
        
    )returns String;

    function getHighestSalariedEmployees() returns array of EmployeeSrv;
    function getHeighestPricedProduct() returns array of ProductSrv;

    function getUtilities() returns String;

    action createPurchaseOrder(
        NODE_KEY : common.Guid @(title: '{i18n>NODE_KEY}'),
        PO_ID : common.Guid @(title: '{i18n>PO_ID}'),
        
        PARTNER : common.Guid @(title: '{i18n>PARTNER_GUID}'),
        LIFECYCLE_STATUS : String(1) @(title: '{i18n>LIFECYCLE_STATUS}'),
        OVERALL_STATUS : String(1) @(title: '{i18n>OVERALL_STATUS}'),
        
       
        GROSS_AMOUNT : Decimal(10,2) @(title: '{i18n>GROSS_AMOUNT}'),
        NET_AMOUNT : Decimal(10,2) @(title: '{i18n>NET_AMOUNT}'),
        TAX_AMOUNT : Decimal(10,2) @(title: '{i18n>TAX_AMOUNT}'),
        CURRENCY_CODE : String(3) @(title: '{i18n>CURRENCY_CODE}')
    
    )returns array of PurchaseOrderSrv;

    // action UpdatePurchaseOrder(
    //     NODE_KEY : common.Guid @(title: '{i18n>NODE_KEY}'),
    //     PO_ID : common.Guid @(title: '{i18n>PO_ID}'),
        
    //     PARTNER : common.Guid @(title: '{i18n>PARTNER_GUID}'),
    //     LIFECYCLE_STATUS : String(1) @(title: '{i18n>LIFECYCLE_STATUS}'),
    //     OVERALL_STATUS : String(1) @(title: '{i18n>OVERALL_STATUS}'),
        
       
    //     GROSS_AMOUNT : Decimal(10,2) @(title: '{i18n>GROSS_AMOUNT}'),
    //     NET_AMOUNT : Decimal(10,2) @(title: '{i18n>NET_AMOUNT}'),
    //     TAX_AMOUNT : Decimal(10,2) @(title: '{i18n>TAX_AMOUNT}'),
    //     CURRENCY : String(3) @(title: '{i18n>CURRENCY_CODE}')
    // )returns String;

    action deletePurchaseOrder(
        NODE_KEY : common.Guid @(title: '{i18n>NODE_KEY}')
    )returns String;

    action createpurchaseItem(
        NODE_KEY : common.Guid @(title: '{i18n>NODE_KEY}'),
        
        PARENT_NODE_KEY : common.Guid @(title: '{i18n>PARENT_KEY}'),
        PO_ITEM_POS : Integer @(title: '{i18n>PO_ITEMS_POS}'),
        
        PRODUCT_NODE_KEY : common.Guid @(title: '{i18n>PRODUCT_GUID}'),
        GROSS_AMOUNT : Decimal(10,2) @(title: '{i18n>GROSS_AMOUNT}'),
        NET_AMOUNT : Decimal(10,2) @(title: '{i18n>NET_AMOUNT}'),
        TAX_AMOUNT : Decimal(10,2) @(title: '{i18n>TAX_AMOUNT}'),
        CURRENCY_CODE : String(3) @(title: '{i18n>CURRENCY_CODE}')
   
    )returns array of PurchaseItemsSrv;

    action updatePurchaseItem(
        NODE_KEY : common.Guid @(title: '{i18n>NODE_KEY}'),
        
        PARENT : common.Guid @(title: '{i18n>PARENT_KEY}'),
        PO_ITEM_POS : Integer @(title: '{i18n>PO_ITEMS_POS}'),
        
        PRODUCT : common.Guid @(title: '{i18n>PRODUCT_GUID}'),
        GROSS_AMOUNT : Decimal(10,2) @(title: '{i18n>GROSS_AMOUNT}'),
        NET_AMOUNT : Decimal(10,2) @(title: '{i18n>NET_AMOUNT}'),
        TAX_AMOUNT : Decimal(10,2) @(title: '{i18n>TAX_AMOUNT}'),
        CURRENCY_CODE : String(3) @(title: '{i18n>CURRENCY_CODE}')
    )returns String;

    action deletePurchaseItem(
        NODE_KEY : common.Guid @(title: '{i18n>NODE_KEY}')
    )returns String;
}

