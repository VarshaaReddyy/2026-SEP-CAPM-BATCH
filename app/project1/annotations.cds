using CatalogService as service from '../../srv/cat-service';

annotate service.PurchaseOrderSrv with {
    partnerCity @(
        Common : {
            ValueList : {
                Label: 'City',
                CollectionPath : 'CitySrv',
                SearchSupported : true,
                Parameters : [{
                    $Type : 'Common.ValueListParameterOut',
                    LocalDataProperty : 'partnerCityDesc',
                    ValueListProperty : 'Description'
                }
                ]
            }
        }
    );
    PO_ID @(
        Common: {
            
            ValueList : {
                Label : 'Purchase Order ID',
                CollectionPath : 'PurchaseOrderSrv',
                SearchSupported : true,
                Parameters :[{
                    $Type : 'Common.ValueListParameterOut',
                    LocalDataProperty : PO_ID,
                    ValueListProperty : 'PO_ID'
                }]
                
            },
        }

    );
    partnerCountryDesc @(
        Common : {
            
            ValueList : {
                Label : 'Country Name',
                CollectionPath : 'CountrySrv',
                SearchSupported : true,
                Parameters :[{
                    $Type : 'Common.ValueListParameterOut',
                    LocalDataProperty : 'partnerCountry',
                    ValueListProperty : 'code'
                }, {
                    $Type : 'Common.ValueListParameterOut',
                    LocalDataProperty : 'partnerCountryDesc',
                    ValueListProperty : 'description'
                }]
               
            },
        }
    );
    LSTEXT @(
        Common : {
            ValueList : {
                Label: 'Life Cycle Status',
                CollectionPath : 'lifecycleStatusSrv',
                SearchSupported : true,
                Parameters : [{
                    $Type : 'Common.ValueListParameterOut',
                    LocalDataProperty : 'code',
                    ValueListProperty : 'code'
                },
                {
                    $Type : 'Common.ValueListParameterOut',
                    LocalDataProperty : 'LSTEXT',
                    ValueListProperty : 'description'
                }
                ]
            }
        }
    );
    OSTEXT @(
        Common : {
            
            ValueList : {
                Label : 'Over All Status',
                CollectionPath : 'OverallstatusSrv',
                SearchSupported : true,
                Parameters :[{
                    $Type : 'Common.ValueListParameterOut',
                    LocalDataProperty : 'code',
                    ValueListProperty : 'code'
                },
                {
                    $Type : 'Common.ValueListParameterOut',
                    LocalDataProperty : 'OSTEXT',
                    ValueListProperty : 'description'
                }]
               
            },
        }
    );
 
    COMPANY_NAME @(
        Common: {
            
            ValueList : {
                Label : 'Company Name',
                CollectionPath : 'BusinessPartnersSrv',
                SearchSupported : true,
                Parameters : [{
                    $Type : 'Common.ValueListParameterOut',
                    LocalDataProperty : 'BP_ID',
                    ValueListProperty : 'BP_ID'
                },
                {
                    $Type : 'Common.ValueListParameterOut',
                    LocalDataProperty : 'COMPANY_NAME',
                    ValueListProperty : 'COMPANY_NAME'
                }]
            },
        }
    );
    
} ;

