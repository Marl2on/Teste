public with sharing class Cal_Servico_Repo_AggregateLogIntegracao {
    
    public Log_Integracao__c GetLogIntegracaoById(string id)
    {
    	List<Log_Integracao__c> lista =  [SELECT 
								    		name,
								    		Nome_integracao__c,
											Data_e_hora_de_inicio__c,
								    		Data_e_hora_fim_integracao__c,
								    		Status_da_integracao__c
								    		FROM Log_Integracao__c
								    		WHERE Id = :id
								    		LIMIT 1 FOR UPDATE];
								    		
		if(lista.size() > 0)
			return lista[0];
		else
			return null;	
    }
    
    public List<Log_Integracao__c> GetListLogIntegracao(string nomeIntegracao)
    {
    	return [SELECT 
	    		name,
	    		Nome_integracao__c,
				Data_e_hora_de_inicio__c,
	    		Data_e_hora_fim_integracao__c,
	    		Status_da_integracao__c
	    		FROM Log_Integracao__c
	    		WHERE Nome_integracao__c = :nomeIntegracao
	    		ORDER  BY Data_e_hora_de_inicio__c DESC];
    }
    
    public Log_Integracao__c IncluirLogIntegracao(Log_Integracao__c logIntegracao)
    {
    	logIntegracao.Status_da_integracao__c = 'Em processo';
    	logIntegracao.Data_e_hora_de_inicio__c = datetime.now();
    	logIntegracao.Data_e_hora_fim_integracao__c = null;
    	logIntegracao.Response__c = null;
    	insert logIntegracao;
    	
    	return logIntegracao;
    }
    
    public Log_Integracao__c Incluir(Log_Integracao__c logIntegracao)
    {
    	insert logIntegracao;
    	return logIntegracao;
    }
    
    public Log_Integracao__c FecharLogIntegracao(Log_Integracao__c logIntegracao, Boolean foiProcessadaComSucesso)
    {
    	if(foiProcessadaComSucesso)
    		logIntegracao.Status_da_integracao__c = 'Processada com sucesso';
    	else
    		logIntegracao.Status_da_integracao__c = 'Processada com erro';
    	
    	logIntegracao.Data_e_hora_fim_integracao__c = datetime.now();
    	    	
    	update logIntegracao;
    	return logIntegracao;
    }
    
    public List<Log_Integracao__c> GetListLogIntegracaoEmProcesso(string nomeIntegracao)
    {
    	return [SELECT 
	    		name,
	    		Nome_integracao__c,
				Data_e_hora_de_inicio__c,
	    		Data_e_hora_fim_integracao__c,
	    		Status_da_integracao__c
	    		FROM Log_Integracao__c
	    		WHERE Nome_integracao__c = :nomeIntegracao AND Status_da_integracao__c = 'Em processo'
	    		ORDER  BY Data_e_hora_de_inicio__c DESC];
    }
    
    public void Atualiza(Log_Integracao__c logAtualizar)
    {
        try
        {
            update logAtualizar;
        }
        catch(Exception e)
        {
            if(e.getMessage() == 'Record Currently Unavailable: The record you are attempting to edit, or one of its related records, is currently being modified by another user. Please try again.')
            {	
                Cal_Cls_Infra_Utils.Sleep(1000);
                Atualiza(logAtualizar);
            }
        }
    }
    
    /// Criar controle de Log de integração para geração de documentos
    public Log_Integracao__c IncluirLogIntegracao(string nomeIntegracao, string descricao, string bodyRequest, string bodyResponse, string status)
    {
         //Incluindo log de integração
        System.debug('Incluindo log de integração');
        Log_Integracao__c log = new Log_Integracao__c();
    	log.Nome_integracao__c = nomeIntegracao;
    	log.Descricao__c = descricao;
        log.Request__c = bodyRequest;
        log.Response__c = bodyResponse;
        log.Status_da_integracao__c = status;
        log.Data_e_hora_de_inicio__c = datetime.now();
    	log.Data_e_hora_fim_integracao__c =  datetime.now();
    	
        Incluir(log);
        System.debug('Log de integração incluído: ' + log);
        return log;
    }
    
    /// Buscar data do ultimo processo realizado com sucesso
    public DateTime DataUltimoProcessoComSucesso(string nomeIntegracao)
    {
        List<Log_Integracao__c> lista =  [SELECT 
								    		name,
								    		Nome_integracao__c,
											Data_e_hora_de_inicio__c,
								    		Data_e_hora_fim_integracao__c,
								    		Status_da_integracao__c
								    		FROM Log_Integracao__c
								    		WHERE Nome_integracao__c = :nomeIntegracao AND Status_da_integracao__c = 'Processada com sucesso'
								    		ORDER  BY Data_e_hora_de_inicio__c DESC];
								    		
		Log_Integracao__c log = new Log_Integracao__c();
        
        if(lista.size() > 0)
			log = lista[0];
		else
			return DateTime.now().addDays(-3);	
        
        return log.Data_e_hora_de_inicio__c;
    }
}