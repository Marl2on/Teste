@isTest(SeeAllData=true)
private class Cal_SA_UAU_GerarDocumentos_Test {
	
    static Cal_Servico_Repo_AggregateLogIntegracao logIntegracaoRepository = new Cal_Servico_Repo_AggregateLogIntegracao();
    static Cal_SA_UAU_GerarDocumentos gerarDocumentoServiceAgent = new Cal_SA_UAU_GerarDocumentos();
    
    static private string idLogIntegracao;
    
    static private void init(string tipoNomeIntegracao)
    {
    	Log_Integracao__c log = new Log_Integracao__c();
    	log.Nome_integracao__c = tipoNomeIntegracao;
    	log.Descricao__c = 'Processo de busca de ' + tipoNomeIntegracao;
    	idLogIntegracao = logIntegracaoRepository.IncluirLogIntegracao(log).Id;
    	System.debug('Log de integração criado com sucesso com o id: ' + idLogIntegracao);
    	
    	Test.startTest();
    	Test.setMock(HttpCalloutMock.class, new Cal_Cls_MockResponseGenerator());
    	Test.stopTest();
    }
    
     static testMethod void TesteGeracaoExtratoFinanceiro() {
       	System.debug('Inicializando contexto para teste');
       	
       	init('Extrato financeiro');
                
        try
        {
        	System.debug('inciando classe de service agente');
        	string arquivoBase64 = gerarDocumentoServiceAgent.GetBase64ExtratoFinanceiro(30, '1', 1994);
            
            if(arquivoBase64 == 'stringbase64Teste')
                system.assert(true);
            else
                system.assert(false);
        }
        catch(Exception ex)
        {
        	System.debug('Erroe: ' + ex);
        	system.assert(false);
        }        
    }
    
     static testMethod void TesteGeracaoInformeRendimentos() {
       	System.debug('Inicializando contexto para teste');
       	
       	init('Informe de rendimentos');
                
        try
        {
        	System.debug('inciando classe de service agente');
        	string arquivoBase64 = gerarDocumentoServiceAgent.GetBase64InformeRendimentos(30, '1', 1994);
            
            if(arquivoBase64 == 'stringbase64Teste')
                system.assert(true);
            else
                system.assert(false);
        }
        catch(Exception ex)
        {
        	System.debug('Erroe: ' + ex);
        	system.assert(false);
        }        
    }
    
}