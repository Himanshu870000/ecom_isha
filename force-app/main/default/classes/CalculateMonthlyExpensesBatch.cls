public class CalculateMonthlyExpensesBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        Date currentDate = Date.today();
        Date firstDayOfMonth = currentDate.toStartOfMonth();
        Date lastDayOfMonth = currentDate.toStartOfMonth().addMonths(1).addDays(-1);
        
        
        String query = 'SELECT Id,Monthly_Travel_Expense__c FROM ExpenseT__Expense__c ' +
            'WHERE ExpenseT__Expense_Date__c >= :firstDayOfMonth AND ExpenseT__Expense_Date__c <= :lastDayOfMonth';
        
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<ExpenseT__Expense__c> scope) {
        List<Monthly_Travel_Expense__c> monthlyExpenses = new List<Monthly_Travel_Expense__c>();
         List<ExpenseT__Expense__c> ExToBeuptaggedwithME= new List<ExpenseT__Expense__c>();
        Datetime now = system.today();
        String monthName = now.format('MMMM');
        for (ExpenseT__Expense__c record : scope) {
           
            Decimal expenseAmount = (Decimal)record.get('Amount__c');
            // Aggregate expenses as needed
            
            // Create Monthly_Expense__c records and set aggregated values
            Monthly_Travel_Expense__c monthlyExpense = new Monthly_Travel_Expense__c();
            monthlyExpense.Expense_Month__c=monthName;
            monthlyExpense.Expense_Year__c=String.valueOf(now.year());
            monthlyExpense.Total_Expense__c = expenseAmount;
            // Set other fields
            
            monthlyExpenses.add(monthlyExpense);
            record.Monthly_Travel_Expense__c=monthlyExpense.id;
            ExToBeuptaggedwithME.add(record);
            
        }
        
        insert monthlyExpenses;
        update ExToBeuptaggedwithME;
    }
    
    
    public void finish(Database.BatchableContext bc) {
        // Perform any post-processing if needed
    }
    
    
    
}