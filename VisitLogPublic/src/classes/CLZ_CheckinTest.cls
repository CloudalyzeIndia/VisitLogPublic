@isTest
public class CLZ_CheckinTest {
    
    
    static testmethod void methodNew(){ 
    Lead ld = CLZ_TestUtlity.createLead(True,'Working', '0123456789','abc@tt.com');
        /*FieldMap__mdt Fieldmap = CLZ_TestUtlity.createFieldmap(True);*/
        Account acc = CLZ_TestUtlity.createAccount(true);
        Contact con = CLZ_TestUtlity.createContact(True, acc.id);
        Opportunity opp = CLZ_TestUtlity.createOpportunity(true, acc.id, con.id);
        Decimal lat = 18.6239;
         Decimal longi = 73.8125;
        CheckIn__c testNew= new CheckIn__c();
        testNew.OpportunityId__c=opp.id;
        testNew.ProspectId__c=ld.id;
        testNew.CheckInLocation__Longitude__s = longi;
        testNew.CheckInLocation__Latitude__s = lat; 
        testNew.Type__c  = 'Check-In';     
        insert testNew;
        CLZ_CheckIn.fetchPreviousStatus(testNew.id);
        CLZ_CheckIn.performCheckIn(testNew.id,lat,longi ,'Check-In');
        CLZ_CheckIn.performCheckOut(testNew,lat,longi);
        //CLZ_CheckIn.performGoogleCallout('lat','longi',testNew.Id,'Check-In');      
    }
    
