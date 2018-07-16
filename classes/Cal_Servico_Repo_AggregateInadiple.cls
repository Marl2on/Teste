public class Cal_Servico_Repo_AggregateInadiple {
	
    public TW1_Inadimplencia__c GetInadimplenciaByID(String id)
    {
        List<TW1_Inadimplencia__c> retorno =  [
		    	SELECT id,TW1_Etapa__c,TW1_Etapa_pre_pausa__c
		    	FROM TW1_Inadimplencia__c
 		    	WHERE
		    	Id = :Id];
		    	
		if(retorno.Size() == 0)
    		return null;
    	else
    		return retorno[0];
    }
    
    public List<TW1_Inadimplencia__c> GetInadimplenciasAtivas()
    {
        List<TW1_Inadimplencia__c> retorno =  [
		    	SELECT 
            		id,
            		TW1_Etapa__c,
            		TW1_Etapa_pre_pausa__c,
            		TW1_Codigo_Obra_UAU__c,
					TW1_Codigo_Empreendimento_UAU__c,
					TW1_Numero_Venda__c,
					TW1_Codigo_Empresa_UAU__c 
		    	FROM TW1_Inadimplencia__c
 		    	WHERE
		    	TW1_Fase__c != 'Concluída' ];
		
        return retorno;
    }
 
    public TW1_Inadimplencia__c GetInadimplenciaByAccountIdEProductIdAtivas(string accountId, string productId)
    {
        List<TW1_Inadimplencia__c> retorno =  [
		    	SELECT 
            		id,
            		TW1_Etapa__c, 
            		TW1_Etapa_pre_pausa__c,
                    TW1_Valor_Reajustado__c,
                    TW1_Valor_Principal__c,
                    TW1_Numero_Parcelas__c,
                    TW1_Tempo_Inadimplencia__c,
                    TW1_Maior_Data_Vencimento__c
		    	FROM 
            		TW1_Inadimplencia__c
 		    	WHERE
		    		TW1_Cliente_Principal__c = :accountId
        			AND TW1_Unidade__c = :productId
        			AND TW1_Fase__c != 'Concluída' ];
		    	
		if(retorno.Size() == 0)
    		return null;
    	else
    		return retorno[0];
    }   
    
    public List<TW1_Parcela_Inadimplencia__c> GetParcelasDeUmaInadimplencia(string inadimplenciaId)
    {
        List<TW1_Parcela_Inadimplencia__c> retorno = [SELECT id FROM TW1_Parcela_Inadimplencia__c WHERE Id = :inadimplenciaId];
        return retorno;
    }
    
    public void Modify(TW1_Inadimplencia__c inadimplencia)
    {
        update inadimplencia;
    }
    
    public List<TW1_Acoes__c> GetAcoesEmAbertoByInadimplenicaEFase(Id idInadimplencia, string faseConsulta)
    {
        List<TW1_Acoes__c> retorno = [SELECT 
                                      	id, 
                                      	TW1_Motivo_Cancelamento__c,
                                      	TW1_Fase_Inadimplencia__c,
                                      	TW1_Inadimplencia__c
                                      FROM 
                                      	TW1_Acoes__c 
                                      WHERE TW1_Inadimplencia__c = :idInadimplencia 
                                     	AND TW1_Status__c != 'TW1_Cancelada' 
                                      	AND TW1_Status__c != 'Concluída'];
        return retorno;
    }    
}