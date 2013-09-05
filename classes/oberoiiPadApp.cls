public class oberoiiPadApp {

public List<Attachment> allImages {get;set;}
public Attachment myImage {get;set;}
public Date d{get;set;}
public String d1{get;set;}
public String fname{get;set;}
public String lname{get;set;}

   public oberoiiPadApp()
   {
     d=System.Today();
     d1=d.Day()+'/'+d.Month()+'/'+d.Year();
     String temp = 'a0S3000000DyT4S';
        Property__c tempCase = [Select (Select Id, IsDeleted, ParentId, Name, IsPrivate, ContentType, OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Description From Attachments where contenttype like '%image%') From Property__c where Id = :temp LIMIT 1];        
        allImages = new List<Attachment>();
        myImage = new Attachment();
        
        
         for(Attachment a : tempCase.Attachments) {
            allImages.add(a);
            String checkName = a.Name;
            if(checkName.indexOf('main') != -1){                    
                myImage = a;
          }
   
   }
   
   }

   
    public PageReference doAction2() {
        return new pageReference('/apex/PropertyFinalpage');
    }

    public String selectdProp{set;get;}public String selectdProp1{set;get;}
    public SFDC_Community__c selectdPropValues{set;get;}
    public List<Available_Model__c> amc {set;get;}
    public List<String> unitList{get;set;}
    public String selectedUnit{get;set;}
    public static List<SelectOption> options1 {set;get;}
    
    
    public Lead rec{set;get;}
    public List<Lead> rec1{set;get;}
    public string phone{set;get;}
    
    public String acctName;
    public String trader;

    public String getacctName() { return acctName; }
    public void setacctName(String s) {  this.acctname = s; }
    
    public String gettrader() {  return trader; }
    public void settrader(String s) {  this.trader = s; }

    
     public pageReference searchWithPh(){
     String phone2;
     rec = new Lead();rec1 = new List<lead>();
     try
     {
        integer ll = phone.length();
        
        phone2 = '('+phone.substring(0,3)+') '+phone.substring(3,6)+'-'+phone.substring(6,ll);       
        rec1 = [select id,lastName,firstname,phone,email from Lead where Phone=:phone2 limit 1]; 
        if(rec1.size() > 0){
            rec = rec1[0];
        }
        if(rec1.size() < 1){
            rec.phone = phone2;
        }
              
        
        
        }
        
        catch(Exception e)
        {
          /**String mymessage=e.getMessage();
           if(rec==null)
           {
           //rec.phone = phone2;
          //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Record Found with this Number' ));
          return new pageReference('/apex/PropertyDetails?pid='+phone);
          }
        else
        {
        return new pageReference('/apex/PropertyDetails');
        
        }*/
          
        }
        
        return new pageReference('/apex/PropertyDetails');
    }
    public pagereference doAction1()
    {
        return null;
    } 
    public List<SelectOption> getAccts(){
        List<SelectOption> options = new List<SelectOption>();
        
        List<SFDC_Community__c> sc = [select id,name from SFDC_Community__c];
         options.add(new selectOption('', '- None -')); 
        for(SFDC_Community__c f : sc){
            options.add(new SelectOption(f.name, f.name));
        }       
        return options;
    }
    
    public List<selectOption> getTids() {
        List<selectOption> optionList = new List<selectOption>(); 
      
        if(acctName!=null){
        selectdPropValues = [select id, Build_out_by__c from SFDC_Community__c where name=:acctName limit 1]; 
        optionList.add(new selectOption('', '- None -')); 
        for (Available_Model__c r : [select id,Name,Model__r.name from Available_Model__c where SFDC_Community__c=:selectdPropValues.id and Model__r.name!='']) { 
            optionList.add(new selectOption(r.Model__r.name, r.Model__r.name));  
        }
        return optionList;}else{return null;}
    }
     
    public PageReference doAction(){
      return new PageReference('/apex/PropertyLogin');
    }
    
    
   public PageReference sendEmail()
   
   {
          rec.Company='Testing';
          upsert rec;
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {rec.email};
            mail.setToAddresses(toAddresses);
            mail.setReplyTo('support@oberoii.demo');
            mail.setSenderDisplayName('Oberoii Property');
            mail.setSubject('More information about Property name');
            mail.setPlainTextBody('Property Information');
            mail.setHtmlBody('Property Information');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            return null;
   
   } 
}