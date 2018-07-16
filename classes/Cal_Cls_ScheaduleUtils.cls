public class Cal_Cls_ScheaduleUtils {
	public static void scheadule(String paSchedulableClassName,Integer paScheaduleTimerInterval){
    
      DateTime vaCurrentDateAndTime = DateTime.now();
      DateTime nextRunTime = DateTime.now().addSeconds(10);
       
      if(paScheaduleTimerInterval > 0)
      	nextRunTime = vaCurrentDateAndTime.addMinutes(paScheaduleTimerInterval);
          
      String vaCronString = ''   + 
      nextRunTime.second() + ' '   + nextRunTime.minute() + ' ' + 
      nextRunTime.hour()   + ' '   + nextRunTime.day()    + ' ' + 
      nextRunTime.month()  + ' ? ' + nextRunTime.year(); 
       
      Schedulable paSchedulableClass = (Schedulable) type.forName(paSchedulableClassName).newInstance();
      System.schedule(paSchedulableClassName + '-' + vaCurrentDateAndTime.format(), vaCronString, paSchedulableClass);
    }  
    
    public static void abortScheadule(SchedulableContext paSchedulableContext) {
        Id jobId = paSchedulableContext.getTriggerId();
        System.abortJob(jobId);       
    }
}