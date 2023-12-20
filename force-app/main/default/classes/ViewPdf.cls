public class ViewPdf {
    public Blob content{get; set;}
    public Attachment att {
        get {
            if (att == null) {
                att = [SELECT Id,Body, ContentType, Name FROM Attachment WHERE parentID  = '0Q0N0000000Y8moKAC'][0];
                content = att.Body;
            }
            return att;
        }
        private set;
    }
    public String pdf {
        get {
            return EncodingUtil.Base64Encode(att.body);
        }
        //List<Document> d = [Select id,body, bodyLength, ContentType, Url from Document where Name ='ConsentForm'];
    }
    
    public static PageReference generatePdf(){
        string strOrgId  = UserInfo.getOrganizationId();
        Attachment att = [SELECT Id,Body, ContentType, Name FROM Attachment WHERE parentID  = '0Q0N0000000Y8moKAC'][0];
        List<Document> d = [Select id,body, bodyLength, ContentType, Url from Document where Name ='ConsentForm'];
        string content = '/servlet/servlet.ImageServer?id=' + att.Id + '&oid='+ strOrgId ;                                              
        PageReference pg = new PageReference(content);
        
        pg.setRedirect(true);
        
        return pg;
        
    }     
    
    public static Blob createInterestPDF(String dealId){
        PageReference PDf =  Page.InterestDetailsComp;//Replace attachmentPDf with the page you have rendered as PDF
        PDf.getParameters().put('Id',dealId);
        PDf.setRedirect(true);
        
        Blob b ;
        b = PDf.getContent();
        
        Attachment attach = new Attachment();
        attach.Body = b;
        attach.Name = 'Interest Schedule.pdf';
        attach.IsPrivate = false;
        attach.ParentId = dealId;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        return b;
    }
    
    
    
}