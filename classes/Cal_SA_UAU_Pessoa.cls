public class Cal_SA_UAU_Pessoa {

    /// Repositório de log no integração
    Cal_Servico_Repo_AggregateLogIntegracao logIntegracaoRepository = new Cal_Servico_Repo_AggregateLogIntegracao();
   
    Cal_Servico_Repo_AggregateCustomSe customSettingsRepository = new Cal_Servico_Repo_AggregateCustomSe();
    
    public void AtualizarDadosCadastraisUAU(PessoaRequest requestObj)
    {
        string bodyRequest = '';
        string bodyResponse = '';
        string statusIntegracao = 'Processada com sucesso';
       
		/// Criar Token para acesso ao serviço
        System.debug('Iniciando chamada ao método de manter pessoas no UAU');
        System.debug('Gerando token para acesso ao serviço');
        String tokenAuth = Cal_SA_UAU_Auth.GetAuthUAUToken();
        System.debug('Token gerado: ' + tokenAuth);
        
        /// Montando request
        requestObj.urlcallback = customSettingsRepository.GetCallBackAtualizacaoCadastralUAU();
        HttpRequest request = MontarRequestAtualizarPessoa(tokenAuth, requestObj);
                
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
    	  	
            if(res.getStatusCode() != 200)
            {    
                //System.debug('Parse do menssagem recebida pelo copo' + res.getBody());
                //ResponseManterListPessoasDto responseManterListPessoas = (ResponseManterListPessoasDto)JSON.deserializeStrict(res.getBody(),ResponseManterListPessoasDto.class);
                //System.debug('Parse realizado com sucesso para a menssagem ' + responseManterListPessoas);
		  
                if(res.getStatusCode() == 400)
		    		throw new Cal_Cls_Infra_Exception('Alguns ou todos itens da lista estão inválidos.');
            
            	throw new Cal_Cls_Infra_Exception('Algum erro foi retornado pelo request. Detalhe: ' + bodyResponse);
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
          	IncluirLogIntegracao('Atualizar lista de pessoa','Processo para atualizar pessoas no UAU.',bodyRequest, bodyResponse, statusIntegracao);
    	}
    }
    
    
  	/// Montar request para execução do serviço
    private HttpRequest MontarRequestAtualizarPessoa(string tokenAuth, PessoaRequest requestObj)
    {
        HttpRequest req = new HttpRequest();
    	req.setHeader('Content-Type', 'application/json');
		//Set HTTPRequest Method
		req.setMethod('POST');
		/// SET URL Serviço
		req.setEndpoint(Cal_Cls_Infra_Utils.GetUrlApiUAU() + '/pessoa/ManterListPessoas');
		req.setTimeout(120000);
        req.setHeader('Authorization', tokenAuth);
        
        string corpo = JSON.serialize(requestObj);
		System.debug('Request ExtratoFinanceiro body: ' + corpo);
        req.setBody(corpo);
		
        return req;
    }
    
    public class PessoaRequest
    {
		public String urlcallback; //string
		public cls_pessoas[] pessoas;
    }
    
    public class cls_pessoas {
		public String descricao;	//string
		public Integer fisjur;	//0
		public cls_cpfcnpj cpfcnpj;
		public String dtnasc;	//2017-10-05T14:46:06.956Z
		public String nomefantasia;	//string
		public String inscmunicipal;	//string
		public String inscestadual;	//string
		public String email;	//string
		public String homepage;	//string
		public String endereco;	//string
		public String setor;	//string
		public String uf;	//string
		public String cidade;	//string
		public String cep;	//string
		public String referencia;	//string
		public String complemento;	//string
		public List<cls_telefones> telefones;
		public cls_pessoajuridica pessoajuridica;
		public cls_pessoafisica pessoafisica;
		public cls_enderecocobranca enderecocobranca;
		public cls_pessoavenda pessoavenda;
		public String habilitariscosacado;	//string
	}
	
    public class cls_cpfcnpj {
		public String cnpj;	//string
		public String cpf;	//string
	}
	
    public class cls_telefones {
		public String ddd;	//string
		public String fone;	//string
		public String ramal;	//string
		public String tipotelefone;	//string
	}
	
    public class cls_pessoajuridica {
		public String contato1;	//string
		public String contato2;	//string
	}
	
    public class cls_pessoafisica {
		public String numerorg;	//string
		public String dataemissaorg;	//2017-10-05T14:46:06.956Z
		public String orgaoexprg;	//string
		public String ufrg;	//string
		public Integer profissao;	//0
		public Integer codigoempresa;	//0
		public String nomeempresa;	//string
		public String cargo;	//string
		public String dataadmissao;	//2017-10-05T14:46:06.956Z
		public String sexo;	//string
		public String estadocivil;	//string
		public String regimecasamento;	//string
		public String naturalidade;	//string
		public String ufnaturalidade;	//string
		public String nacionalidade;	//string
		public String nomemae;	//string
		public String nomepai;	//string
		public String uniaoestavel;	//string
	}
	
    public class cls_enderecocobranca {
		public String endereco;	//string
		public String bairro;	//string
		public String cidade;	//string
		public String uf;	//string
		public String cep;	//string
		public String numero;	//string
		public String complemento;	//string
		public String referencia;	//string
		public Integer codigoempresa;	//0
		public String nomeempresa;	//string
	}
    
	public class cls_pessoavenda {
		public String recebeboletocorreio;	//string
		public String recebeboletoemail;	//string
	}
    
    public class ResponseManterListPessoasDto
    {
        public integer code {get;set;}
        public string type {get;set;}
        public string message {get;set;}
        public string modelstate {get;set;}
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