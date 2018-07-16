public class Cal_Repo_LinhaTempoCase {
    
	public static List<String> getAllStatusValues(){
        List<Case_TimeLine_Status__mdt> allStatusValues = (List<Case_TimeLine_Status__mdt>)
            [
                SELECT Indice__c, Status_Value__c
                FROM Case_TimeLine_Status__mdt
                ORDER BY Indice__c ASC
            ];
		
        List<String> statusValues = new List<String>();
        for(Case_TimeLine_Status__mdt statusValueMeta : allStatusValues){
            statusValues.add(statusValueMeta.Status_Value__c);
        }
        
        return statusValues;
    }
    
    public static List<String> getAllStatusLabels(){
        List<Case_TimeLine_Status__mdt> allStatusLabels = (List<Case_TimeLine_Status__mdt>)
            [
                SELECT Indice__c, Status_Label__c
                FROM Case_TimeLine_Status__mdt
                ORDER BY Indice__c ASC
            ];
		
        List<String> statusLabels = new List<String>();
        for(Case_TimeLine_Status__mdt statusLabelMeta : allStatusLabels){
            statusLabels.add(statusLabelMeta.Status_Label__c);
        }
        
        return statusLabels;
    }
    
    public static List<String> getAllStatusIcons(){
        List<Case_TimeLine_Status__mdt> allStatusIcons = (List<Case_TimeLine_Status__mdt>)
            [
                SELECT Indice__c, Status_Icon__c
                FROM Case_TimeLine_Status__mdt
                ORDER BY Indice__c ASC
            ];
        
        List<String> statusIcons = new List<String>();
        for(Case_TimeLine_Status__mdt statusIconMeta : allStatusIcons){
            statusIcons.add(statusIconMeta.Status_Icon__c);
        }
        
        return statusIcons;
    }
    
    public static String getCaseStatusTime(Case caso, String status){
        List<TW1_TimeLineStatus_Case__c> listaStatusCases = (List<TW1_TimeLineStatus_Case__c>)
            [
                SELECT Data_Inicio__c, Data_Fim__c
                FROM TW1_TimeLineStatus_Case__c
                WHERE Case__c = :caso.Id
                AND Status__c = :status
            ];
        
        Integer qtdDiasStatus = 0;
        for(TW1_TimeLineStatus_Case__c statusCase : listaStatusCases){
            if(statusCase.Data_Inicio__c != NULL){
                if(statusCase.Data_Fim__c != NULL){
                    qtdDiasStatus += statusCase.Data_Inicio__c.daysBetween(statusCase.Data_Fim__c);
                }else{
                    qtdDiasStatus += statusCase.Data_Inicio__c.daysBetween(Date.today());
                }
            }else{
                throw new Cal_Cls_Infra_Exception('Data de início do status ' + status + ' no caso ' + case.Id + ' não encontrado');
            }
        }
        if(qtdDiasStatus != 1){
            return ('' + qtdDiasStatus + ' dias');
        }else{
        	return ('' + qtdDiasStatus + ' dia');
        }
        
    }
    
    public static List<String> getPassedStatus(Case caso){
        List<AggregateResult> listaStatusCases = (List<AggregateResult>)
            [
                SELECT Status__c
                FROM TW1_TimeLineStatus_Case__c
                WHERE Case__c = :caso.Id
                GROUP BY Status__c
            ];
        
        List<String> listaPassedStatus = new List<String>();
        for(AggregateResult statusCase : listaStatusCases){
            listaPassedStatus.add('' + statusCase.get('Status__c'));
        }
        
        return listaPassedStatus;
    }
    
    public static String getLastStatusValue(){
        List<Case_TimeLine_Status__mdt> listaTimelineStatus = (List<Case_TimeLine_Status__mdt>)
            [
                SELECT Status_Value__c
                FROM Case_TimeLine_Status__mdt
                ORDER BY Indice__c DESC
                LIMIT 1
            ];
        
        if(listaTimelineStatus.size() > 0){
        	return listaTimelineStatus.get(0).Status_Value__c;
        }else{
            return '';
        }
    }
    
    public static Boolean statusIsClosed(String status){
        List<CaseStatus> caseStatus = (List<CaseStatus>)
            [
                SELECT Id
                FROM CaseStatus
                WHERE (
                    ApiName = :status
                	OR MasterLabel = :status
                )
                AND IsClosed = true
            ];
        
        return ( caseStatus.size() > 0 );
    }
}