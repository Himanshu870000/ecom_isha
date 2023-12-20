public class WorkorderTriggerHandler {
    
    public static void createWorkOrderLineItems(List<Workorder> newWorkOrder){
        List<String> listofWOLineItems = New List<String>{'08qN0000000Cety','08qN0000000Cf56','08qN0000000Cf5G','08qN0000000Cf5L','08qN0000000Cf5B'};
            List<WorkType> workTypeList = [Select Id,Name From WorkType ];
        List<workorderlineitem> woLineItemsTobeInsert = New List<workorderlineitem>();
        
        for(Workorder wo : newWorkOrder){
            for(WorkType workTypeRec : workTypeList){
                workorderlineitem woLine = new workorderlineitem();
                woLine.WorkTypeId = workTypeRec.Id;
                woLine.Subject = workTypeRec.Name;
                woLine.WorkOrderId = wo.Id;
                woLineItemsTobeInsert.add(woLine);
            }
        }
        if(!woLineItemsTobeInsert.isEmpty()){
            insert woLineItemsTobeInsert;
        }
    }
}