    static testmethod void methodNew2(){ 
        Lead ld = CLZ_TestUtlity.createLead(True,'Working', '0123444789','abc1@tt.com');
       /* FieldMap__mdt Fieldmap = CLZ_TestUtlity.createFieldmap(True);*/
        Account acc = CLZ_TestUtlity.createAccount(true);
        Contact con = CLZ_TestUtlity.createContact(True, acc.id);
        Opportunity opp = CLZ_TestUtlity.createOpportunity(true, acc.id, con.id);
        Decimal lat = 18.6239;
         Decimal longi = 73.8125;
        CheckIn__c testNew1= new CheckIn__c();
        testNew1.OpportunityId__c=opp.id;
        testNew1.ProspectId__c=ld.id;
        testNew1.CheckInLocation__Longitude__s = longi;
        testNew1.CheckInLocation__Latitude__s = lat; 
        testNew1.Type__c  = 'Check-In';     
        insert testNew1;
        CLZ_CheckIn.fetchPreviousStatus(opp.id);
        CLZ_CheckIn.performCheckIn(opp.id,lat,longi ,'Check-In');
        CLZ_CheckIn.performCheckOut(null,lat,longi);
        //CLZ_CheckIn.performGoogleCallout(null,null,testNew1.Id,'Check-In');      
      
    }
    static testmethod void  methodNew3(){ 
        Lead ld = CLZ_TestUtlity.createLead(True,'Working', '01234664789','abc2@tt.com');
       /* FieldMap__mdt Fieldmap = CLZ_TestUtlity.createFieldmap(True);*/
        Account acc = CLZ_TestUtlity.createAccount(true);
        Contact con = CLZ_TestUtlity.createContact(True, acc.id);
        Opportunity opp = CLZ_TestUtlity.createOpportunity(true, acc.id, con.id);
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt1', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser111@testorg.com');
            System.runAs(u) {
            // The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
            }
        Decimal lat = 18.6239;
         Decimal longi = 73.8125;
        CheckIn__c testNew1= new CheckIn__c();
        testNew1.OpportunityId__c=opp.id;
        testNew1.ProspectId__c=ld.id;
        testNew1.Type__c='Check-In';
        testNew1.ownerid=u.id;
        insert testNew1;
        CLZ_CheckIn.fetchPreviousStatus(ld.id);
        CLZ_CheckIn.performCheckIn(ld.id,lat,longi ,'test');
        CLZ_CheckIn.performCheckOut(testNew1,null,null);
        String googleResponseBody = '{plus_code={compound_code=GW6F+J6 Pune, Maharashtra, India, global_code=7JCMGW6F+J6}, results=({address_components=({long_name=Pentagon 3, short_name=Pentagon 3, types=(premise)}, {long_name=Magarpatta City, short_name=Magarpatta City, types=(political, sublocality, sublocality_level_2)}, {long_name=Hadapsar, short_name=Hadapsar, types=(political, sublocality, sublocality_level_1)}, {long_name=Pune, short_name=Pune, types=(locality, political)}, {long_name=Pune, short_name=Pune, types=(administrative_area_level_2, political)}, {long_name=Maharashtra, short_name=MH, types=(administrative_area_level_1, political)}, {long_name=India, short_name=IN, types=(country, political)}, {long_name=411028, short_name=411028, types=(postal_code)}), formatted_address=Pentagon 3, Magarpatta City, Hadapsar, Pune, Maharashtra 411028, India, geometry={bounds={northeast={lat=18.5115257, lng=73.92354639999999}, southwest={lat=18.5110632, lng=73.9231077}}, location={lat=18.5112476, lng=73.9233984}, location_type=ROOFTOP, viewport={northeast={lat=18.5126434302915, lng=73.92467603029149}, southwest={lat=18.5099454697085, lng=73.92197806970849}}}, place_id=ChIJI8cmQ-3BwjsR_vMPwb17Mxs, types=(premise)}, {address_components=({long_name=Jasminium Society Road, short_name=Jasminium Society Road, types=(route)}, {long_name=Magarpatta City, short_name=Magarpatta City, types=(political, sublocality, sublocality_level_2)}, {long_name=Hadapsar, short_name=Hadapsar, types=(political, sublocality, sublocality_level_1)}, {long_name=Pune, short_name=Pune, types=(locality, political)}, {long_name=Pune, short_name=Pune, types=(administrative_area_level_2, political)}, {long_name=Maharashtra, short_name=MH, types=(administrative_area_level_1, political)}, {long_name=India, short_name=IN, types=(country, political)}, {long_name=411028, short_name=411028, types=(postal_code)}), formatted_address=Jasminium Society Road, Magarpatta City, Hadapsar, Pune, Maharashtra 411028, India, geometry={bounds={northeast={lat=18.5118714, lng=73.9236999}, southwest={lat=18.5099897, lng=73.9225903}}, location={lat=18.5107501, lng=73.9229429}, location_type=GEOMETRIC_CENTER, viewport={northeast={lat=18.5122795302915, lng=73.92449408029151}, southwest={lat=18.5095815697085, lng=73.92179611970849}}}, place_id=ChIJ3RBzae3BwjsR1_Z7xHSi3FI, types=(route)}, {address_components=({long_name=1, short_name=1, types=(street_number)}, {long_name=Jasminium Society Road, short_name=Jasminium Society Road, types=(route)}, {long_name=Magarpatta City, short_name=Magarpatta City, types=(political, sublocality, sublocality_level_2)}, {long_name=Hadapsar, short_name=Hadapsar, types=(political, sublocality, sublocality_level_1)}, {long_name=Pune, short_name=Pune, types=(locality, political)}, {long_name=Pune, short_name=Pune, types=(administrative_area_level_2, political)}, {long_name=Maharashtra, short_name=MH, types=(administrative_area_level_1, political)}, {long_name=India, short_name=IN, types=(country, political)}, {long_name=411028, short_name=411028, types=(postal_code)}), formatted_address=1, Jasminium Society Road, Magarpatta City, Hadapsar, Pune, Maharashtra 411028, India, geometry={location={lat=18.5105354, lng=73.92369599999999}, location_type=RANGE_INTERPOLATED, viewport={northeast={lat=18.5118843802915, lng=73.9250449802915}, southwest={lat=18.5091864197085, lng=73.92234701970848}}}, place_id=EjQxLCBKYXNtaW5pdW0gU29jaWV0eSBSb2FkLCBNYWhhcmFzaHRyYSA0MTEwMjgsIEluZGlhIhoSGAoUChIJ3RBzae3BwjsR1vZ7xHSi3FIQAQ, types=(street_address)}, {address_components=({long_name=Magarpatta City, short_name=Magarpatta City, types=(political, sublocality, sublocality_level_2)}, {long_name=Hadapsar, short_name=Hadapsar, types=(political, sublocality, sublocality_level_1)}, {long_name=Pune, short_name=Pune, types=(locality, political)}, {long_name=Pune, short_name=Pune, types=(administrative_area_level_2, political)}, {long_name=Maharashtra, short_name=MH, types=(administrative_area_level_1, political)}, {long_name=India, short_name=IN, types=(country, political)}), formatted_address=Magarpatta City, Hadapsar, Pune, Maharashtra, India, geometry={bounds={northeast={lat=18.5235315, lng=73.932817}, southwest={lat=18.5084443, lng=73.918173}}, location={lat=18.5158057, lng=73.9271644}, location_type=APPROXIMATE, viewport={northeast={lat=18.5235315, lng=73.932817}, southwest={lat=18.5084443, lng=73.918173}}}, place_id=ChIJTUXTP43BwjsRxNCgCBBrrjg, types=(political, sublocality, sublocality_level_2)}, {address_components=({long_name=Hadapsar, short_name=Hadapsar, types=(political, sublocality, sublocality_level_1)}, {long_name=Pune, short_name=Pune, types=(locality, political)}, {long_name=Pune, short_name=Pune, types=(administrative_area_level_2, political)}, {long_name=Maharashtra, short_name=MH, types=(administrative_area_level_1, political)}, {long_name=India, short_name=IN, types=(country, political)}), formatted_address=Hadapsar, Pune, Maharashtra, India, geometry={bounds={northeast={lat=18.526358, lng=73.9717247}, southwest={lat=18.46815, lng=73.907113}}, location={lat=18.5089197, lng=73.9260261}, location_type=APPROXIMATE, viewport={northeast={lat=18.526358, lng=73.9717247}, southwest={lat=18.46815, lng=73.907113}}}, place_id=ChIJ6arxgf_pwjsRU4usVTU0YCU, types=(political, sublocality, sublocality_level_1)}, {address_components=({long_name=411028, short_name=411028, types=(postal_code)}, {long_name=Pune, short_name=Pune, types=(locality, political)}, {long_name=Pune, short_name=Pune, types=(administrative_area_level_2, political)}, {long_name=Maharashtra, short_name=MH, types=(administrative_area_level_1, political)}, {long_name=India, short_name=IN, types=(country, political)}), formatted_address=Pune, Maharashtra 411028, India, geometry={bounds={northeast={lat=18.5236714, lng=73.9688812}, southwest={lat=18.4506042, lng=73.9128769}}, location={lat=18.5149325, lng=73.9261587}, location_type=APPROXIMATE, viewport={northeast={lat=18.5236714, lng=73.9688812}, southwest={lat=18.4506042, lng=73.9128769}}}, place_id=ChIJG2oxkf7pwjsRdBfz7ZT74Vo, types=(postal_code)}, {address_components=({long_name=Pune, short_name=Pune, types=(locality, political)}, {long_name=Pune, short_name=Pune, types=(administrative_area_level_2, political)}, {long_name=Maharashtra, short_name=MH, types=(administrative_area_level_1, political)}, {long_name=India, short_name=IN, types=(country, political)}), formatted_address=Pune, Maharashtra, India, geometry={bounds={northeast={lat=18.6357545, lng=73.98645689999999}, southwest={lat=18.4134784, lng=73.7394779}}, location={lat=18.5204303, lng=73.8567437}, location_type=APPROXIMATE, viewport={northeast={lat=18.6357545, lng=73.98645689999999}, southwest={lat=18.4134784, lng=73.7394779}}}, place_id=ChIJARFGZy6_wjsRQ-Oenb9DjYI, types=(locality, political)}, {address_components=({long_name=Pune, short_name=Pune, types=(administrative_area_level_2, political)}, {long_name=Maharashtra, short_name=MH, types=(administrative_area_level_1, political)}, {long_name=India, short_name=IN, types=(country, political)}), formatted_address=Pune, Maharashtra, India, geometry={bounds={northeast={lat=19.38404, lng=75.16309}, southwest={lat=17.89324, lng=73.32352}}, location={lat=18.6832564, lng=74.0300122}, location_type=APPROXIMATE, viewport={northeast={lat=19.38404, lng=75.16309}, southwest={lat=17.89324, lng=73.32352}}}, place_id=ChIJQ97RPE_AwjsR5zbDDbo3wHI, types=(administrative_area_level_2, political)}, {address_components=({long_name=Maharashtra, short_name=MH, types=(administrative_area_level_1, political)}, {long_name=India, short_name=IN, types=(country, political)}), formatted_address=Maharashtra, India, geometry={bounds={northeast={lat=22.028441, lng=80.890924}, southwest={lat=15.6024121, lng=72.659363}}, location={lat=19.7514798, lng=75.7138884}, location_type=APPROXIMATE, viewport={northeast={lat=22.028441, lng=80.890924}, southwest={lat=15.6024121, lng=72.659363}}}, place_id=ChIJ-dacnB7EzzsRtk_gS5IiLxs, types=(administrative_area_level_1, political)}, {address_components=({long_name=India, short_name=IN, types=(country, political)}), formatted_address=India, geometry={bounds={northeast={lat=35.513327, lng=97.39535869999999}, southwest={lat=6.4626999, lng=68.1097}}, location={lat=20.593684, lng=78.96288}, location_type=APPROXIMATE, viewport={northeast={lat=35.513327, lng=97.39535869999999}, southwest={lat=6.4626999, lng=68.1097}}}, place_id=ChIJkbeSa_BfYzARphNChaFPjNc, types=(country, political)}), status=OK}'; 
        CLZ_CalloutMockGenerator mockObj = new CLZ_CalloutMockGenerator (200, googleResponseBody );
            Test.setMock(HttpCalloutMock.class, mockObj);
        CLZ_CheckIn.performGoogleCallout('lat','longi',testNew1.Id,'Check-In');      
      
    }
    static testmethod void methodNew4(){ 
            Decimal lat = 18.6239;
         Decimal longi = 73.8125;   
        CLZ_CheckIn.fetchPreviousStatus(null);   
        CLZ_CheckIn.performCheckIn(null,null,null,null);
        CLZ_CheckIn.performCheckOut(null,null,longi);
    }
    
      
}