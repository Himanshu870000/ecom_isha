public class CongaHelper {
    
    @AuraEnabled  
    public static void generatesalesdeedDoc(String dealId,string fileName){
        system.debug('dealId'+dealId);
        GenerateIdentificationReportBatchLight gi = new GenerateIdentificationReportBatchLight(dealId);
        //gi.dealId =  dealId;  
        
        database.executeBatch(gi);
        
    }
    
    
    public static string generateReport(String dealId,string fileName){
        system.debug(dealId+fileName);
        string dv0 = null;
        string dv1 = null;
        string dv2 = null;
        Deal__c propRec =[select Id,Name ,Conga_Link__c from Deal__c where Id=:dealId];
        System.debug('PROPOSALDETAILS '+propRec);
        
        
        String reportLink = propRec.Conga_Link__c;
        System.debug('CongaLinkBeforHitting'+reportLink);
        String attachId = '';
        
        System.debug('reportLink =>'+reportLink);
        if(reportLink != null && string.isNotEmpty(reportLink)){
            try {
                string url = reportLink;           
                System.debug(url);
                
                //Org credentials
                CongaSession__c cs = CongaSession__c.getValues('NubikDev');
                String username = cs.Username__c;
                String password = cs.Password__c;
                String sessiondId = '';
                System.debug('sessiondId'+sessiondId);
                sessiondId = userInfo.getSessionId();
                url = url.replace('SESSION_ID', sessiondId);
                url = CongaHelper.fixBatchURL(url,fileName,dv0,dv1,dv2);
                System.debug(':: [CongaHelperTool] EndPoint :: ' + url);
                CongaHelper.HttpReqClone(new List<String>{url});
                /*System.debug(':: [CongaHelperToolLightning] attachId :: ' + attachId);

if (attachId.indexOf('</body>/') != -1) {
attachId = attachId.substring(attachId.indexOf('</body>/')+8);
}else if (attachId.indexOf('/') != -1){
attachId = attachId.substring(attachId.indexOf('/')+1);
}*/
            } catch (Exception e) {
                attachId = 'Result: There is an error when the attachament id was generated';
                System.debug(':: [CongaHelperToolLightning] attachId :: ' + attachId 
                             + '----> ' + e +e.getMessage()+' AT '+e.getLineNumber());
            }
        }
        system.debug('attachId'+attachId);
        
        
        
        return attachId;
    }
    @future(callout=true)
    public static void HttpReqClone(List<String> url){
        CongaHelper.HttpReq(url[0]);
    }
    
    
    public static String HttpReq(String url){
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(url);
        req.setTimeout(120000);
        system.debug('request is'+req);
        HttpResponse res = h.send(req);
        system.debug('body is '+ res.getBody());
        return res.getBody();
    }
    
    public static string fixBatchURL(string url, string fileName, string dv0, string dv1, string dv2){
        
        if(!url.contains('DefaultPDF'))
            url+='&DefaultPDF=1';
        if(!url.contains('APIMode'))
            url+=+'&APIMode=1';
        if(url.contains('&DS7=1'))
            url = url.replace('&DS7=1', '');
        if(!url.contains('&OFN=') && fileName!=null)
            url+='&OFN='+EncodingUtil.urlEncode(fileName, 'UTF-8');
        if(!url.contains('&DV0=') && dv0!=null && dv0!='')
            url+='&DV0='+EncodingUtil.urlEncode(dv0, 'UTF-8');
        if(!url.contains('&DV1=') && dv1!=null && dv1!='')
            url+='&DV1='+EncodingUtil.urlEncode(dv1, 'UTF-8');
        if(!url.contains('&DV2=') && dv2!=null && dv2!='')
            url+='&DV2='+EncodingUtil.urlEncode(dv2, 'UTF-8');
        System.debug('FIXEDURL'+url);
        return url;
    }
    
}