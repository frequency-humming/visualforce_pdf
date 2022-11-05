public class AccountPDFController {
    
    public String name;  
    public List<LoginHistory> history {get;set;}
    public List<LoginGeo> loginGeo {get;set;}
    public ID id {get;set;}
    public String data {get;set;}   
    public List<User> users {get;set;}
    
    public String getname(){
        return UserInfo.getName();
    }
    
    public AccountPDFController(){
        data = 'No data for selected User';
       	List<User> tempUser = new List<User>();
        id = UserInfo.getUserId();
        User user = new User();  
        user.Id = id;
        user.FirstName = UserInfo.getFirstName();
        user.LastName = UserInfo.getLastName();
        user.Email = UserInfo.getUserEmail();
        tempUser.add(user);
        this.name = UserInfo.getName();
        users = tempUser;
        sendReport();
    }
    
    public void setname(String username){
        this.name = username;
    }
    
    public void allvalues(){
        data = 'Select a User';
        history = new List<LoginHistory>();
        String newSearch = '%'+this.name+'%';
        users = [SELECT ID, FirstName, LastName, Email FROM USER WHERE NAME LIKE :newSearch];
        system.debug('user '+users);
    }
    
    public void sendReport(){
        Map<ID,LoginHistory> hisTemp = new Map<ID,LoginHistory>();
        history = new List<LoginHistory>();
        loginGeo = new List<LoginGeo>();
        for(LoginHistory var:[SELECT Id, ApiType,ApiVersion,Application,AuthMethodReference,AuthenticationServiceId,Browser,CipherSuite,ClientVersion,LoginGeoID,
                             LoginTime, LoginType,LoginUrl,Platform,SourceIp,Status,TlsProtocol FROM LoginHistory WHERE UserId = :this.id]){
            hisTemp.put(var.LoginGeoID,var);
            history.add(var);
        }
        loginGeo = [SELECT Id, City,Country, CountryIso, Latitude,LoginTime,Longitude,PostalCode,Subdivision  FROM LOGINGEO WHERE ID IN :hisTemp.KeySet()];
        if(history.isEmpty()){
            data = 'No data for selected User';
        }
    }
    
     public PageReference createPDF() {
                     
        // Create PDF
        PageReference reportPage = new PageReference('/apex/UserAccountPDF');
        Blob reportPdf;
        try {
            reportPdf = reportPage.getContentAsPDF();
        }
        catch (Exception e) {
            reportPdf = Blob.valueOf(e.getMessage());
        }
        
         ContentVersion con = new ContentVersion();
         con.Title = this.name+' ActivityReport '+System.now()+'.pdf';
         con.VersionData = reportPDF;
         con.PathOnClient = this.name+' ActivityReport '+System.now()+'.pdf';
         con.ContentLocation = 'S';
         
         insert con;
         system.debug('file : '+con);

        return reportPage; // Stay on same page, even on success
    }
}