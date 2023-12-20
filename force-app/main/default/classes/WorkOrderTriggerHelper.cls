public without sharing class WorkOrderTriggerHelper {
    public static void afterInsert(List<WorkOrder> workOrderList){
        List<WorkOrderLineItem> woliList = new List<WorkOrderLineItem>();
        
        if(!workOrderList.isEmpty()){
            for(WorkOrder workOrder : workOrderList){
                
                WorkOrderLineItem woli = new WorkOrderLineItem();
                woli.Priority = 'Medium';
                woli.Status = 'New';
                woli.Subject = 'Sales Work Order';
                woli.WorkOrderId = workOrder.Id;
                woliList.add(woli);
                
                WorkOrderLineItem woli1 = new WorkOrderLineItem();
                woli1.Priority = 'Medium';
                woli1.Status = 'New';
                woli1.Subject = 'Logistics & Dispatching';
                woli1.WorkOrderId = workOrder.Id;
                woliList.add(woli1);
                
                WorkOrderLineItem woli2 = new WorkOrderLineItem();
                woli1.Priority = 'Medium';
                woli1.Status = 'New';
                woli1.Subject = 'Installation Work Order';
                woli1.WorkOrderId = workOrder.Id;
                woliList.add(woli2);
                
                WorkOrderLineItem woli3 = new WorkOrderLineItem();
                woli1.Priority = 'Medium';
                woli1.Status = 'New';
                woli1.Subject = 'Maintenance Work Order';
                woli1.WorkOrderId = workOrder.Id;
                woliList.add(woli3);
                
                WorkOrderLineItem woli4 = new WorkOrderLineItem();
                woli1.Priority = 'Medium';
                woli1.Status = 'New';
                woli1.Subject = 'Quality Assurance and closure';
                woli1.WorkOrderId = workOrder.Id;
                woliList.add(woli4);
            }
            system.debug('woliList::'+woliList);
            if(!woliList.isEmpty()){
                insert woliList;
            }
        }
    }
}