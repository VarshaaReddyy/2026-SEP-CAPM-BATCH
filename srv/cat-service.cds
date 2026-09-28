using { demo1.db as db } from '../db/schema';
using { demo1.common as common } from '../db/common';


service CatalogService {
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
    
    entity ProductSrv as projection on db.master.Products{
      *
    } actions {
      action increasePrice() returns array of ProductSrv;
      function getTopProducts() returns array of ProductSrv;
    }

    
    
    entity BusinessPartnersSrv as projection on db.master.BusinessPartners;
    
    entity AddressSrv as projection on db.master.Addresses;

    
    entity PurchaseOrderSrv as projection on db.transaction.PurchaseOrders{
      *
    } actions{
      //Declare instance bounded action
      action discountPrice() returns array of PurchaseOrderSrv;
 
      //Declare instance bounded function
      function largestOrder() returns array of PurchaseOrderSrv;
    };
 
    
    entity PurchaseItemsSrv as projection on db.transaction.PurchaseItems;
    
    action createEmployee(  Currency_code: String(3),
                            ID : UUID,
                            accountNumber : common.String32,
                            bankId : String(16),
                            bankname : common.String64,
                            email : common.Email,
                            gender : common.Gender,
                            language : String(2),
                            loginName : String(16),
                            phoneNumber : common.PhoneNumber,
                            //email : common.Email,
                            //Currency : Currency,
                            salaryAmount : common.AmountT,
                            //accountNumber : common.String32,
                            //bankId : String(16),
                            bankName : common.String64,
                            nameFirst : common.String64,
                            nameLast : common.String64,
                            nameInitials : common.String64,
                            nameMiddle : common.String64
        
                            
                            
                        ) returns array of EmployeeSrv;

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

    action deleteEmployee(
        ID : UUID,
        
    )returns String;

    function getHighestSalariedEmployees() returns array of EmployeeSrv;
    function getHeighestPricedProduct() returns array of ProductSrv;

    function getUtilities() returns String;
}

