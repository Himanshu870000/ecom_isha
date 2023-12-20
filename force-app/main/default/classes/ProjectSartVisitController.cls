global class ProjectSartVisitController {
    public  string accId {get;set;}
    public  string visitId {get;set;}
    public string accDetails{get;set;}
    public string custDetails{get;set;}
    public String userId{get;set;}
    public boolean checkinnHandling{get;set;}
    public Static visit__c visitLookup{get;set;}
    public class visitDetailWrapper{
        public Payment__c paymentRec;
        public String accId;
        public Case caseRec;
        public String userId;
        public Return__c returnRec;
        
        public List<orderitem> orderLineItem;
    }
    global ProjectSartVisitController(){
        accId = apexpages.currentpage().getparameters().get('id');
        visitId = apexpages.currentpage().getparameters().get('vistId');
        userId = UserInfo.getUserId();
        system.debug('accId::'+accId);
        visitLookup = new Visit__c();
        getDealerDetails(accId);
        getCustomerDetails(visitId);
        checkinnHandling = getVisitcheckin(visitId);
    }
    
    global void getCustomerDetails(String vstId){
        visit__c vst = [select id,lead__r.name,lead__r.phone,lead__r.email,lead__r.AnnualRevenue,lead__r.Industry from visit__c where id =: vstId]; 
        custDetails = JSON.serialize(vst);
    }
    global  void getDealerDetails(String accId){
        project__c acc = [SELECT id,Name,Project_Lat__latitude__s,Project_Lat__longitude__s,city__c,Property_Type__c,Construction_Status__c,Property_Age_If_Old__c FROM project__c WHERE id =: accId];
        accDetails = JSON.serialize(acc);
        
    }
    global boolean getVisitcheckin(string visitId){
        list<visit__c> vstList = new list<visit__c>();
        vstList = [select id,CheckIn__Latitude__s from visit__c where id =: visitId limit 1];
        if(vstList[0].CheckIn__Latitude__s != null){
            return false;
        }
        else return true;
    }
    
    @RemoteAction
    global static String checkInDealerShop(Decimal checkinLat,Decimal checkinLang,String vstId,String accId){
        Location loc1 = Location.newInstance(12.8576,77.7864);
        Location loc2 = Location.newInstance(12.8576,77.7866);
        Double dist = Location.getDistance(loc1, loc2, 'km');
        
        try{
            if((dist * 1000) < 50){
                Visit__c vstRec = new Visit__c();
                vstRec.CheckIn__Latitude__s = checkinLat;
                vstRec.CheckIn__Longitude__s = checkinLang;
                vstRec.Job_Status__c = 'In Progress';
                vstRec.Id = vstId;
                UPDATE vstRec;
                RETURN 'Your check-in has been updated.';
            }else{
                RETURN 'Your location found far away from destination location. Please make sure that you are within 50 meter from destination location.';
            }
        }catch(Exception e){
            system.debug('Exception::'+e.getStackTraceString());
            RETURN 'Something went wrong.';
        }
    }
    
    @RemoteAction
    global static String checkOutDealerShop(Decimal checkoutLat,Decimal checkoutLang,String vstId,String accId){
        /*Location loc1 = Location.newInstance(12.8576,77.7864);
Location loc2 = Location.newInstance(12.8576,77.7866);
Double dist = Location.getDistance(loc1, loc2, 'km');*/
        
        try{
            Visit__c vstRec = new Visit__c();
            vstRec.Check_Out__Latitude__s = checkoutLat;
            vstRec.Check_Out__Longitude__s = checkoutLang;
            vstRec.Job_Status__c = 'Complete';
            vstRec.Id = vstId;
            UPDATE vstRec;
            Day_Visit_Plan__c dayPlanTObeUpdate = new Day_Visit_Plan__c();
            list<visit__c> vstList = [select id,Distance__c,Visit_Plan__r.Total_Covered_Distance__c,Visit_Plan__r.Id from visit__c where id =:vstId limit 1];
            system.debug('vstList::'+vstList);
            if(!vstList.isEmpty()){
                dayPlanTObeUpdate.Total_Covered_Distance__c = vstList[0].Visit_Plan__r.Total_Covered_Distance__c + vstList[0].Distance__c;
                dayPlanTObeUpdate.id = vstList[0].Visit_Plan__r.Id;
                update dayPlanTObeUpdate;
            }
            
            
            RETURN 'Your check-out has been done successfully.';
            
        }catch(Exception e){
            system.debug('Exception::'+e.getStackTraceString());
            RETURN 'You have completed future job.';
        }
    }
    
    @RemoteAction
    global static String createPaymentRecord(String visitWrapInstanceString){
        
        system.debug('visitWrapInstance::'+visitWrapInstanceString);
        visitDetailWrapper visitWrapInstance = new visitDetailWrapper();
        try{
            visitWrapInstance = (visitDetailWrapper)System.JSON.deserialize(visitWrapInstanceString, visitDetailWrapper.class);
            system.debug('visitWrapInstance::+'+visitWrapInstance);
            Payment__c payment = visitWrapInstance.paymentRec;
            payment.Dealer__c = visitWrapInstance.accId;
            INSERT payment;
            RETURN 'Your payment record has been Created';
        }catch(Exception e){
            system.debug('Exception::'+e.getStackTraceString());
            RETURN 'Something went wrong';
        }
        
    }
    
    @RemoteAction
    global Static String createNewCase(String visitWrapInstanceString){
        system.debug('visitWrapInstance::'+visitWrapInstanceString);
        visitDetailWrapper visitWrapInstance = new visitDetailWrapper();
        try{
            visitWrapInstance = (visitDetailWrapper)System.JSON.deserialize(visitWrapInstanceString, visitDetailWrapper.class);
            Case caseRec = visitWrapInstance.caseRec;
            caseRec.OwnerId = visitWrapInstance.userId;
            INSERT caseRec;
            String caseNumber = [SELECT id,CaseNumber FROM case WHERE id =: caseRec.Id].CaseNumber;
            RETURN caseNumber;
        }catch(Exception e){
            system.debug('Exception::'+e.getStackTraceString());
            RETURN 'SOmething went wrong.';
        }
    }
    
    @RemoteAction
    global Static String raiseReturnRequest(String visitWrapInstanceString){
        visitDetailWrapper visitWrapInstance = new visitDetailWrapper();
        try{
            visitWrapInstance = (visitDetailWrapper)System.JSON.deserialize(visitWrapInstanceString, visitDetailWrapper.class);
            Return__c returnRec = visitWrapInstance.returnRec;
            returnRec.Dealer__c = visitWrapInstance.accId;
            INSERT returnRec;
            
            if(!visitWrapInstance.orderLineItem.isEmpty()){
                for(orderitem orderItemRec : visitWrapInstance.orderLineItem){
                    orderItemRec.Order_Return__c = returnRec.Id;
                }
                
                UPDATE visitWrapInstance.orderLineItem;
            }
            String returnOrder = [SELECT id,Name FROM Return__c WHERE id =:returnRec.Id].Name;
            RETURN returnOrder;
        }catch(Exception e){
            System.debug('Exception trace::'+e.getStackTraceString());
            RETURN 'Something went wrong.';
        }
    }
    
    @RemoteAction
    global static List<Orderitem> getOrderItems(String orderNumber){
        order orderRec = [SELECT id FROM order WHERE OrderNumber =: orderNumber];
        List<Orderitem> orderItemList = new List<Orderitem>();
        orderItemList = [SELECT id,Product2.Name,ListPrice,UnitPrice,Quantity FROM Orderitem WHERE OrderId =: orderRec.Id];
        RETURN orderItemList;
    }
    
    @RemoteAction
    global Static String onboardDealer(Account acc,String planVisitDate,String userId){
        try{
            if(acc.Name == null || acc.Name == '')
                RETURN 'Dealer name is required for onboarding dealer.';
            INSERT acc;
            system.debug('planVisitDate::'+planVisitDate);
            if(planVisitDate != null && planVisitDate != ''){
                system.debug('inside visit');
                Visit__c newVisit = new visit__C();
                newVisit.Account__c = acc.id;
                newVisit.Assigned_User__c = userId;
                newVisit.Planned_visit_date__c = Date.valueOf(planVisitDate);
                INSERT newVisit;
                system.debug('newVisit::'+newVisit.Id);
            }
            
            RETURN 'Dealer onboarding successfully.';
        }catch(Exception e){
            system.debug('Exception trace::'+e.getStackTraceString());
            RETURN 'Something went wrong.';
        }
        
    }
    @RemoteAction
    global static String createNewvisit(String accId,string planDate,String userId){
        visit__c vstRec = new visit__c();
        vstRec.Account__c = accId;
        vstRec.Planned_visit_date__c = date.valueOf(planDate);
        vstRec.Assigned_User__c = userId;
        system.debug('vstRec::'+vstRec);
        INSERT vstRec;
        
        RETURN 'New visit has been created succesfully.';
    }
}