global class ActivityReportBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        String query = 'SELECT ID,Title,createdDate FROM ContentDocument';
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<SObject> files) {
        
        // process each batch of records default size is 200
        List<ContentDocument> fileActivity = files;
        List<SObject>  removeFile = new List<SObject>();
        system.debug('size '+fileActivity.size());
        for(ContentDocument file:fileActivity){
            if(file.Title.contains('ActivityReport') && file.CreatedDate < date.today()){
                system.debug('selected file : '+file);
                removeFile.add(file);
            }
        }
        try {
            delete removeFile;       
        } catch(Exception e) {
            System.debug(e);
        }        
    }   
     
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }

}