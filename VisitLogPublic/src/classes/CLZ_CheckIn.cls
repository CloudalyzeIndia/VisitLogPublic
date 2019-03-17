/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
Name:            CLZ_CheckIn.cls
Description:     This class contains the logic for Handling CheckIn and CheckOut functionality

Date             Version        Author           Summary of Changes 
-----------      ----------  ---------------     ------------------------------------------------------------------------------------------------
November 2018      1.0          Cloudalyze       CLZ_CheckIn(New)
---------------------------------------------------------------------------------------------------------------------------------------------------------- */
public class CLZ_CheckIn{
    
    /**********************************************************************************************************************   
        * Name :           fetchPreviousStatus
        * Author:          Cloudalyze
        * Date:            November 2018       
        * Param:           String
        * Return:          Object
        * Description:     This method is used to create a checkin record corresponding to a record.
        * Change Summary:  Initial release  
    ********************************************************************************************************************* */
    @AuraEnabled
    public static object fetchPreviousStatus(String recordId){
        list<CheckIn__c>checkInList = new list<CheckIn__c>();
        CheckIn__c checkInObj=new CheckIn__c();
        try{
            String sobjectType = ID.valueOf(recordId).getSObjectType().getDescribe().getName();    
            if(sobjectType == 'Opportunity'){
                checkInList = [select id,Type__c,CheckInTime__c,CheckInLocation__Longitude__s,CheckInAddress__c,CheckInLocation__Latitude__s,CheckOutLocation__Longitude__s,CheckOutLocation__Latitude__s,OpportunityId__c from CheckIn__c where OwnerId=:Userinfo.getUserID() AND Type__c='Check-In' AND OpportunityId__c=:recordId ];
            }
            else if(sobjectType == 'Lead'){
                checkInList = [select id,Type__c,CheckInTime__c,CheckInLocation__Longitude__s,CheckInAddress__c,CheckInLocation__Latitude__s,ProspectId__c from CheckIn__c where OwnerId=:Userinfo.getUserID() AND Type__c='Check-In' AND ProspectId__c=:recordId ];
            }
            else{
                checkInList = [select id,Type__c,CheckInTime__c,CheckInAddress__c,CheckInLocation__Longitude__s,CheckInLocation__Latitude__s,
                Case__c from CheckIn__c where OwnerId=:Userinfo.getUserID() AND Type__c='Check-In' AND Case__c =:recordId ];
            }
            
            if(checkInList.size()>0){
                return checkInList[0];
            }
            else{//When there is no relevant CheckIn record already present
                return 'NA';
            }
        }
        catch(Exception ex){
            CLZ_ErrorLogUtility.logExceptions(ex,'CLZ_CheckIn','fetchPreviousStatus',   'Query',recordId,'CheckIn__c',true,'CRITICAL');
            return 'An Error has been occured. Please contact your System Administrator';
        }
    }
    