annotate service.PurchaseOrderSrv with @(
    UI.SelectionFields : [
    PO_ID,
    COMPANY_NAME,
    LSTEXT,
    OSTEXT,
    partnerCountryDesc,partnerCity
   ],

   UI.LineItem : [
    {
        $Type : 'UI.DataField',
        Value : PO_ID
    },
    {
        $Type : 'UI.DataField',
        Value : COMPANY_NAME
    },
    {
        $Type : 'UI.DataField',
        Value : GROSS_AMOUNT
    },
    {
        $Type : 'UI.DataField',
        Value : CURRENCY_code
    },
    {
        $Type : 'UI.DataFieldForAction',
        Action : 'CatalogService.discountPrice',
        Label : 'Discount',
        Inline : true
    },
    /*{
        $Type : 'UI.DataFieldForAction',
        Action : 'CatalogService.EntityContainer/createEmployee',
        Label : 'Create Employee'
    },*/
    {
        $Type : 'UI.DataFieldForAction',
        Action : 'CatalogService.EntityContainer/createPurchaseOrder',
        Label : 'Create Purchase Order'
    },
    {
        $Type : 'UI.DataFieldForAction',
        Action : 'CatalogService.EntityContainer/UpdatePurchaseOrder',
        Label : 'Update Purchase Order'
    },
    {
        $Type : 'UI.DataFieldForAction',
        Action : 'CatalogService.EntityContainer/deletePurchaseOrder',
        Label : 'Delete Purchase Order'
    },
    {
        $Type : 'UI.DataField',
        Value : LSTEXT,
        Criticality : LSC
    },
    {
        $Type : 'UI.DataField',
        Value : OSTEXT,
        Criticality : OSC
    },
    {
        $Type : 'UI.DataField',
        Value : partnerCountryDesc
    },
    {
        $Type : 'UI.DataField',
        Value : partnerCity

    }
   ],
   UI.HeaderInfo :{
    TypeName: 'Purchase Order',
    TypeNamePlural : 'Purchase Orders',
    Title : {
        $Type : 'UI.DataField',
        Value : PO_ID
    },
    Description :{
        $Type : 'UI.DataField',
        Value : COMPANY_NAME
    },
    ImageUrl : 'https://download.logo.wine/logo/Capgemini/Capgemini-Logo.wine.png'
   },
   UI.FieldGroup #HeaderDetails : {
        Data : [
            {
                $Type : 'UI.DataField',
                Value : BP_ID
            },
            {
                $Type : 'UI.DataField',
                Value : COMPANY_NAME
            },
            {
                $Type : 'UI.DataField',
                Value : BP_ROLE
            }
            
             
        ]
    },
    UI.FieldGroup #HeaderCommunication :{
        Data : [
            {
                $Type : 'UI.DataField',
                Value : FAX
            },
            {
                $Type : 'UI.DataField',
                Value : EMAIL
            },
            {
                $Type : 'UI.DataField',
                Value : MOBILE
            }
        ]

    },
 
    UI.HeaderFacets : [
        {
            $Type : 'UI.CollectionFacet',
            Label : 'Business Partner Details',
            Facets : [

        
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'General Information',
            Target : '@UI.FieldGroup#HeaderDetails'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Communication Information ',
            Target : '@UI.FieldGroup#HeaderCommunication'
        }
            ]
        }
        
    ],
    
    UI.Facets : [
        {
            $Type : 'UI.CollectionFacet',
            Label : 'Other Details',
            Facets :[
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Account Information',
                    Target :@UI.FieldGroup#Address
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Address Information',
                    Target : @UI.FieldGroup#Amount
                }
            ]
        },
        
        {
            $Type :'UI.ReferenceFacet',
            Label : 'Purchase Item Details',
            Target : 'Items/@UI.LineItem'
        },
        
        // {
        //     $Type : 'UI.ReferenceFacet',
        //     Label : 'Status Overwiew',
        //     Target : '@UI.Chart'
        // },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'ItemGrossChart',
            Label : 'Gross Amount per Item',
            Target: 'Items/@UI.Chart'
        }
    ],
    UI.FieldGroup #Address :{
        Data : [
            {
                $Type : 'UI.DataField',
                Value : COUNTRY
            },
            {
                $Type : 'UI.DataField',
                Value : STREET
            },
            {
                $Type : 'UI.DataField',
                Value : BUILDING
            },
            {
                $Type : 'UI.DataField',
                Value : COMPANY_NAME
            },
            {
                $Type : 'UI.DataField',
                Value : POSTAL_CODE
            },
            {
                $Type : 'UI.DataField',
                Value : CITY
            }
        ]

    },
    UI.FieldGroup #Amount :{
        Data : [
            {
                $Type : 'UI.DataField',
                Value : NET_AMOUNT
            },
            {
                $Type : 'UI.DataField',
                Value : TAX_AMOUNT
            },
            {
                $Type : 'UI.DataField',
                Value : GROSS_AMOUNT
            },
            {
                $Type : 'UI.DataField',
                Value : CURRENCY_code
            }
        ]

    }
    


);

