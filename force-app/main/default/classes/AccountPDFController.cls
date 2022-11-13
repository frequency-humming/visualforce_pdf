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
    
    public void setname(String username){
        name = username;
    }
    
    public AccountPDFController(){
        data = 'Select a User';
        history = new List<LoginHistory>();
       	List<User> tempUser = new List<User>();
        id = UserInfo.getUserId();
        User user = new User();  
        user.Id = id;
        user.FirstName = UserInfo.getFirstName();
        user.LastName = UserInfo.getLastName();
        user.Email = UserInfo.getUserEmail();
        tempUser.add(user);
        name = UserInfo.getName();
        users = tempUser;
    }
    
    public void allvalues(){
        data = 'Select a User';
        history = new List<LoginHistory>();
        String newSearch = '%'+name+'%';
        users = [SELECT ID, FirstName, LastName,Name, Email,CompanyName,Profile.name, Userrole.name  FROM USER WHERE NAME LIKE :newSearch];
        system.debug('user '+users);
    }
    
    public void sendReport(){
        users = [SELECT ID, FirstName, LastName,Name, Email,CompanyName,Profile.name, Userrole.name  FROM USER WHERE ID = :this.id];
        name = users[0].Name;
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
        	
         String fileName = name+' ActivityReport '+System.now().format('yyyy-MM-dd HH:mm:ss');
         String Requestcode = FileRequestPDF.sendPDF(reportPdf,fileName);
         if(Requestcode == '200'){
             ContentVersion con = new ContentVersion();
             con.Title = fileName+'.pdf';
             con.VersionData = reportPDF;
             con.PathOnClient = fileName+'.pdf';
             con.ContentLocation = 'S';        
             insert con;
         } else {
           	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating PDF'));
    		return null;
         }
         PageReference FilePage = new PageReference('/lightning/o/ContentDocument/home');
         FilePage.setRedirect(true);

         return FilePage; // Redirects to the File tab
    }
}