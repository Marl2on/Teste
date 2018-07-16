public class Cal_Servico_Application_Cases_Status {
    
    /*
     * Método responsável por verificar se o status do objeto TW1_TimeLineStatus_Case
     * está presente no Case_TimeLine_Status Metadata Type
     */
    public void verificaStatusMetadata(TW1_TimeLineStatus_Case__c so){
        
        System.debug(' --- (TW1_TimeLineStatus_Case__c) so --- ');
        System.debug(so);
        
        List<Case_TimeLine_Status__mdt> timelineStatusMeta = (List<Case_TimeLine_Status__mdt>)
		[
            SELECT Id 
            FROM Case_TimeLine_Status__mdt 
            WHERE Status_Value__c = :so.Status__c
        ];
        
        System.debug(' --- (List<Case_TimeLine_Status__mdt>) timelineStatusMeta --- ');
        System.debug(timelineStatusMeta);
        
        if(timelineStatusMeta.size() == 0){
            
            System.debug(' --- timelineStatusMeta size vazio. Exception --- ');
            
            throw new Cal_Cls_Infra_Exception('Status selecionado não corresponde a um registro no Case TimeLine Status Custom Metadata Type');
        }
    }
    
    public static void insereCaseStatus(Case caso){
        System.debug('--- INÍCIO DO MÉTODO insereCaseStatus ---');
        
        TW1_TimeLineStatus_Case__c caseStatus = new TW1_TimeLineStatus_Case__c();
        caseStatus.Data_Inicio__c = Date.today();
        caseStatus.Case__c = caso.Id;
        caseStatus.Status__c = caso.TW1_Timeline_Repasse__c;
        caseStatus.Data_Fim__c = null;
        
        System.debug('caseStatus a ser inserido:');
        System.debug(caseStatus);
        
        insert caseStatus;
    }
    
    public static void atualizaCaseStatus(Case oldCaso){
        List<TW1_TimeLineStatus_Case__c> listaCaseStatus = (List<TW1_TimeLineStatus_Case__c>)
            [
                SELECT Id
                FROM TW1_TimeLineStatus_Case__c
                WHERE Case__c = :oldCaso.Id
                AND Data_Fim__c = NULL
            ];
        
        if(listaCaseStatus.size() > 0){
            TW1_TimeLineStatus_Case__c caseStatus = listaCaseStatus.get(0);
            
            caseStatus.Data_Fim__c = Date.today();
            
            update caseStatus;
        }
    }
}