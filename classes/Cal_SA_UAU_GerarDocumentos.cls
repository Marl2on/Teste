public class Cal_SA_UAU_GerarDocumentos {
    
    /// Repositório de log no integração
    Cal_Servico_Repo_AggregateLogIntegracao logIntegracaoRepository = new Cal_Servico_Repo_AggregateLogIntegracao();
        
    /// Busca string base64 do arquivo PDF do extrato financeiro
    public string GetBase64ExtratoFinanceiro(integer numVenda, string obra, integer empresa)
    {   
        string bodyRequest = '';
        string bodyResponse = '';
        string statusIntegracao = 'Processada com sucesso';
        
        /// Montando objeto de request
        System.debug('Montando requestObj');
        RequestExtratoFinanceiro requestObj = montarRequestObj(numVenda, obra, empresa);
        System.debug('RequestObj montado: ' + requestObj);
               
        /// Criar Token para acesso ao serviço
        System.debug('Gerando token para acesso ao serviço');
        String tokenAuth = Cal_SA_UAU_Auth.GetAuthUAUToken();
        System.debug('Token gerado: ' + tokenAuth);
                
        /// Montando request
        HttpRequest request = MontarRequestExtratoFinanceiro(tokenAuth, requestObj);
                
        /// Atualizando informação de request no Log
        bodyRequest = request.getEndpoint();
                     
        Http http = new Http();
		
		try 
		{
            HTTPResponse res;   
			System.debug('Executando chamada');  
		    res =  http.send(request);
		    System.debug('Retorno de chamda: ' + res);
		    System.debug('Corpo do response: ' + res.getBody());
		   
		    bodyResponse = 'Status: '+ res.getStatusCode()+ ' Corpo: '+  res.getBody();
    	    	
		    DocumentoUauDto documentoUau = (DocumentoUauDto)JSON.deserializeStrict(res.getBody(),DocumentoUauDto.class);
            
		    if(res.getStatusCode() == 200)
		    	return documentoUau.message;
            
            if(res.getStatusCode() == 404)
		    	throw new Cal_Cls_Infra_Exception('Código de venda não encontrado');
            
            /// Caso não tenha dado codigo 200 ou 404, então ocorreu algum erro indevido.
            throw new Cal_Cls_Infra_Exception('Algum erro foi retornado pelo request. Detalhe: ' + bodyResponse);
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
				IncluirLogIntegracao('Importação Extrato Financeiro','Processo de busca do PDF de extrato financeiro.',bodyRequest, bodyResponse, statusIntegracao);
    	}
    }
   
    /// Montar request para execução do serviço
    private HttpRequest MontarRequestExtratoFinanceiro(string tokenAuth, RequestExtratoFinanceiro requestObj)
    {
        HttpRequest req = new HttpRequest();
    	req.setHeader('Content-Type', 'application/json');
		//Set HTTPRequest Method
		req.setMethod('POST');
		/// SET URL Serviço
		req.setEndpoint(Cal_Cls_Infra_Utils.GetUrlApiUAU() + '/Documento/RetornarPDFextrato');
		req.setTimeout(120000);
        req.setHeader('Authorization', tokenAuth);
        
        string corpo = JSON.serialize(requestObj);
		System.debug('Request ExtratoFinanceiro body: ' + corpo);
        req.setBody(corpo);
		
        return req;
    }
    
    /// Montar request obj
    private RequestExtratoFinanceiro montarRequestObj(integer numVenda, string obra, integer empresa)
    {
         RequestExtratoFinanceiro request = new RequestExtratoFinanceiro();
        
        /// Montando chave de venda
        request.chavevenda = new ChaveVendaExtratoFinanceiro();
        request.chavevenda.numvenda = numvenda;
        request.chavevenda.obra = obra;
        request.chavevenda.empresa = empresa;
        
        /// Objeto normal 
        request.tipoordenacao = 0;
        request.valorantecipado = true;
        request.dataprorrogacao = true;
        request.ocultarpersonalizacao = true;
        request.ocultarusuario = true;

		return request;        
    }
    
    private class RequestExtratoFinanceiro
    {
       public ChaveVendaExtratoFinanceiro chavevenda {get;set;}
       
       public integer tipoordenacao {get;set;}
  
       public boolean valorantecipado {get;set;}
  
       public boolean dataprorrogacao {get;set;}
  
       public boolean ocultarpersonalizacao {get;set;}
  	
       public boolean ocultarusuario {get;set;}
   }
    
    private class ChaveVendaExtratoFinanceiro
    {
       public integer numvenda {get;set;} 
       
       public string obra {get;set;}
       
       public integer empresa {get;set;}
   }
        
    /// Busca string base64 do arquivo PDF do informe de rendimentos
    public string GetBase64InformeRendimentos(integer numVenda, string obra, integer empresa)
    {
        string bodyRequest = '';
        string bodyResponse = '';
        string statusIntegracao = 'Processada com sucesso';
        
        /// Montando objeto de request
        System.debug('Montando requestObj');
        RequestInformeRendimentos requestObj = montarRequestObjInformeRendimentos(numVenda, obra, empresa);
        System.debug('RequestObj montado: ' + requestObj);
               
        /// Criar Token para acesso ao serviço
        System.debug('Gerando token para acesso ao serviço');
        String tokenAuth = Cal_SA_UAU_Auth.GetAuthUAUToken();
        System.debug('Token gerado: ' + tokenAuth);
                
        /// Montando request
        HttpRequest request = MontarRequestInformeRendimentos(tokenAuth, requestObj);
                
        /// Atualizando informação de request no Log
        bodyRequest = request.getEndpoint();
        
        Http http = new Http();
		
		try 
		{
            HTTPResponse res;   
			System.debug('Executando chamada');  
		    res =  http.send(request);
		    System.debug('Retorno de chamda: ' + res);
		    System.debug('Corpo do response: ' + res.getBody());
		   
		    bodyResponse = 'Status: '+ res.getStatusCode()+ ' Corpo: '+  res.getBody();
    		
            DocumentoUauDto documentoUau = (DocumentoUauDto)JSON.deserializeStrict(res.getBody(),DocumentoUauDto.class);
            
		    if(res.getStatusCode() == 200)
		    	return documentoUau.message;
            
            if(res.getStatusCode() == 404)
		    	throw new Cal_Cls_Infra_Exception('Código de venda não encontrado');
            
            /// Caso não tenha dado codigo 200 ou 404, então ocorreu algum erro indevido.
            throw new Cal_Cls_Infra_Exception('Algum erro foi retornado pelo request. Detalhe: ' + bodyResponse);
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
				IncluirLogIntegracao('Importação Informe de rendimentos','Processo de busca do PDF de informe de rendimentos.',bodyRequest, bodyResponse, statusIntegracao);
    	}
    }
    
    /// Montar request para execução do serviço de consulta do informe de rendimentos
    private HttpRequest MontarRequestInformeRendimentos(string tokenAuth, RequestInformeRendimentos requestObj)
    {
        HttpRequest req = new HttpRequest();
    	req.setHeader('Content-Type', 'application/json');
		//Set HTTPRequest Method
		req.setMethod('POST');
		/// SET URL Serviço
		req.setEndpoint(Cal_Cls_Infra_Utils.GetUrlApiUAU() + '/Documento/DemonstrativoIRPF');
		req.setTimeout(120000);
        req.setHeader('Authorization', tokenAuth);
        
        string corpo = JSON.serialize(requestObj);
		System.debug('Request ExtratoFinanceiro body: ' + corpo);
        req.setBody(corpo);
		
        return req;
    }
    
    /// Montar request obj do informe de rendimentos
    private RequestInformeRendimentos montarRequestObjInformeRendimentos(integer numVenda, string obra, integer empresa)
    {
         RequestInformeRendimentos request = new RequestInformeRendimentos();
        
        /// Montando chave de venda
        request.chavevenda = new ChaveVendaInformeRendimentos();
        request.chavevenda.numvenda = numvenda;
        request.chavevenda.obra = obra;
        request.chavevenda.empresa = empresa;
        
        /// Objeto normal 
        request.anobase = 2017;
        request.naomostradadosconsolidadosvenda = true;
      	return request;        
    }
    
    private class RequestInformeRendimentos
    {
       public ChaveVendaInformeRendimentos chavevenda {get;set;}
       
       public integer anobase {get;set;}
  
       public boolean naomostradadosconsolidadosvenda {get;set;}
   }
    
    private class ChaveVendaInformeRendimentos
    {
       public integer numvenda {get;set;} 
       
       public string obra {get;set;}
       
       public integer empresa {get;set;}
   }
    
    public class DocumentoUauDto
    {
        public string code {get;set;}
        
        public string type {get;set;}
        
        public string message {get;set;}
    }
    
    /// Busca lista de boletos
    public List<BoletosDto> GetListaBoletosPorUnidade(integer cliente, integer empresa, string obra, integer venda, boolean naoMostraBoletoVencido)
    {
        string bodyRequest = '';
        string bodyResponse = '';
        string statusIntegracao = 'Processada com sucesso';
                       
        /// Criar Token para acesso ao serviço
        System.debug('Gerando token para acesso ao serviço');
        String tokenAuth = Cal_SA_UAU_Auth.GetAuthUAUToken();
        System.debug('Token gerado: ' + tokenAuth);
                
        /// Montando request
        HttpRequest request = MontarRequestListaBoletos(tokenAuth, cliente, empresa, obra, venda, naoMostraBoletoVencido);
        System.debug('Request obj: ' + request);
        
        /// Atualizando informação de request no Log
        bodyRequest = request.getEndpoint();
        
        Http http = new Http();
		
		try 
		{
            HTTPResponse res;   
			System.debug('Executando chamada');  
		    res =  http.send(request);
		    System.debug('Retorno de chamda: ' + res);
		    System.debug('Corpo do response: ' + res.getBody());
		   
		    bodyResponse = 'Status: '+ res.getStatusCode()+ ' Corpo: '+  res.getBody();
    		
            if(res.getStatusCode() == 404)
		    	return new List<BoletosDto>();
            
            ListaBoletosDto listaBoletos = (ListaBoletosDto)JSON.deserializeStrict('{"boletos" : ' + res.getBody() + '}', ListaBoletosDto.class);
            
		    if(res.getStatusCode() == 200)
		    	return listaBoletos.boletos;
                        
            /// Caso não tenha dado codigo 200 ou 404, então ocorreu algum erro indevido.
            throw new Cal_Cls_Infra_Exception('Algum erro foi retornado pelo request. Detalhe: ' + bodyResponse);
		}
		catch(Exception e) 
		{
			// Exception handling goes here....
			System.debug('Erroe: ' + e);
            statusIntegracao = 'Processada com erro';
            throw e;
		}
    }
    
    /// Montar request para execução do serviço de consulta do informe de rendimentos
    private HttpRequest MontarRequestListaBoletos(string tokenAuth, integer cliente, integer empresa, string obra, integer venda, boolean naoMostraBoletoVencido)
    {
        HttpRequest req = new HttpRequest();
    	req.setHeader('Content-Type', 'application/json');
		//Set HTTPRequest Method
		req.setMethod('GET');
		/// SET URL Serviço
		req.setEndpoint(Cal_Cls_Infra_Utils.GetUrlApiUAU() + '/Boleto/ConsultarPorClienteEUnidade?cliente='+ cliente +'&empresa='+ empresa +'&obra='+ obra +'&venda='+ venda +'&naoMostraBoletoVencido='+ naoMostraBoletoVencido);
		req.setTimeout(120000);
        req.setHeader('Authorization', tokenAuth);
        return req;
    }
    
    public class ListaBoletosDto
    {
        public List<BoletosDto> boletos {get;set;}
    }
    
    public class BoletosDto
    {
        public DateTime dataCalculo {get;set;}
        
        public DateTime dataVencimento {get;set;}
        
        public DateTime dataGeracao {get;set;}
        
        public decimal valorDoc {get;set;}
        
        public integer banco {get;set;}
        
        public integer seunumero {get;set;}
        
        public string linhaDigitavel {get;set;}
        
        public string boletoEnviado {get;set;}
        
        public string instrucoes {get;set;}
    }
    
    // Montar request de boleto
    public HttpRequest MontarRequestEmitirBoleto(string tokenAuth, string banco, string seuNumero)
    {
        HttpRequest req = new HttpRequest();
    	req.setHeader('Content-Type', 'application/json');
		//Set HTTPRequest Method
		req.setMethod('GET');
		/// SET URL Serviço
		req.setEndpoint(Cal_Cls_Infra_Utils.GetUrlApiUAU() + '/Documento/RetornarPDFboleto?banco='+ banco +'&seuNumero='+ seuNumero);
		req.setTimeout(120000);
        req.setHeader('Authorization', tokenAuth);
        return req;
    }
    
    /// Busca string base64 do arquivo PDF do informe de rendimentos
    public string GetBase64EmitirBoleto(string banco, string seuNumero)
    {
        string bodyRequest = '';
        string bodyResponse = '';
        string statusIntegracao = 'Processada com sucesso';
        
        /// Criar Token para acesso ao serviço
        System.debug('Gerando token para acesso ao serviço');
        String tokenAuth = Cal_SA_UAU_Auth.GetAuthUAUToken();
        System.debug('Token gerado: ' + tokenAuth);
                            
        /// Montando request
        HttpRequest request = MontarRequestEmitirBoleto(tokenAuth, banco, seuNumero);
                
        /// Atualizando informação de request no Log
        bodyRequest = request.getEndpoint();
        
        Http http = new Http();
		
		try 
		{
            HTTPResponse res;   
			System.debug('Executando chamada');  
		    res =  http.send(request);
		    System.debug('Retorno de chamda: ' + res);
		    System.debug('Corpo do response: ' + res.getBody());
		   
		    bodyResponse = 'Status: '+ res.getStatusCode()+ ' Corpo: '+  res.getBody();
    		
            DocumentoUauDto documentoUau = (DocumentoUauDto)JSON.deserializeStrict(res.getBody(),DocumentoUauDto.class);
            
		    if(res.getStatusCode() == 200)
		    	return documentoUau.message;
            
            if(res.getStatusCode() == 404)
		    	throw new Cal_Cls_Infra_Exception('Boleto não encontrado.');
            
            /// Caso não tenha dado codigo 200 ou 404, então ocorreu algum erro indevido.
            throw new Cal_Cls_Infra_Exception('Algum erro foi retornado pelo request. Detalhe: ' + bodyResponse);
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
				IncluirLogIntegracao('Emissão de boleto','Processo de busca do PDF de boletos.',bodyRequest, bodyResponse, statusIntegracao);
    	}
    }

    
    /// Criar controle de Log de integração para geração de documentos
    private void IncluirLogIntegracao(string nomeIntegracao, string descricao, string bodyRequest, string bodyResponse, string status)
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
    	
        logIntegracaoRepository.Incluir(log);
        System.debug('Log de integração incluído: ' + log);
    }
    
    
}