public with sharing class GetFieldSet {
    
@AuraEnabled(cacheable=true)
public Static Opportunity getFieldFromFieldSet( String oppId){

    List<Schema.FieldSetMember> getListOfFieldSet  = SobjectType.Opportunity.FieldSets.Clone_Record.getFields();
    List<String> FieldSet = new List<String>();

    try{
        for(Schema.FieldSetMember fieldsToAdd : getListOfFieldSet){
            FieldSet.add(String.valueOf(fieldsToAdd.sobjectfield));
            }

            String query ='SELECT Id,AccountId,StageName,CloseDate, ';
            query += String.join(FieldSet, ',');
            query += ' FROM Opportunity WHERE Id =: oppId';
        system.debug('query-->'+query);
            Database.query(query);
		
            Opportunity opp =  Database.query(query);
            return opp;

        }catch(Exception e){
            System.debug('Erron Line '+e.getMessage());
        }
         return null;
     }
}