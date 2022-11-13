public class RetrieveUserPDFController {
    
    public String reportsName {get;set;}
    public String fileName {get;set;}
    public List<String> allReports {get;set;}
    public List<User> users {get;set;}
    public ID id {get;set;}
    
    public RetrieveUserPDFController(){
        users = new List<User>();
        allReports = new List<String>();
        
    }
    
    public void retrieveUsers(){
        String newSearch = '%'+reportsName+'%';
        users = [SELECT ID, FirstName, LastName,Name, Email,CompanyName,Profile.name, Userrole.name  FROM USER WHERE NAME LIKE :newSearch];
        system.debug('user '+users);
    }
    
    public void retrieveallReports(){
        users = [SELECT ID, FirstName, LastName,Name, Email,CompanyName,Profile.name, Userrole.name  FROM USER WHERE ID = :this.id];
        reportsName = users[0].Name.deleteWhitespace();
        allReports = FileRequestPDF.getListPDF(reportsName);
        system.debug('reports size : '+allReports.size());
    }
    public void retrieveReport(){
        system.debug('name from vp '+fileName);
        
    }

}