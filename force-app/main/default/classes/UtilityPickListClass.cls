public without sharing class UtilityPickListClass {
	public static List<String> getPicklistValues(String ObjectApi_name, String Field_name){
        List<String> lstPickvals = new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : pick_list_values){
            lstPickvals.add(String.ValueOf(a.getLabel()).trim());
        }
        System.debug('lstPickvals Values Method 1 === :'+lstPickvals);
        return lstPickvals;
    }

    public static List<String> getPicklistValuesWithNone(String ObjectApi_name, String Field_name){
        List<String> pickList = new List<String>{ '--None--' };
            pickList.addAll(getPicklistValues(objectApi_name, field_name));
        System.debug('pickList Values Method 2 == :'+pickList);
        return pickList;
    }
}