annotate service.PurchaseItemsSrv with @(
    UI.SelectionFields: [
        PO_ITEM_POS,
        PRODUCT_NODE_KEY
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : PO_ITEM_POS
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT_NODE_KEY
        },
        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT
        },
        {
            $Type : 'UI.DataField',
            Value : NET_AMOUNT
        },
        {
            $Type : 'UI.DataField',
            Value : TAX_AMOUNT
        },
        {
        $Type : 'UI.DataFieldForAction',
        Action : 'CatalogService.EntityContainer/createpurchaseItem',
        Label : 'Create Purchase Item'
    },
    {
        $Type : 'UI.DataFieldForAction',
        Action : 'CatalogService.EntityContainer/updatePurchaseItem',
        Label : 'Update Purchase Item'
    },
    {
        $Type : 'UI.DataFieldForAction',
        Action : 'CatalogService.EntityContainer/deletePurchaseItem',
        Label : 'Delete Purchase Item'
    }
    ],
    UI.HeaderInfo :{
    TypeName: 'Purchase Item',
    TypeNamePlural : 'Purchase Item Info',
    Title : {
        $Type : 'UI.DataField',
        Value : PO_ITEM_POS
    },
    Description :{
        $Type : 'UI.DataField',
        Value : PRODUCT.DESCRIPTION
    },
    ImageUrl : 'https://static.vecteezy.com/system/resources/previews/009/925/490/original/shopping-cart-symbol-shop-and-sale-icon-shopping-cart-icon-shopping-cart-simple-sign-shopping-cart-logo-design-shopping-cart-design-illustration-shopping-cart-icon-image-trolley-free-vector.jpg'
    
    
   },
   UI.Facets : [
        {
            $Type : 'UI.CollectionFacet',
            Label : 'Other Details',
            Facets :[
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Purchase Item Information',
                    Target :@UI.FieldGroup#PurchaseItem
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Product Information',
                    Target : @UI.FieldGroup#Product
                }
            ]
        }
        
        

    ],
    UI.Identification :[
        {
        $Type : 'UI.DataFieldForAction',
        Action : 'CatalogService.EntityContainer/createProduct',
        Label : 'Create Product '
    },
    {
        $Type : 'UI.DataFieldForAction',
        Action : 'CatalogService.EntityContainer/updateProduct',
        Label : 'Update Product '
    },
    {
        $Type : 'UI.DataFieldForAction',
        Action : 'CatalogService.EntityContainer/deleteProduct',
        Label : 'Delete Product '
    }
    ],
    UI.FieldGroup #PurchaseItem :{
        Data : [
            {
                $Type : 'UI.DataField',
                Value : GROSS_AMOUNT
            },
            {
                $Type : 'UI.DataField',
                Value : NET_AMOUNT
            },
            {
                $Type : 'UI.DataField',
                Value : TAX_AMOUNT
            },
            {
                $Type : 'UI.DataField',
                Value : CURRENCY_code
            }
        ]

    },
    UI.FieldGroup #Product :{
        Data : [
            {
                $Type : 'UI.DataField',
                Value : PRODUCT.PRODUCT_ID
            },
            {
                $Type : 'UI.DataField',
                Value : PRODUCT.WEIGHT_MEASURE
            },
            {
                $Type : 'UI.DataField',
                Value : PRODUCT.DESCRIPTION
            },
            {
                $Type : 'UI.DataField',
                Value : PRODUCT.DEPTH
            },
            {
                $Type : 'UI.DataField',
                Value : PRODUCT.HEIGHT
            },
            {
                $Type : 'UI.DataField',
                Value : PRODUCT.WIDTH
            },
            {
                $Type : 'UI.DataField',
                Value : PRODUCT.PRICE
            },
            {
                $Type : 'UI.DataField',
                Value : PRODUCT.CURRENCY_CODE
            },{
                $Type : 'UI.DataField',
                Value : PRODUCT.TYPE_CODE
            },
            {
                $Type : 'UI.DataField',
                Value : PRODUCT.MEASURE_UNIT
            }

        ]

    }
);

// annotate service.PurchaseOrderSrv with @(UI.Chart: {
//     Title : 'Status of the order',
//     Description : 'Overall lifecycle status of the order',
//     ChartType : #Column,
//     Dimensions : [
//         LSTEXT
//         // LSTEXT
//     ],
//     Measures : [GROSS_AMOUNT],
//     DimensionAttributes : [
//         {
//             $Type : 'UI.ChartDimensionAttributeType',
//             Dimension : LSTEXT,
//             Role : #Category
//         }
        // {
        //     $Type : 'UI.ChartDimensionAttributeType',
        //     Dimension : LSTEXT,
        //     Role : #Series
        // }
//     ],
//     MeasureAttributes : [{
//         $Type :'UI.ChartMeasureAttributeType',
//         Measure : GROSS_AMOUNT,
//         Role : #Axis1
//     }]
// });




annotate CatalogService.PurchaseItemsSrv with {
 
    GROSS_AMOUNT @Semantics.amount.currencyCode: 'CURRENCY_code';
 
    NET_AMOUNT   @Semantics.amount.currencyCode: 'CURRENCY_code';
 
    TAX_AMOUNT   @Semantics.amount.currencyCode: 'CURRENCY_code';
 
};
 
annotate service.PurchaseItemsSrv with @(
 
    Aggregation.ApplySupported : {
 
        Transformations       : [
 
            'aggregate',
 
            'groupby',
 
            'filter',
 
            'orderby',
 
            'top',
 
            'skip'
 
        ],
 
        GroupableProperties   : [
 
            PO_ITEM_POS,
 
            PRODUCT_NODE_KEY,
 
            CURRENCY_code
 
        ],
 
        AggregatableProperties: [
 
            { Property: GROSS_AMOUNT }
 
        ]
 
    },
 
    Analytics.AggregatedProperty #sumGross : {
 
        Name                 : 'sumGross',
 
        AggregationMethod    : 'sum',
 
        AggregatableProperty : GROSS_AMOUNT,
 
        ![@Common.Label]     : 'Gross Amount'
 
    },
 
    UI.Chart : {
 
        Title              : 'Gross Amount per Item',
 
        ChartType          : #Column,
 
        Dimensions         : [ PO_ITEM_POS ],
 
        DimensionAttributes: [
 
            { Dimension: PO_ITEM_POS, Role: #Category }
 
        ],
 
        DynamicMeasures    : [ '@Analytics.AggregatedProperty#sumGross' ],
 
        MeasureAttributes  : [
 
            { DynamicMeasure: '@Analytics.AggregatedProperty#sumGross', Role: #Axis1 }
 
        ]
 
    }
 
);
 