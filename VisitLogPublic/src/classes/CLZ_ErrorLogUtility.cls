/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
Name:            CLZ_ErrorLogUtility.cls
Description:     This is the utility class where all the Error logs/Exceptions will be tracked in ErrorLog object 

Date             Version        Author           Summary of Changes 
-----------      ----------  ---------------     ------------------------------------------------------------------------------------------------
October 2018       1.0          Cloudalyze       CLZ_ErrorLogUtility(New)
---------------------------------------------------------------------------------------------------------------------------------------------------------- */
public class CLZ_ErrorLogUtility{
    /**********************************************************************************************************************   
        * Name :           logExceptions
        * Author:          Cloudalyze
        * Date:            October 2018       
        * Param:           Id
        * Return:          string
        * Description:     This is utility method to log Errors/Exceptions
        * Change Summary:  Initial release  
    ********************************************************************************************************************* */
    
    public static void logExceptions(Exception ex,string className,string methodName,string operation,string recordId,string objectName,boolean notification,string severity){
        ErrorLog__c logObj = new ErrorLog__c();
        logObj.Description__c = ex.getMessage();
        logObj.StackTrace__c = ex.getStackTraceString();
        logObj.ExceptionTypeCaught__c = ex.getTypeName();
        logObj.ErrorLineNumber__c = String.valueOf(ex.getLineNumber());
        logObj.ClassName__c = className;
        logObj.MethodName__c = methodName;
        logObj.Operation__c = operation;
        logObj.Object__c = objectName;
        logObj.LogSeverity__c = severity;
        if(recordId!=null){
            logObj.RecordID__c = recordId;
        }
        logObj.SendNotification__c = notification;
        insert logObj;
    }
    
    /**********************************************************************************************************************   
        * Name :           createLogsForTracking
        * Author:          Cloudalyze
        * Date:            October 2018       
        * Param:           String,string,string,string,boolean
        * Return:          NA
        * Description:     This method is used to log errors where Exceptions are not generated.
        * Change Summary:  Initial release  
    ********************************************************************************************************************* */
    public static void createLogsForTracking(string message,String type,String className, String methodName,boolean sendNotification){
        ErrorLog__c errObj = new ErrorLog__c();
        errObj.Description__c = message;
        errObj.LogSeverity__c = type;
        errObj.ClassName__c = className;
        errObj.MethodName__c = methodName;
        errObj.SendNotification__c = sendNotification;
        insert errObj;
    }
    
    /**********************************************************************************************************************   
        * Name :           logIntegrationExceptions
        * Author:          Cloudalyze
        * Date:            December 2018       
        * Param:           Id
        * Return:          string
        * Description:     This is utility method to log Errors/Exceptions in any Integration
        * Change Summary:  Initial release
    ********************************************************************************************************************* */
    
    public static void logIntegrationExceptions(string className,string methodName,string operation,string recordId,string objectName,boolean notification,string severity, String request, String response){
        ErrorLog__c logObj = new ErrorLog__c();
        logObj.Description__c = 'Integration Error';
        logObj.StackTrace__c = '';
        logObj.ExceptionTypeCaught__c = '';
        logObj.ErrorLineNumber__c = '';
        logObj.ClassName__c = className;
        logObj.MethodName__c = methodName;
        logObj.Operation__c = operation;
        logObj.Object__c = objectName;
        logObj.LogSeverity__c = severity;
        logObj.Integration_Request__c = request;
        logObj.Integration_Response__c = response;
        if(recordId!=null){
            logObj.RecordID__c = recordId;
        }
        logObj.SendNotification__c = notification;
        insert logObj;
    }
}