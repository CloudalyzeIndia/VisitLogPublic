/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
Name:            CLZ_TestUtlity.cls
Description:     This is the utility class to create Test records to be used in Unit Testing.

Date             Version        Author           Summary of Changes 
-----------      ----------  ---------------     ------------------------------------------------------------------------------------------------
October 2018       1.0          Cloudalyze       CLZ_TestUtlity (New)
---------------------------------------------------------------------------------------------------------------------------------------------------------- */

@isTest
public class CLZ_TestUtlity {

    public static Lead createLead(Boolean doInsert, String status, String mobile, String email){
        Lead newLead = new Lead();
        newLead.FirstName = 'Test';
        newLead.LastName = 'Testing';
        newLead.Email = email;

        newLead.Description = 'test description';
        newLead.Status = status;
        newLead.Company = 'ABC Company';
        newLead.LeadSource = 'Principal';
        newLead.MobilePhone = mobile;
        /*newLead.BillingStreet = '123 Broadway';
        newLead.BillingCity = 'Mumbai';
        newLead.BillingState = 'Maharastra';
        newLead.BillingCountry = 'India';
        newLead.BillingZipCode = '411000';
        newLead.ShippingCity = 'Mumbai';
        newLead.ShippingCountry = 'India';
        newLead.ShippingStreet = '123 Broadway';
        newLead.ShippingState = 'Maharastra';
        newLead.ShippingZipCode ='411000';*/
        newLead.IsConverted = False;
        /*newLead.NoofEmployees = 12.2;*/
        newLead.DoNotCall = False;
         /*newLead.Department = 'Arts'; */
        newLead.Description = 'Testing the lead';
        
        if(doInsert){
            insert newLead;
        }
        return newLead;
    }
    
    public static Account createAccount(Boolean doInsert){
        Account newAccount = new Account();
        newAccount.Name = 'ABC';
        newAccount.BillingCity = 'Mumbai';
        newAccount.BillingCountry = 'India';
        newAccount.BillingPostalCode = '400001';
        newAccount.BillingStreet = '123 street';
        newAccount.BillingState  = 'Maharastra';
        newAccount.Type = 'Customer';
        newAccount.Description = 'Account Description';
        newAccount.NumberOfEmployees = 12;
        
        if(doInsert){
            insert newAccount;
        }
        return newAccount;
    }
    
    public static Contact createContact(Boolean doInsert, id accId){
        Contact newContact = new Contact();
        if(accId!=NULL){
            newContact.AccountId = accId;
        }
        newContact.FirstName = 'Test';
        newContact.LastName = 'Testing';
       
        if(doInsert){
            insert newContact;
        }
        return newContact;
    }
    
   public static Opportunity createOpportunity(Boolean doInsert, id accId, id conId){
        Opportunity newOpportunity = new Opportunity();
        if(accId!= NULL){
            newOpportunity.AccountId = accId;
        }
        if(conId!= NULL){
            newOpportunity.OwnerId = conId;
        }
        newOpportunity.Name = 'Test Opportunity';
        newOpportunity.CloseDate = system.today()+2;
        newOpportunity.LeadSource = 'Web';
        newOpportunity.StageName = 'Prospecting';
        //newOpportunity.BillingState = 'Maharashtra';
        
        if(doInsert){
            insert newOpportunity;
        }
        return newOpportunity;
    }
    
    /*public static OpportunityLineItem createOpportunityLineItem(Boolean doInsert, Id oppId){
        OpportunityLineItem oli = new OpportunityLineItem();
        if(oppId != null){
            oli.Opportunity = oppId;
        }

        if(doInsert){
            insert oli;
        }
        return oli;
    }*/
    
    //method for custom metadata
    /*public static FieldMap__mdt createFieldmap(Boolean doInsert){
        FieldMap__mdt newmetaData = new FieldMap__mdt(); 
        newmetaData.Destination_Object__c = 'QuoteLineItem__c';
        newmetaData.Destination_Object_Field__c = 'name';
        newmetaData.MappingActive__c = false;
        newmetaData.Source_Object__c = 'Quote';
        newmetaData.SourceObjectField__c = 'text';
        return newmetaData;
    }*/
    
    /*public static void insertCustomSettings(Boolean doInsert) {
        ConfigurationSwitch__c configsw = ConfigurationSwitch__c.getOrgDefaults();
        configsw.Triggers__c = true;
        insert configsw;
    }*/
    
   /* public static Address__c createAddress(Boolean doInsert, Id accId){
        Address__c addr = new Address__c();
        if(accId!=null){
            addr.AccountId__c = accId;
        }
        
        addr.AddressType__c = 'Billing';
        addr.City__c='TestCity';
        addr.PostalCode__c='1234'; 
        addr.State__c='Maharashtra';
        addr.StreetAddress__c='Test';

        if(doInsert){
            insert addr;
        }
        return addr;
    }*/
    /*public static Product__c createProduct(Boolean doInsert){
        Product__c pro = new Product__c();
        pro.IsActive__c = true;
        pro.Discount__c = 6.00;
        pro.ListPrice__c = 440.00;
        pro.SalesPrice__c = 1000.00;
        pro.CGST__c = 9.0;
        pro.IGST__c = 18.0;
        pro.SGST__c = 9.0;
        pro.HSNSAC__c = '997136';
        pro.QuantityOrdered__c = 10;
        pro.ProductDescription__c = 'Test';

        if(doInsert){
            insert pro;
        }

        return pro;
    }*/
    
    /*public static Quote__c createQuote(Boolean doInsert, Id oppId){
        List<Account> companyAccounts = [SELECT Id,Name From Account Where Name='Dhupar Brother Tradings Pvt. Ltd.'];
        Address__c companyAddress;
        if(companyAccounts.isEmpty()){
            Account companyAccount = new Account(Name='Dhupar Brother Tradings Pvt. Ltd.');
            insert companyAccount;
            companyAddress = CLZ_TestUtlity.createAddress(true, companyAccount.Id);
        }else{
            companyAddress = CLZ_TestUtlity.createAddress(true, companyAccounts[0].Id);
        }
        
        Quote__c quo = new Quote__c();
        if(oppId != null){
            quo.OpportunityId__c = oppId;
        }
        
        quo.TransactionDate__c = Date.today();
        if(companyAddress.Id != null){
            quo.CompanyAddress__c = CompanyAddress.Id;
        }

        if(doInsert){
            insert quo;
        }
        return quo;
    }
    
    public static QuoteLineItem__c createQuoteLineItem(Boolean doInsert, Id quoId, Id proId){
        QuoteLineItem__c qli = new QuoteLineItem__c();
        qli.Description__c = 'Insurance';
        qli.Discount__c = 6.00;
        qli.ListPrice__c = 440.00;
        qli.SalesPrice__c = 1000.00;
        qli.ProductId__c = proId;
        qli.Quantity__c = 10;
        qli.CGST__c = 9.0;
        qli.IGST__c = 18.0;
        qli.SGST__c = 9.0;
        qli.HSNSAC__c = '997136';
        qli.Subtotal__c = 1880.00;
        qli.TotalPrice__c = 2218.40;
       // qli.TotalTax__c   = 338.40;
        qli.TaxType__c = 'Instate';
        qli.SGSTAmount__c = 0;
        qli.CGSTAmount__c = 0;
        qli.IGSTAmount__c = 0;
                if(quoId != null){
            qli.Quote__c = quoId;
        }

        if(doInsert){
            insert qli;
        }
        
        return qli;
    }*/
}