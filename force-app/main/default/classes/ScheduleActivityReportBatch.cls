global class ScheduleActivityReportBatch  implements Schedulable{

    global void execute(SchedulableContext sc) {
      ActivityReportBatch batch = new ActivityReportBatch(); 
      Database.executeBatch(batch);
   }
    
}