public class Cal_Repo_LinhaTempoInadimplencia {
	
    public static List<String> getAllFasesValues(){
        List<Inadimpl_ncia_Timeline_Fases__mdt> allFasesValues = (List<Inadimpl_ncia_Timeline_Fases__mdt>)
            [
                SELECT Indice__c, Fase_Value__c
                FROM Inadimpl_ncia_Timeline_Fases__mdt
                ORDER BY Indice__c ASC
            ];
		
        List<String> fasesValues = new List<String>();
        for(Inadimpl_ncia_Timeline_Fases__mdt faseValueMeta : allFasesValues){
            fasesValues.add(faseValueMeta.Fase_Value__c);
        }
        
        return fasesValues;
    }
    
    public static List<String> getAllFasesLabels(){
        List<Inadimpl_ncia_Timeline_Fases__mdt> allFasesLabels = (List<Inadimpl_ncia_Timeline_Fases__mdt>)
            [
                SELECT Indice__c, Fase_Label__c
                FROM Inadimpl_ncia_Timeline_Fases__mdt
                ORDER BY Indice__c ASC
            ];
		
        List<String> fasesLabels = new List<String>();
        for(Inadimpl_ncia_Timeline_Fases__mdt faseLabelMeta : allFasesLabels){
            fasesLabels.add(faseLabelMeta.Fase_Label__c);
        }
        
        return fasesLabels;
    }
    
    public static List<String> getAllFasesIcons(){
        List<Inadimpl_ncia_Timeline_Fases__mdt> allFasesIcons = (List<Inadimpl_ncia_Timeline_Fases__mdt>)
            [
                SELECT Indice__c, Fase_Icon__c
                FROM Inadimpl_ncia_Timeline_Fases__mdt
                ORDER BY Indice__c ASC
            ];
        
        List<String> fasesIcons = new List<String>();
        for(Inadimpl_ncia_Timeline_Fases__mdt faseIconMeta : allFasesIcons){
            fasesIcons.add(faseIconMeta.Fase_Icon__c);
        }
        
        return fasesIcons;
    }
    
    public static String getInadimplenciaFaseTime(TW1_Inadimplencia__c inadimplencia, String fase){
        if(fase == Cal_Repo_LinhaTempoInadimplencia.getLastFaseValue()){
            return '0 dias';
        }else{
            List<TimeLine_Fase_Inadimpl_ncia__c> listafasesInadimplencia = (List<TimeLine_Fase_Inadimpl_ncia__c>)
                [
                    SELECT Data_Inicio__c, Data_Fim__c
                    FROM TimeLine_Fase_Inadimpl_ncia__c
                    WHERE Inadimplencia__c = :inadimplencia.Id
                    AND Fase__c = :fase
                ];
            
            Integer qtdDiasFase = 0;
            for(TimeLine_Fase_Inadimpl_ncia__c faseInadimplencia : listafasesInadimplencia){
                if(faseInadimplencia.Data_Inicio__c != NULL){
                    if(faseInadimplencia.Data_Fim__c != NULL){
                        qtdDiasFase += faseInadimplencia.Data_Inicio__c.daysBetween(faseInadimplencia.Data_Fim__c);
                    }else{
                        qtdDiasFase += faseInadimplencia.Data_Inicio__c.daysBetween(Date.today());
                    }
                }else{
                    throw new Cal_Cls_Infra_Exception('Data de início da fase ' + fase + ' na inadimplência ' + inadimplencia.Id + ' não encontrado');
                }
            }
            if(qtdDiasFase != 1){
                return ('' + qtdDiasFase + ' dias');
            }else{
                return ('' + qtdDiasFase + ' dia');
            }
        }
    }
    
    public static List<String> getPassedFases(TW1_Inadimplencia__c inadimplencia){
        List<AggregateResult> listaFasesInadimplencia = (List<AggregateResult>)
            [
                SELECT Fase__c
                FROM TimeLine_Fase_Inadimpl_ncia__c
                WHERE Inadimplencia__c = :inadimplencia.Id
                GROUP BY Fase__c
            ];
        
        List<String> listaPassedFases = new List<String>();
        for(AggregateResult faseInadimplencia : listaFasesInadimplencia){
            listaPassedFases.add('' + faseInadimplencia.get('Fase__c'));
        }
        
        return listaPassedFases;
    }
    
    public static String getLastFaseValue(){
        List<Inadimpl_ncia_Timeline_Fases__mdt> listaTimelineFases = (List<Inadimpl_ncia_Timeline_Fases__mdt>)
            [
                SELECT Indice__c, Fase_Value__c
                FROM Inadimpl_ncia_Timeline_Fases__mdt
                ORDER BY Indice__c DESC
                LIMIT 1
            ];
        
        if(listaTimelineFases.size() > 0){
        	return listaTimelineFases.get(0).Fase_Value__c;
        }else{
            return '';
        }
    }
    
}