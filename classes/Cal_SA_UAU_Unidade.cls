public class Cal_SA_UAU_Unidade {

    /// Repositório de log no integração
    Cal_Servico_Repo_AggregateLogIntegracao logIntegracaoRepository = new Cal_Servico_Repo_AggregateLogIntegracao();
   
    public List<UnidadesQuitadasDto> GetListaUnidadesQuitadas()
    {
        string bodyRequest = '';
        string bodyResponse = '';
        string statusIntegracao = 'Processada com sucesso';
        
        /// Criar Token para acesso ao serviço
    	System.debug('Gerando token para acesso ao serviço');
    	String tokenAuth = Cal_SA_UAU_Auth.GetAuthUAUToken();
    	System.debug('Token gerado: ' + tokenAuth);
        
        /// montar request para consultar empreendimento
    	System.debug('Montando request');
    	HttpRequest request = MontarRequestConsultaUnidadesQuitadas(tokenAuth);
    	System.debug('Request montado: ' + request);

  		/// Atualizando informação de request no Log
        bodyRequest = request.getEndpoint();        
        
        Http http = new Http();
		
		try 
		{
			HTTPResponse res;   
			System.debug('Executando chamada a consulta de unidades quitadas');  
		    res =  http.send(request);
		    System.debug('Retorno de chamda: ' + res);
		    System.debug('Corpo do response: ' + res.getBody());
		  		     	
            bodyResponse = 'Status: '+ res.getStatusCode()+ ' Corpo: '+  res.getBody();
    	   
		    if(res.getStatusCode() == 200)
		    {
                string corpoBuild = '{"unidades": '+ res.getBody() + '}';
		    	System.debug('Parse da lista de unidades pelo copo' + corpoBuild);
                ListaUnidadesQuitadasDto listaUnidadesQuitadas = (ListaUnidadesQuitadasDto)JSON.deserializeStrict(corpoBuild ,ListaUnidadesQuitadasDto.class);
		    	System.debug('Parse realizado com sucesso ' + listaUnidadesQuitadas);
		    	return listaUnidadesQuitadas.unidades;
		    }	
            
            if(res.getStatusCode() == 404)
		    	return new List<UnidadesQuitadasDto>();
		                
		    ErroResponse erroMessage = (ErroResponse)JSON.deserializeStrict(res.getBody(),ErroResponse.class);
		    System.debug('Ococrreu erro em chamar serviço: [' + 'Erro no retorno do serviço - Código:' + res.getStatusCode() + ' Message: ' + erroMessage.message +']');
		    throw new Cal_Cls_Infra_Exception('Erro no retorno do serviço - Código:' + res.getStatusCode() + ' Message: ' + erroMessage.message);
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
          	if(!Test.isRunningTest())
				logIntegracaoRepository.IncluirLogIntegracao('Consultar unidades quitadas','Processo consultar unidades quitadas no UAU.',bodyRequest, bodyResponse, statusIntegracao);
    	}
    }
    
    public void InformaRecebimentoUnidadesQuitadas(List<UnidadesQuitadasDto> unidadesProcessadas)
    {
        string bodyRequest = '';
        string bodyResponse = '';
        string statusIntegracao = 'Processada com sucesso';
        
        /// Criar Token para acesso ao serviço
    	System.debug('Gerando token para acesso ao serviço');
    	String tokenAuth = Cal_SA_UAU_Auth.GetAuthUAUToken();
    	System.debug('Token gerado: ' + tokenAuth);
        
        ListaUnidadesQuitadasDto listaRequest = new ListaUnidadesQuitadasDto();
        listaRequest.unidades = unidadesProcessadas;
        system.debug('Lista de request: ' + listaRequest);
        
        /// montar request para consultar empreendimento
    	System.debug('Montando request');
    	HttpRequest request = MontarRequestInformaRecebimentoUnidadesQuitadas(tokenAuth, listaRequest);
    	System.debug('Request montado: ' + request);

  		/// Atualizando informação de request no Log
        bodyRequest = request.getEndpoint();        
        
        Http http = new Http();
		
		try 
		{
			HTTPResponse res;   
			System.debug('Executando chamada a consulta de unidades quitadas');  
		    res =  http.send(request);
		    System.debug('Retorno de chamda: ' + res);
		    System.debug('Corpo do response: ' + res.getBody());
		  		     	
            bodyResponse = 'Status: '+ res.getStatusCode()+ ' Corpo: '+  res.getBody();
    	   
		    if(res.getStatusCode() != 200)
		    {
		    	ErroResponse erroMessage = (ErroResponse)JSON.deserializeStrict(res.getBody(),ErroResponse.class);
		    	System.debug('Ococrreu erro em chamar serviço: [' + 'Erro no retorno do serviço - Código:' + res.getStatusCode() + ' Message: ' + erroMessage.message +']');
		    	throw new Cal_Cls_Infra_Exception('Erro no retorno do serviço - Código:' + res.getStatusCode() + ' Message: ' + erroMessage.message);
		    }	
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
          	if(!Test.isRunningTest())
				logIntegracaoRepository.IncluirLogIntegracao('Atualiza recebimento unidades quitadas','Processo para atualizar unidades quitadas recebidas pelo CRM.',bodyRequest, bodyResponse, statusIntegracao);
    	}
    }
    
    /// Método responsável por montar o request de consulta as unidades quitadas
    private HttpRequest MontarRequestConsultaUnidadesQuitadas(string tokenAuth)
    {
    	HttpRequest req = new HttpRequest();
    	req.setHeader('Content-Type', 'application/json');
		//Set HTTPRequest Method
		req.setMethod('GET');
		/// SET URL Serviço
		req.setEndpoint(Cal_Cls_Infra_Utils.GetUrlApiUAU() + '/unidade/RetornarUnidadesQuitadas');
		req.setHeader('Authorization', tokenAuth);
        req.setTimeout(120000);
		return req;
    }
    
     /// Método responsável por montar o request de consulta as unidades quitadas
    private HttpRequest MontarRequestInformaRecebimentoUnidadesQuitadas(string tokenAuth, ListaUnidadesQuitadasDto requestObj)
    {
    	HttpRequest req = new HttpRequest();
    	req.setHeader('Content-Type', 'application/json');
		//Set HTTPRequest Method
		req.setMethod('POST');
		/// SET URL Serviço
		req.setEndpoint(Cal_Cls_Infra_Utils.GetUrlApiUAU() + '/unidade/ConfirmarRecebimentoUnidadesQuitadas');
		req.setHeader('Authorization', tokenAuth);
        req.setTimeout(120000);
        
        string corpo = JSON.serialize(requestObj);
		System.debug('Request MontarRequestInformaRecebimentoUnidadesQuitadas body: ' + corpo);
        req.setBody(corpo);
        
		return req;
    }
    
    public class ListaUnidadesQuitadasDto
    {
        public List<UnidadesQuitadasDto> unidades {get;set;}
    }
    
    public class UnidadesQuitadasDto
    {
        public string idempresa {get;set;}
        public string idproduto {get;set;}
        public string idpersonalizacao {get;set;}
        public string idobra {get;set;}
    }
    
    public class ErroResponse
	{
		public string message {get;set;}
	}
}