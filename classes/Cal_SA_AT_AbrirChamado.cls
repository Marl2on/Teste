public class Cal_SA_AT_AbrirChamado {
    
    public Cal_Servico_Repo_AggregateCustomSe customSettings = new Cal_Servico_Repo_AggregateCustomSe();
    
    public AbrirChamadoResponse AbrirChamado(AbrirChamadoRequest requestObj)
    {
    	try 
		{
	    	if(requestObj == null)
	    		throw new Cal_Cls_Infra_Exception('Não foi informado o request para abrir o chamado.');
	    	
	    	HttpRequest request = MontarRequest(requestObj);
	    	system.debug('Request montado: ' + request);
	    	
            Http http = new Http();
			
			HTTPResponse res; 
		    //Execute web service call here      
		    System.debug('Executando request de abertura de chamado AT');
		    res =  http.send(request);
			System.debug('Response: ' + res);
			
			if(res.getStatusCode() != 200)
				throw new Cal_Cls_Infra_Exception('ERRO: ' + res.getBody());
			
            if(res.getStatusCode() == 500)
            	throw new Cal_Cls_Infra_Exception('Ocorreu um erro interno no serviço do Assitência técnica CODE(500)');
            
            system.debug('Verificando corpo do request: '+ res.getBody());
            
            AbrirChamadoResponse resposta = (AbrirChamadoResponse)JSON.deserializeStrict(res.getBody(),AbrirChamadoResponse.class);
            system.debug('Retornando: ' + resposta);
            return resposta;
		}
		catch(Exception e) 
		{
			// Exception handling goes here....
			System.debug('Erroe: ' + e);
			throw e;
		}
    }
    
      /// Método responsável por montar o request de consulta a empreendimentos
    private HttpRequest MontarRequest(AbrirChamadoRequest requestObj )
    {
    	HttpRequest req = new HttpRequest();
    	req.setHeader('Content-Type', 'application/json');
		//Set HTTPRequest Method
		req.setMethod('POST');
		/// SET URL Serviço
		req.setEndpoint(customSettings.GetUrlApiAssitenciaTecnica() + 'cadastraOcorrenciaAt');
		//req.setHeader('Authorization', tokenAuth);
		
		string corpo = JSON.serialize(requestObj);
		System.debug('Request body: ' + corpo);
		req.setBody(corpo); 
		return req;
    }
        
    public class AbrirChamadoRequest
    {
    	public string IdChamadoOrigem {get;set;}
    	
    	public string URLCallBack {get;set;}
    	
    	public integer Id {get;set;}
    	
    	public string CodigoObra {get;set;}
    	
    	public string Bloco {get;set;}
    	
    	public string Unidade {get;set;}
    	
    	public string Cpfsolicitante {get;set;}
    	
    	public string nomeSolicitante {get;set;}
    	
    	public string emailSolicitante {get;set;}
    	
    	public string tefoneSolicitante {get;set;}
    	
    	public string detalhamentoSolicitacao {get;set;}
    	
    	public string cpfUsuarioCadastrado {get;set;}
    	
    	public string ResponsavelManutencao {get;set;}
    	
    	public datetime DataHabiteSe {get;set;}
    	
    	public datetime DataHabiteSeAverbada {get;set;}
        
        public string UsrIntegracao = 'salesforce';
		
        public string Tkn = '494518';
        
        public string NumeroCaso {get;set;}
    }
    
    public class AbrirChamadoResponse
    {
        public string IdOcorrenciaAt {get; set;}
        public string dscRetorno {get; set;}
        public string UriRetorno {get; set;}     
    }
}