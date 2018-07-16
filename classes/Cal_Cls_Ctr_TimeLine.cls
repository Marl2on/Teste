public class Cal_Cls_Ctr_TimeLine {
	public List<String> statusClasses = new List<String>();
    public List<String> statusLabels = new List<String>();
    public List<String> statusIcons = new List<String>();
    public List<String> statusTimes = new List<String>();
    
    public List<String> getStatusClasses(){
        return this.statusClasses;
    }
    
    public List<String> getStatusLabels(){
        return this.statusLabels;
    }
    
    public List<String> getStatusIcons(){
        return this.statusIcons;
    }
    
    public List<String> getStatusTimes(){
        return this.statusTimes;
    }
    
    public Cal_Cls_Ctr_TimeLine(){}
    
    public Cal_Cls_Ctr_TimeLine(ApexPages.StandardController controller){
        System.debug('--- INÍCIO DO CONSTRUTOR DA CLASSE Cal_Cls_Ctr_TimeLine ---');
    	Case currentCase = (Case) controller.getRecord();
        
        List<String> passedStatus = Cal_Repo_LinhaTempoCase.getPassedStatus(currentCase);
        
        String statusTimelineRepasse = (String) currentCase.TW1_Timeline_Repasse__c;
        String status = (String) currentCase.Status;
        
        List<String> allStatus = Cal_Repo_LinhaTempoCase.getAllStatusValues();
        for(String itemStatus : allStatus){
            if(statusTimelineRepasse == itemStatus && (! Cal_Repo_LinhaTempoCase.statusIsClosed(status) ) ){
                this.statusClasses.add('info');
            }else{
                Boolean itemIsPassedStatus = false;
                for(String itemPassedStatus : passedStatus){
                    if(itemPassedStatus == itemStatus){
                        this.statusClasses.add('success');
                        itemIsPassedStatus = true;
                        break;
                    }
                }
                if(itemIsPassedStatus == false){
                    this.statusClasses.add('default');
                }
            }
            
            this.statusTimes.add(Cal_Repo_LinhaTempoCase.getCaseStatusTime(currentCase, itemStatus));
        }
        
        this.statusLabels = Cal_Repo_LinhaTempoCase.getAllStatusLabels();
        this.statusIcons = Cal_Repo_LinhaTempoCase.getAllStatusIcons();
    }
}