public class personClass {
    public String height{get;set;}
    public String weight{get;set;}
    public String complexion{get;set;}
    public String gender{get;set;}
	public String fn{get;set;}
    public String ln{get;set;}
    public Integer age{get;set;}
    public String ageGroup{get;set;}
    
    public personClass(String firstName, String lastName,Integer ageofPerson){
        //1. to return Instance of Same Class - So that i can store 1 record of Given template(Set of Attributes)
        //2. To Intialise Defalut values of Attributes
        this.fn = firstName;
        this.ln = lastName;
        this.age = ageofPerson;
        
        this.gender ='Male';
        this.ageGroup = ageofPerson > 59 ? 'Sr Citizen' : 'Normal Citizen';
        /*if(ageofPerson > 59){
            System.debug('Inside > 59');
            this.ageGroup ='Sr Citizen';
        }else if(ageofPerson < 59){
            System.debug('Inside < 59');
            this.ageGroup ='Normal Citizen';
        }*/
    }
    public personClass(String firstName, String lastName){
        //1. to return Instance of Same Class - So that i can store 1 record of Given template(Set of Attributes)
        //2. To Intialise Defalut values of Attributes
        this.fn = firstName;
        this.ln = lastName;
        //this.age = ageofPerson;
        
        this.gender ='female';
        
    }
    
}