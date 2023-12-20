// SaveLeadController.cls
public with sharing class SaveLeadController {
    public String leadName { get; set; }
    public String leadPhone { get; set; }
    public String leadEmail { get; set; }

    public void saveLead() {
        Lead newLead = new Lead();
        newLead.FirstName = leadName;
        newLead.Phone = leadPhone;
        newLead.Email = leadEmail;

        try {
            insert newLead;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Lead created successfully.'));
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error creating Lead: ' + e.getMessage()));
        }
    }
}