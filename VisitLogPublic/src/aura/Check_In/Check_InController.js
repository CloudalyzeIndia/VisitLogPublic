({
    doInit : function(component, event, helper) {
        helper.fetchLocation(component, event, helper);
        var action = component.get('c.fetchPreviousStatus');
        action.setParams({'recordId': component.get("v.recordId")});  
        action.setCallback(this, function(result){
            var state = result.getState();
            var response = result.getReturnValue();
            if (component.isValid() && state === "SUCCESS"){
                if(typeof(response)==='object'){
                    component.set("v.checkInRecord", response);
                    var checkInLocation = response.CheckInAddress__c;
                    var checkedInTime = new Date(response.CheckInTime__c);
                    var time = checkedInTime.toLocaleTimeString();
                    var checkInTime = checkedInTime.toISOString().slice(0,10) + '  ' + time;
                    component.set("v.checkInTime", checkInTime); 
                    component.set("v.alreadyCheckedIn", true); 
                    component.set("v.checkInLocation", checkInLocation); 
                }
                else if(response==='NA'){
                    component.set("v.alreadyCheckedIn", false); 
                }
                    else{
                        helper.displayToast("Error!","error","An error has occured. Please contact the Administrator","sticky");
                    }
            }
            else{
                helper.displayToast("Error!","error","Could not check in. Please contact the Administrator","sticky");
            }
        });
        $A.enqueueAction(action);
    },
    checkIn : function(component, event, helper) {
        helper.fetchLocation(component, event, helper);
		var lat = component.get("v.lat");
		var lng = component.get("v.lng"); 
		if(lat==='undefined' || lng ==='undefined'){
			helper.displayToast("Error!","error","Could not fetch current location. Please check or provide locations access to app","sticky");
		}
		else{
			var action = component.get('c.performCheckIn');
			//console.log(lat + ' '+ lng);
			action.setParams({'recordId': component.get("v.recordId"), 'latitude':lat, 'longitude':lng, 'type':'Check-In'});  
			action.setCallback(this, function(result){
				var state = result.getState();
				var response = result.getReturnValue();
				if (component.isValid() && state === "SUCCESS"){
					if(response=='success'){
						helper.displayToast("Success!","success","Checked-In successfully","dismissible");
					}
					else{
						helper.displayToast("Error!","error","Could not check in. Please contact the Administrator","sticky");
					}
					helper.navigateToSObject(component.get("v.recordId"));
				}
				else{
					helper.displayToast("Error!","error","Could not check in. Please contact the Administrator","sticky");
				}
			});
			$A.enqueueAction(action);
		}
    },
    
    checkOut : function(component, event, helper) {
        helper.fetchLocation(component, event, helper);
		var lat = component.get("v.lat");
		var lng = component.get("v.lng"); 
		if(lat=='undefined' || lng == 'undefined'){
			helper.displayToast("Error!","error","Could not fetch current location. Please check or provide locations access to app","dismissible");
		}
		else{
			var action = component.get('c.performCheckOut');
			action.setParams({'checkInRecord': component.get("v.checkInRecord"), 'latitude':lat, 'longitude':lng});  
			action.setCallback(this, function(result){
				var state = result.getState();
				var response = result.getReturnValue();
				if (component.isValid() && state === "SUCCESS"){
					if(response=='success'){
						helper.displayToast("Success!","success","Checked-Out successfully","dismissible");
					}
					else{
						helper.displayToast("Error!","error",response,"sticky");
					}
					helper.navigateToSObject(component.get("v.recordId"));
				}
				else{
					helper.displayToast("Error!","error","Could not Check-Out. Please contact the Administrator","sticky");
				}
			});
			$A.enqueueAction(action);
		}     
    }
})