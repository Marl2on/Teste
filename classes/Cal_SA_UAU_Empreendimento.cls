public class Cal_SA_UAU_Empreendimento {
    
    Cal_Servico_Repo_AggregateLogIntegracao logIntegracaoRepository = new Cal_Servico_Repo_AggregateLogIntegracao();
    
    public EmpreendimentoDto GetEmpreendimento(string idLogProcesso, string codEmpresa, string codObra)
    {
    	Log_Integracao__c log = logIntegracaoRepository.GetLogIntegracaoById(idLogProcesso);
    	
    	/// Primeiramente validar se todos os parâmetros foram preenchidos
		System.debug('Validando id integração = '+ idLogProcesso);
    	if(idLogProcesso == '' || idLogProcesso == null)
    		throw new Cal_Cls_Infra_Exception('O código de integração é obrigatório');
    	
    	System.debug('Validando código da empresa = '+ codEmpresa);
    	if(codEmpresa == '' || codEmpresa == null)
    		throw new Cal_Cls_Infra_Exception('O código da empresa é obrigatória para realizar consulta.');
    	
		System.debug('Validando código da obra = '+ codObra);
    	if(codObra == '' || codObra == null)
    		throw new Cal_Cls_Infra_Exception('O códgio da obra é obrigatória para realizar consulta.');
    	    	
    	/// Criar Token para acesso ao serviço
    	System.debug('Gerando token para acesso ao serviço');
    	String tokenAuth = Cal_SA_UAU_Auth.GetAuthUAUToken();
    	System.debug('Token gerado: ' + tokenAuth);
    	
    	/// montar request para consultar empreendimento
    	System.debug('Montando request');
    	HttpRequest request = MontarRequest(codEmpresa,codObra,tokenAuth);
    	System.debug('Request montado: ' + request);
    	
    	/// Atualizando informação de request no Log
    	log.Request__c = request.getEndpoint();
    	
    	//if(!Test.isRunningTest())
			//logIntegracaoRepository.Atualiza(log);
    	
    	Http http = new Http();
		
		try 
		{
			if(Test.isRunningTest())
			{
				Test.setMock(HttpCalloutMock.class, new Cal_Cls_MockResponseGenerator());
    		}
			
			HTTPResponse res;   
			System.debug('Executando chamada');  
		    res =  http.send(request);
		    System.debug('Retorno de chamda: ' + res);
		    System.debug('Corpo do response: ' + res.getBody());
		   
		    log.Response__c = 'Status: '+ res.getStatusCode()+ ' Corpo: '+  res.getBody();
    		   	
		    if(res.getStatusCode() == 200)
		    {
		    	System.debug('Parse do empreendimento pelo copo' + res.getBody());
		    	EmpreendimentoDto empreendimento = (EmpreendimentoDto)JSON.deserializeStrict(res.getBody(),EmpreendimentoDto.class);
		    	System.debug('Parse realizado com sucesso para o empreendimento ' + empreendimento);
		    	return empreendimento;
		    }		    
		    else
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
			throw e;
		}    
        finally
        {
            if(!Test.isRunningTest())
                logIntegracaoRepository.Atualiza(log);
        }
    }
    
    /// Método responsável por montar o request de consulta a empreendimentos
    private HttpRequest MontarRequest(string codEmpresa, string codObra, string tokenAuth)
    {
    	HttpRequest req = new HttpRequest();
    	req.setHeader('Content-Type', 'application/json');
		//Set HTTPRequest Method
		req.setMethod('GET');
		/// SET URL Serviço
		req.setEndpoint(Cal_Cls_Infra_Utils.GetUrlApiUAU() + '/empreendimento?empresa='+ codEmpresa +'&obra='+ codObra);
		req.setHeader('Authorization', tokenAuth);
        req.setTimeout(120000);
		return req;
    }
    
    /// Contrato de empreendimento do UAU
    public class EmpreendimentoDto
    {
    	public string idobra { get; set; }
	    public string descricao { get; set; }
	    public Empresa empresa { get; set; }
	    public List<Produto> produto { get; set; }
    }
    
    public class Empresa
	{
	    public integer idempresa { get; set; }
	    public string razaosocial { get; set; }
	    public string cnpj { get; set; }
	    public string inscricaoestadual { get; set; }
	    public string inscricaomunicipal { get; set; }
	    public string endereco { get; set; }
	    public string bairro { get; set; }
	    public string cidade { get; set; }
	    public string uf { get; set; }
	    public string cep { get; set; }
	    public string numero { get; set; }
	    public string telefone { get; set; }
	    public string email { get; set; }
	}
	
	public class Produto
	{
	    public integer idproduto { get; set; }
	    public string descricao { get; set; }
	    public List<Personalizaco> personalizacoes { get; set; }
	}
	
	public class Personalizaco
	{
	    public integer idpersonalizacao { get; set; }
	    public Bloco bloco { get; set; }
	    public string identificador { get; set; }
	    public string status { get; set; }
	}
	
	public class Bloco
	{
	    public integer idbloco { get; set; }
	    public string codigo { get; set; }
	    public string descricao { get; set; }
	}
	
	public class ErroResponse
	{
		public string message {get;set;}
	}
    
    /// #region buscar saldo em aberto
    
    public class SaldosDeUmaUnidadeDto
    {
        public ID idunidade {get;set;}
        
        public decimal saldodevedor {get;set;}
        
        public decimal saldopago {get;set;}
        
        public decimal saldoematraso {get;set;}
        
        public decimal valorvenda {get;set;}
    }
    
    public SaldosDeUmaUnidadeDto GetSaldoAberto(ID idunidade, string codEmpresa, string codObra, integer numeroVenda)
    {
        string bodyRequest = '';
        string bodyResponse = '';
        string statusIntegracao = 'Processada com sucesso';
    	
    	/// Primeiramente validar se todos os parâmetros foram preenchidos
		System.debug('Validando código da empresa = '+ codEmpresa);
    	if(codEmpresa == '' || codEmpresa == null)
    		throw new Cal_Cls_Infra_Exception('O código da empresa é obrigatória para realizar consulta.');
    	
		System.debug('Validando código da obra = '+ codObra);
    	if(codObra == '' || codObra == null)
    		throw new Cal_Cls_Infra_Exception('O códgio da obra é obrigatória para realizar consulta.');
    	
        System.debug('Validando número da venda = '+ numeroVenda);
        if(numeroVenda == null || numeroVenda == 0)
            throw new Cal_Cls_Infra_Exception('O número da venda é obrigatória para realizar consulta.');
        
    	/// Criar Token para acesso ao serviço
    	System.debug('Gerando token para acesso ao serviço');
    	String tokenAuth = Cal_SA_UAU_Auth.GetAuthUAUToken();
    	System.debug('Token gerado: ' + tokenAuth);
    	
    	/// montar request para consultar empreendimento
    	System.debug('Montando request');
    	HttpRequest request = MontarRequestBuscaSaldoAberto(codEmpresa,codObra,numeroVenda,tokenAuth);
    	System.debug('Request montado: ' + request);
    	
    	/// Atualizando informação de request no Log
    	bodyRequest = request.getEndpoint();
    	    	
    	Http http = new Http();
		
		try 
		{
			if(Test.isRunningTest())
			{
				Test.setMock(HttpCalloutMock.class, new Cal_Cls_MockResponseGenerator());
    		}
			
			HTTPResponse res;   
			System.debug('Executando chamada');  
		    res =  http.send(request);
		    System.debug('Retorno de chamda: ' + res);
		    System.debug('Corpo do response: ' + res.getBody());
		   
		    bodyResponse = 'Status: '+ res.getStatusCode()+ ' Corpo: '+  res.getBody();
    		   	
		    if(res.getStatusCode() == 200)
		    {
		    	System.debug('Parse do empreendimento pelo copo' + res.getBody());
		    	SaldosDeUmaUnidadeDto saldosDeUmaUnidade = (SaldosDeUmaUnidadeDto)JSON.deserializeStrict(res.getBody(),SaldosDeUmaUnidadeDto.class);
                saldosDeUmaUnidade.idunidade = idunidade;
		    	System.debug('Parse realizado com sucesso para o empreendimento ' + saldosDeUmaUnidade);
		    	return saldosDeUmaUnidade;
		    }		    
		    else
		    {
                statusIntegracao = 'Processada com erro';
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
                IncluirLogIntegracao('Buscar saldos de uma unidade','Processo de busca saldos de uma unidade.',bodyRequest, bodyResponse, statusIntegracao);
        }
    }
    
    /// Método responsável por montar o request de consulta de saldo aberto de uma unidade
    private HttpRequest MontarRequestBuscaSaldoAberto(string codEmpresa, string codObra,integer numeroVenda, string tokenAuth)
    {
    	HttpRequest req = new HttpRequest();
    	req.setHeader('Content-Type', 'application/json');
		//Set HTTPRequest Method
		req.setMethod('GET');
		/// SET URL Serviço
		req.setEndpoint(Cal_Cls_Infra_Utils.GetUrlApiUAU() + '/venda/ConsultarSaldosVenda?empresa='+ codEmpresa +'&obra='+ codObra + '&venda='+ numeroVenda);
		req.setHeader('Authorization', tokenAuth);
        req.setTimeout(120000);
		return req;
    }
    /// #endregion buscar saldo em aberto
    
    // Criar controle de Log de integração
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