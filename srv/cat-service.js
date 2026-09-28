const { startswith } = require("@cap-js/hana/lib/cql-functions");
const cds = require("@sap/cds-dk/lib/")

const cds1 = require('@sap/cds');
 
const {exists, isdir, mkdirp, read, uuid } = cds1.utils;


module.exports = cds.service.impl(async function () {
    //step 1 : Declare Employee service from ENtities
    const { EmployeeSrv } = this.entities;
    const { AddressSrv } =this.entities;
    const { ProductSrv } = this.entities;
    const { PurchaseItemsSrv }= this. entities;
    const { BusinessPartnersSrv , PurchaseOrderSrv  }=this.entities;
    // Implementation of an action
    // There are 3 generic handlers
    // .before() : Pre-check and validation
    // .on() : performing DM operations
    // .after() : To save / close connections

    this.before('UPDATE', EmployeeSrv , async(request,response) =>{
        const salamt = request.data.salaryAmount;
        if(salamt>100000){
            request.error(500,'Please get the approval from your line manager');
        }
    })

    this.before('UPDATE',ProductSrv, async(request,response) =>{
        const prodprice = request.data.PRICE;
        if(prodprice>500){
            request.error(500,'Product Price cannot be greater than 500');
        }
    })

    this.before('UPDATE', PurchaseItemsSrv,async(request,response) =>{
        const grossA = request.data.GROSS_AMOUNT;
        const curren = request.data.CURRENCY_code;
        if(grossA > 15000 && curren=='USD'){
            request.error(500,'Please get in touch with line manager');
        }
        if(grossA > 10000 && curren=='EUR'){
            request.error(500,'please check with your regional head');
        }
    } )

    this.before('UPDATE',AddressSrv, async(request,response) =>{
        const Add = request.data.COUNTRY;
        if(!(Add=='US' || Add=='GB')){
            request.error(500,'please contact your administrator');
        }
    })

    this.before('UPDATE',EmployeeSrv, async(request,response) =>{
        const mob = request.data.phoneNumber;
        if ( !(mob.startsWith('+44') || mob.startsWith('+1'))){
            request.error(500,'Employee must be US or GB');
        }
    })

    this.before('UPDATE',BusinessPartnersSrv, async(request,response) =>{
        const com = request.data.COMPANY_NAME;
        if ( com.includes(",")||com.includes(".")||com.includes("-")){
            request.error(500,'Invalid Company Name');
        }
    })

    this.before('UPDATE',PurchaseItemsSrv, async(request,response) =>{
        const pos = request.data.PO_ITEM_POS;
        if ( !((pos%10) == 0)){
            request.error(500,'Invalid POSITION');
        }
    })





    

    this.on('createEmployee', async(request, response) =>{
        // Step2: Get the data which is coming form the API
        const empData = request.data;

        // Step 3: Instantiate the transaction object
        const objTransaction = cds.tx(request);

        // Step4 : Insert the record into database
        let returnData = await objTransaction.run([
            INSERT.into(EmployeeSrv).entries(empData)
        ]).then((resolve, reject) =>{
            if(typeof(resolve)!== undefined){
                return request.data
            }else{
                request.error(500, " Error in inserting data into the database")
            }
        }).catch(err =>{
            request.error("There is an error :",err.toString())
        })

        // step-5: return the data
        return returnData;
    })

    this.on('createAddresses', async(request, response) =>{
        // Step2: Get the data which is coming form the API
        const AddressData = request.data;

        // Step 3: Instantiate the transaction object
        const objTransaction = cds.tx(request);

        // Step4 : Insert the record into database
        let returnData = await objTransaction.run([
            INSERT.into(AddressSrv).entries(AddressData)
        ]).then((resolve, reject) =>{
            if(typeof(resolve)!== undefined){
                return request.data
            }else{
                request.error(500, " Error in inserting data into the database 2")
            }
        }).catch(err =>{
            request.error("There is an error :",err.toString())
        })

        // step-5: return the data
        return returnData;
    })


    this.on('createProduct', async(request, response) =>{
        // Step2: Get the data which is coming form the API
        const proddata = request.data;

        // Step 3: Instantiate the transaction object
        const objTransaction = cds.tx(request);

        // Step4 : Insert the record into database
        let returnData = await objTransaction.run([
            INSERT.into(ProductSrv).entries(proddata)
        ]).then((resolve, reject) =>{
            if(typeof(resolve)!== undefined){
                return request.data
            }else{
                request.error(500, " Error in inserting data into the database")
            }
        }).catch(err =>{
            request.error("There is an error :",err.toString())
        })

        // step-5: return the data
        return returnData;
    })

    this.on('updateEmployee', async (request ,response)=>{
        
        const{
            ID,
            nameFirst,
            nameLast,
            nameInitials,
            nameMiddle
        } = request.data;

        try{
            const objTransaction = cds.tx(request);

            await objTransaction.update(EmployeeSrv).with({
                nameFirst : nameFirst,
                nameLast : nameLast,
                nameInitials : nameInitials,
                nameMiddle : nameMiddle
            }).where({
                ID:ID
            })
            return "Successfully updated";
        }catch(error){
            request.error("Error : ",error)
        }
        
    })


    this.on('updateAddress', async (request ,response)=>{
        
        const{
            NODE_KEY,
            CITY
        } = request.data;

        try{
            const objTransaction = cds.tx(request);

            await objTransaction.update(AddressSrv).with({
                CITY:CITY
                
            }).where({
                NODE_KEY:NODE_KEY
            })
            return "Successfully updated";
        }catch(error){
            request.error("Error : ",error)
        }
        
    })


    this.on('deleteEmployee', async (request ,response)=>{
        
        const{
            ID
        } = request.data;

        try{
            const objTransaction = cds.tx(request);

            await objTransaction.delete(EmployeeSrv).where({
                ID:ID
            })
            return "Successfully updated";
        }catch(error){
            request.error("Error : ",error)
        }
        
    })

    this.on('getHighestSalariedEmployees', async (request ,response)=>{
        
       
        try{
            const objTransaction = cds.tx(request);

            const response =await objTransaction.read(EmployeeSrv).orderBy({
                salaryAmount:'desc'
            }).limit(10)
            return response ;
        }catch(error){
            request.error("Error : ",error)
        }
        
    })

     this.on('getHeighestPricedProduct', async (request, response) => {
        try {
            const transaction = cds.tx(request);
       
            const response = await transaction.read(ProductSrv).orderBy({
                PRICE : 'desc'
            }).limit(10);
           
            return response;
        } catch (error) {
            request.error("Error : ", error)
        }
    })
    this.on('increasePrice', async(request, response) => {
        try{
            const ID = request.params[0];
            const transaction = cds.tx(request);
            await transaction.update(ProductSrv).with({
                PRICE : {
                    '*=' : 1.10
                }
            }).where(ID)
            const updatedPrice = await transaction.read(ProductSrv);
            return updatedPrice;
        } catch(error) {
            return "Error: " + error.toString();
        }
    })
     this.on('getTopProducts', async(request,response)=>{
        try{
            const transaction = cds.tx(request);
            const products = await transaction.read(ProductSrv).orderBy({
                PRICE : 'desc'
            }).limit(20);
            return products;
        } catch(error){
            request.error("Error: ",error)
        }
    })

    //Implementation of Instance bounded action
    this.on('discountPrice', async(request, response) => {
        try{
            //Step 1: Get the paramater from the entity
            const ID = request.params[0];
            //Step 2: Creating object for transaction service using request
            const transaction = cds.tx(request);
            //Step 3: Update the purchase order service
            await transaction.update(PurchaseOrderSrv).with({
                GROSS_AMOUNT : {
                    '-=' : 1000
                },
                NET_AMOUNT : {
                    '-=' : 800
                },
                TAX_AMOUNT : {
                    '-=' : 200
                }
            }).where(ID)
            const updatePOInfo = await transaction.read(PurchaseOrderSrv);
            return updatePOInfo;
        } catch(error) {
            return "Error: " + error.toString();
        }
    })
 
    //Implementation of Instance bounded function
    this.on('largestOrder', async(request, response) => {
        try{
            const transaction = cds.tx(request);
            const reply = await transaction.read(PurchaseOrderSrv).orderBy({
                GROSS_AMOUNT : 'desc'
            }).limit(5);
           
            return reply;
        } catch(error) {
            return "Error: " + error.toString();
        }
    })

    this.on('increaseSalary', async(request, response) => {
        try{
            //Step 1: Get the paramater from the entity
            const ID = request.params[0];
            //Step 2: Creating object for transaction service using request
            const transaction = cds.tx(request);
            //Step 3: Update the purchase order service
            await transaction.update(EmployeeSrv).with({
                salaryAmount : {
                    '*=' : 1.15
                }
            }).where(ID)
            const updatePOInfo = await transaction.read(EmployeeSrv);
            return updatePOInfo;
        } catch(error) {
            return "Error: " + error.toString();
        }
    })


    this.on('highestPaid', async(request, response) => {
        try{
            const transaction = cds.tx(request);
            const reply = await transaction.read(EmployeeSrv).orderBy({
                salaryAmount : 'desc'
            }).limit(20);
           
            return reply;
        } catch(error) {
            return "Error: " + error.toString();
        }
    })

    this.on('getUtilities', async(request,response) =>{
        let vUUID = uuid() , vPackageContent = null , vInput = "%E0%A4%A6", uri , dirExists = false , isFileExists = false;

        //Exists
        if(exists('srv/request.http')){
            isFileExists = true;

        }

        //Is Directory exists or not
        if(isdir('app'))
        {
            dirExists = true;
        }
        // Decode URI
        try{
            uri = decodeURI(vInput);
            //Make directory
            await mkdirp('srv/lib');
        }catch {
            uri = vInput;
        }

        vPackageContent = await read('package.json');
        //Final Value
        var finalValue={
            uuid : vUUID,
            uri : uri,
            isFileExists : isFileExists,
            dirExists : dirExists,
            packageInfo : vPackageContent
        }
        return finalValue;

    })

})