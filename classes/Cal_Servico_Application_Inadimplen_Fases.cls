public class Cal_Servico_Application_Inadimplen_Fases {
    
	/*
     * Método responsável por verificar se o status do objeto TimeLine_Fase_Inadimpl_ncia__c
     * está presente no Inadimpl_ncia_Timeline_Fases__mdt Metadata Type
     */
    public void verificaFaseMetadata(TimeLine_Fase_Inadimpl_ncia__c so){
        
        System.debug(' --- (TimeLine_Fase_Inadimpl_ncia__c) so --- ');
        System.debug(so);
        
        List<Inadimpl_ncia_Timeline_Fases__mdt> timelineFasesMeta = (List<Inadimpl_ncia_Timeline_Fases__mdt>)
		[
            SELECT Id 
            FROM Inadimpl_ncia_Timeline_Fases__mdt 
            WHERE Fase_Value__c = :so.Fase__c
        ];
        
        System.debug(' --- (List<Inadimpl_ncia_Timeline_Fases__mdt>) timelineFasesMeta --- ');
        System.debug(timelineFasesMeta);
        
        if(timelineFasesMeta.size() == 0){
            
            System.debug(' --- timelineFasesMeta size vazio. Exception --- ');
            
            throw new Cal_Cls_Infra_Exception('Fase selecionada não corresponde a um registro no Inadimplência TimeLine Fases Custom Metadata Type');
        }
    }
    
    public static void insereInadimplenciaFase(TW1_Inadimplencia__c inadimplencia){
        System.debug('--- INÍCIO DO MÉTODO insereInadimplenciaFase ---');
        
        TimeLine_Fase_Inadimpl_ncia__c inadimplenciaFase = new TimeLine_Fase_Inadimpl_ncia__c();
        inadimplenciaFase.Data_Inicio__c = Date.today();
        inadimplenciaFase.Inadimplencia__c = inadimplencia.Id;
        inadimplenciaFase.Fase__c = inadimplencia.TW1_Fase__c;
        inadimplenciaFase.Data_Fim__c = null;
        
        System.debug('inadimplenciaFase a ser inserido:');
        System.debug(inadimplenciaFase);
        
        insert inadimplenciaFase;
    }
    
    public static void atualizaInadimplenciaFase(TW1_Inadimplencia__c oldInadimplencia){
        List<TimeLine_Fase_Inadimpl_ncia__c> listaInadimplenciaFases = (List<TimeLine_Fase_Inadimpl_ncia__c>)
            [
                SELECT Id
                FROM TimeLine_Fase_Inadimpl_ncia__c
                WHERE Inadimplencia__c = :oldInadimplencia.Id
                AND Data_Fim__c = NULL
            ];
        
        if(listaInadimplenciaFases.size() > 0){
            TimeLine_Fase_Inadimpl_ncia__c inadimplenciaFase = listaInadimplenciaFases.get(0);
            
            inadimplenciaFase.Data_Fim__c = Date.today();
            
            update inadimplenciaFase;
        }
    }
    
}