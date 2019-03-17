({
    //Utility method to display the Toast message.
    displayToast : function(title,type,message,mode) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,"type" : type,"message": message,"mode":mode
        });
        toastEvent.fire();		
    },
    //Utility method to navigate to sObject
    navigateToSObject : function(recordId){
        var sobjectEvent=$A.get("e.force:navigateToSObject");
        sobjectEvent.setParams({
            "recordId": recordId
        });
        sobjectEvent.fire();
    },
    fetchLocation : function(component, event,helper){
        if(navigator.geolocation){
            navigator.geolocation.getCurrentPosition(success,errorCallback, {enableHighAccuracy: true,maximumAge: 0});
            function success(position) {
                var lat = position.coords.latitude;
                var long = position.coords.longitude; 
                component.set("v.lat", lat); 
                component.set("v.lng", long); 
            }
            function errorCallback(err) {
                component.set("v.locationFetched", false); 
                if(err.code == 0) {
                    helper.displayToast("Error!","error","An unknown error has occured. Please contact the Administrator","dismissible");
                }
                else if(err.code == 1) {
                    helper.displayToast("Error!","error","Please check the location access for the app and try again.","dismissible");
                }
                else if(err.code == 2) {
                    helper.displayToast("Error!","error","The location of the device could not be determined. Please try again","dismissible");
                }
                else if(err.code == 3) {
                    helper.displayToast("Error!","error","Unable to retrieve the location of the device due to timeout. Please try again","dismissible");
                }        
            }
        }
        else{
            this.displayToast("Error!","error","Could not read the location on your device. Please check","dismissible");    
        }
    }
})