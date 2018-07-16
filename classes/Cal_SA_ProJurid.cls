public class Cal_SA_ProJurid {

    Cal_Servico_Repo_AggregateLogIntegracao logIntegracaoRepository = new Cal_Servico_Repo_AggregateLogIntegracao();
  
    public ResponseConsultaProcessos GetProcessos(string cpfcnpj)
    {
        if(cpfcnpj == '' || cpfcnpj == null)
		   	throw new Cal_Cls_Infra_Exception('O CPF ou o CNPJ é obrigatório para consultar processos no ProJurid.');
        
    	string bodyRequest = '';
        string bodyResponse = '';
        string statusIntegracao = 'Processada com sucesso';
                                   
        /// Montando request
        HttpRequest request = MontarRequestConsultaProcesso(cpfcnpj);
                
        /// Atualizando informação de request no Log
        bodyRequest = request.getEndpoint();
        
        Http http = new Http();
		
		try 
		{
            HTTPResponse res;   
			System.debug('Executando chamada ProJurid');  
		    res =  http.send(request);
		    System.debug('Retorno de chamda: ' + res);
		    System.debug('Corpo do response: ' + res.getBody());
		   
		    bodyResponse = 'Status: '+ res.getStatusCode()+ ' Corpo: '+  res.getBody();
    		
            
		    if(res.getStatusCode() == 200)
            {
                ResponseConsultaProcessos processoDto = (ResponseConsultaProcessos)JSON.deserializeStrict(res.getBody(),ResponseConsultaProcessos.class);
            	return processoDto;
            }
            
            if(res.getStatusCode() == 404)
		    	throw new Cal_Cls_Infra_Exception('Erro 404 em consulta ProJurid.');
            
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
          	logIntegracaoRepository.IncluirLogIntegracao('Consulta processo','Processo de consulta de processos pelo ProJurid.',bodyRequest, bodyResponse, statusIntegracao);
    	}
    }
    
    /// Montar request para consultar processos
    private HttpRequest MontarRequestConsultaProcesso(string cpfcnpj)
    {
    	HttpRequest req = new HttpRequest();
    	req.setHeader('Content-Type', 'application/json');
		//Set HTTPRequest Method
		req.setMethod('GET');
		/// SET URL Serviço
		req.setEndpoint('http://www.projuridnet.com.br/calcada_ws/api/processo?cpf-cnpj='+cpfcnpj);
		string token = '{00ABD129-A77F-48B9-BAAA-BECC81E2DCC0}';
        req.setHeader('Authorization', 'Basic ' + token);
		return req;
    }
    
    /// Definindo objeto de response
	public class Processos {
		public String CpfCnpj;
		public String NumProcesso;
		public String DataEntrada;
		public String DataProcesso;
		public String DataModificacao;
		public String NomeParteInteresse;
		public String PosicaoParteInteresse;
		public String NomeParteContraria;
		public String PosicaoParteContraria;
		public String StatusDossie;
		public String Empresa;
		public String Bloco;
		public String Unidade;
		public String Empreendimento;
		public String NomeAcao;
		public String CausasDePedir;
		public String FaseProcesso;
		public String Escritorio;
	}

	public class ResponseConsultaProcessos {
		public String Status;
		public List<Processos> Processos;
	}
	
	public static ResponseConsultaProcessos parse(String json) {
		return (ResponseConsultaProcessos) System.JSON.deserialize(json, ResponseConsultaProcessos.class);
	}

}