    /**********************************************************************************************************************   
        * Name :           updateGeoOnRelevantObject
        * Author:          Cloudalyze
        * Date:            November 2018       
        * Param:           String,Decimal,Decimal,String
        * Return:          String
        * Description:     This method is used to create a checkin record corresponding to a record.
        * Change Summary:  Initial release  
    ********************************************************************************************************************* */
    @AuraEnabled
    public static String performCheckIn(String recordId, Decimal latitude, Decimal longitude,string type){
        try{
            if(recordId!='' && latitude!=null && longitude!=null & type!=''){
                String sobjectType = ID.valueOf(recordId).getSObjectType().getDescribe().getName();    
                CheckIn__c checkInObj= new CheckIn__c();
                checkInObj.CheckInLocation__Longitude__s = longitude;
                checkInObj.CheckInLocation__Latitude__s = latitude;
                checkInObj.CheckInTime__c = System.Now();
                checkInObj.Type__c  = type;
                if(sobjectType=='Opportunity'){
                    checkInObj.OpportunityId__c = recordId;
                }
                else if(sobjectType == 'Lead'){
                    checkInObj.ProspectId__c = recordId;
                }
                else{
                    checkInObj.Case__c = recordId;
                }
                insert checkInObj;
                if(checkInObj.CheckInLocation__Latitude__s!=null && checkInObj.CheckInLocation__Longitude__s!=null){
                    performGoogleCallout(String.valueOf(checkInObj.CheckInLocation__Latitude__s), String.valueOf(checkInObj.CheckInLocation__Longitude__s),checkInObj.id, 'Check-In');
                }
                return 'success';
            }
            else{
                return 'Error';
            }
        }
        catch(Exception ex){
            CLZ_ErrorLogUtility.logExceptions(ex,'CLZ_CheckIn','updateGeoOnRelevantObject','Insert',recordId,'CheckIn__c',true,'CRITICAL');
            return 'Error:An Error has been generated. Please Contact system Administrator';
        }
    }
    /**********************************************************************************************************************   
        * Name :           performCheckOut
        * Author:          Cloudalyze
        * Date:            November 2018       
        * Param:           CheckIn__c,Decimal,decimal
        * Return:          String
        * Description:     This method is used to perform the checkout on to a location.
        * Change Summary:  Initial release  
    ********************************************************************************************************************* */
    @AuraEnabled
    public static String performCheckOut(CheckIn__c checkInRecord, Decimal latitude, Decimal longitude){
        try{
            if(checkInRecord!=null){
                if(latitude!=null && longitude!=null){
                    checkInRecord.Type__c = 'Check-Out';
                    checkInRecord.CheckOutLocation__Longitude__s = longitude ;
                    checkInRecord.CheckOutLocation__Latitude__s = latitude;
                    checkInRecord.CheckOutTime__c = System.Now();
                    update checkInRecord;
                    if(checkInRecord.CheckOutLocation__Latitude__s!=null && checkInRecord.CheckOutLocation__Longitude__s!=null){
                        performGoogleCallout(String.valueOf(checkInRecord.CheckOutLocation__Latitude__s), String.valueOf(checkInRecord.CheckOutLocation__Longitude__s),checkInRecord.id, 'Check-Out');
                    }
                    return 'success';
                }
                else{
                    return 'Location could not be fetched. Please try again';
                }
            }
            else{
                return 'No Relevant Check-In record found';
            }
        }
        catch(Exception ex){
            CLZ_ErrorLogUtility.logExceptions(ex,'CLZ_CheckIn','performCheckOut','update',checkInRecord.Id,'CheckIn__c',true,'CRITICAL');
            return 'Could Not checkout. Please contact Administrator';
        }
    }
    /**********************************************************************************************************************   
        * Name :           performGoogleCallout
        * Author:          Cloudalyze
        * Date:            November 2018       
        * Param:           String,String
        * Return:          String
        * Description:     This method is used to perform the callout to Google Reverse Geocode API
        * Change Summary:  Initial release  
    ********************************************************************************************************************* */
    @future(callout=true)
    public static void performGoogleCallout(string lat, string lng, Id checkInId, string type){
        try{
            HttpResponse response;
            String responseBody;
            if(lat!='' && lng!=''){
                string googleURL = Label.GoogleReverseGeocodingAPIURL;
                string latlng = lat + ',' +lng;
                string key = Label.GoogleReverseGeocodingAPIKey;
                
                string endPointUrl = googleURL+latlng+ '&key=' + key;
                    
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint(endPointUrl);
                req.setHeader('content-type', 'application/json');
                req.setTimeout(120000);
                req.setMethod('GET');                
                response = h.send(req);
                
                //String result = String.valueOf( JSON.deserializeUntyped(response.getBody()) );
                //System.debug('jayesh ' + result);
                //.debug('jayesh ' + response.getBody());
                responseBody = response.getBody();
                System.debug('jayesh ' + responseBody);
            }
            else{
                //To-Do: Log error when the record is null
            }
            if(responseBody!='' || responseBody!=null){
                String address;
                JSONParser parser = JSON.createParser(responseBody);
                while(parser.nextToken() != null){
                    if(parser.getCurrentToken() == JSONToken.FIELD_NAME){
                        String fieldName = parser.getText();
                        parser.nextToken();
                        if(fieldName == 'formatted_address' && (address=='' || address==null)){
                            address = parser.getText();
                        }
                    }
                }
                if(address!='' || address!=null){
                    CheckIn__c checkInRecord = new CheckIn__c();
                    if(type == 'Check-Out'){
                        checkInRecord = [select id,CheckOutLocation__Longitude__s,CheckOutLocation__Latitude__s,CheckOutAddress__c from CheckIn__c where id=:checkInId];
                        checkInRecord.CheckOutAddress__c = address;
                    }
                    else{
                        checkInRecord= [select id,CheckInLocation__Longitude__s,CheckInLocation__Latitude__s,CheckInAddress__c from CheckIn__c where id=:checkInId];
                        checkInRecord.CheckInAddress__c = address;
                    }
                    update checkInRecord;
                }
            }
        }
        catch(Exception ex){
            CLZ_ErrorLogUtility.logExceptions(ex,'CLZ_CheckIn','performGoogleCallout','callout',lat+lng,'CheckIn__c',true,'CRITICAL');
            
        }
    }
}