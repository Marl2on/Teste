public class Cal_SA_UAU_Inadimplencia {
	
    /// Repositório de log no integração
    Cal_Servico_Repo_AggregateLogIntegracao logIntegracaoRepository = new Cal_Servico_Repo_AggregateLogIntegracao();
    
    Cal_Servico_Repo_AggregateCustomSe customSettingRepository = new Cal_Servico_Repo_AggregateCustomSe();
    
    /// Esse método chama o processo de inadimplencia, mas os dados serão retornados no Callback da chamada
    /// a URL de chamada está sendo enviada por parâmetros
    public void SolicitarVerificacaoInadimplencia()
    {
        system.debug('Executando chamada ao serviço de execução de inadimplencia.');
		string bodyRequest = '';
        string bodyResponse = '';
        string statusIntegracao = 'Em processo';
        
        /// Criar Token para acesso ao serviço
    	System.debug('Gerando token para acesso ao serviço');
    	String tokenAuth = Cal_SA_UAU_Auth.GetAuthUAUToken();
    	System.debug('Token gerado: ' + tokenAuth);
        
        /// montar request para iniciar a importação de inadimplencias
    	System.debug('Montando request');
    	HttpRequest request = MontarRequestVerificacaoInadimplencia(tokenAuth);
    	System.debug('Request montado: ' + request);
        
        /// Atualizando informação de request no Log
        bodyRequest = request.getEndpoint();        
        Http http = new Http();
        
        try 
		{
			HTTPResponse res;   
			System.debug('Executando chamada a importação de inadimplencia');  
		    res =  http.send(request);
		    System.debug('Retorno de chamda: ' + res);
		    System.debug('Corpo do response: ' + res.getBody());
		  	
            if(res.getBody().Length() < 131072)
            	bodyResponse = 'Status: '+ res.getStatusCode()+ ' Corpo: '+  res.getBody();
    	   
		    if(res.getStatusCode() != 200)
		    {
                ErroResponse erroMessage = (ErroResponse)JSON.deserializeStrict(res.getBody(),ErroResponse.class);
                System.debug('Ococrreu erro em chamar serviço: [' + 'Erro no retorno do serviço - Código:' + res.getStatusCode() + ' Message: ' + erroMessage.message +']');
                throw new Cal_Cls_Infra_Exception('Erro no retorno do serviço - Código:' + res.getStatusCode() + ' Message: ' + erroMessage.message);
            }
            else 			
            	statusIntegracao = 'Processada com sucesso';
        }
		catch(Exception e) 
		{
			// Exception handling goes here....
			System.debug('Erroe: ' + e);
            statusIntegracao = 'Processada com erro';
            throw e;
		}
        finally
        {
        	logIntegracaoRepository.IncluirLogIntegracao('Solicitação importação inadimplencia','Processo para executar a importação da inadimplencia por callback.',bodyRequest, bodyResponse, statusIntegracao);
        }    
    }
    
    private HttpRequest MontarRequestVerificacaoInadimplencia(string tokenAuth)
    {
      	HttpRequest req = new HttpRequest();
    	req.setHeader('Content-Type', 'application/json');
		//Set HTTPRequest Method
		req.setMethod('GET');
		/// SET URL Serviço
		req.setEndpoint(Cal_Cls_Infra_Utils.GetUrlApiUAU() + '/pessoa/ConsultarPessoaInadimplenteUrlCallback'
                        + '?parcelaNaoConciliada=' + customSettingRepository.GetParcelaNaoConciliadaInadimplencia()
                        + '&qtdDiasVencimento=' + customSettingRepository.GetQtdDiasVencimentoInadimplencia()
                        + '&urlCallback=' + customSettingRepository.GetUrlCallbackInadimplencia());
		req.setHeader('Authorization', tokenAuth);
        req.setTimeout(120000);                
		return req;
    }
    
    public class ErroResponse
	{
		public string code {get;set;}
        public string type {get;set;}
		public string message {get;set;}
	}
}