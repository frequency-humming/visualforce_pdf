public class AccountPDFController {
    
    public String name;  
    public ID id {get;set;}
    
    public List<User> users {get;set;}
    
    public String getname(){
        return UserInfo.getName();
    }
    
    public AccountPDFController(){
       	List<User> tempUser = new List<User>();
        User user = new User();
        user.Id = UserInfo.getUserId();
        user.FirstName = UserInfo.getFirstName();
        user.LastName = UserInfo.getLastName();
        user.Email = UserInfo.getUserEmail();
        tempUser.add(user);
        users = tempUser;
    }
    
    public void setname(String username){
        system.debug('in set'+username);
        this.name = username;
        system.debug(name);
    }
    
    public void allvalues(){
        String newSearch = '%'+this.name+'%';
        users = [SELECT ID, FirstName, LastName, Email FROM USER WHERE NAME LIKE :newSearch];
        system.debug('user '+users);
    }
    
    public void sendReport(){
        system.debug('in the report '+this.id);
        
        List<LoginHistory> history = [SELECT ApiType,ApiVersion,Application,AuthMethodReference,AuthenticationServiceId,Browser,CipherSuite,ClientVersion,
                                LoginGeoId,LoginTime,LoginType,LoginUrl,Platform,SourceIp,Status,TlsProtocol FROM LoginHistory WHERE UserId = :this.id];
        system.debug('history '+history);
    }
    

}