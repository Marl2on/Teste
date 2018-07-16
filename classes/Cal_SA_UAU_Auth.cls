/// Classe responsável por realizar a autenticação do usuário de integração com os serviços da GlobalTech
public class Cal_SA_UAU_Auth {
    
    static String AuthToken = '';
        
    /// Método responsável por gerar token de acesso aos serviços do UAU
    public static String GetAuthUAUToken()
    {
    	System.debug('Chamada ao método GetAuthUAUToken()');
    	System.debug('AuthToken: ' + AuthToken);
    	
    	if(AuthToken == '')
    		AuthToken = DoAuthToken();
    	
    	System.debug('Retorno AuthToken: ' + AuthToken);	
    	return AuthToken;
    }
    
    /// Método para executar autenticação nos serviços do UAU
    private static string DoAuthToken()
    {
    	System.debug('Iniciando chamada ao serviço externo');
    	
    	HttpRequest req = new HttpRequest();
		req.setHeader('Content-Type', 'application/json');
		//Set HTTPRequest Method
		req.setMethod('POST');
        req.setTimeout(120000);
		
		/// SET URL Serviço
		Cal_Servico_Repo_AggregateCustomSe customSettings = new Cal_Servico_Repo_AggregateCustomSe();
		
		req.setEndpoint(Cal_Cls_Infra_Utils.GetUrlApiUAU() + '/Autenticador/Autenticar');
		
		/// Montando request de chamada ao método de autenticação
		AuthTokenRequest request = new AuthTokenRequest();
		request.login = customSettings.GetLoginAuthUAU();
		request.senha = customSettings.GetSenhaAuthUAU();
		request.codempresa = 364;
		request.urlws = '';
		request.baseproducao =  customSettings.GetUsaBaseProducaoAuthUAU();
		
		string corpo = JSON.serialize(request);
			
		System.debug('Request body: ' + corpo);
		
		req.setBody(corpo); 
		Http http = new Http();
		
		try 
		{
			HTTPResponse res;   
			
		    //Execute web service call here      
		    res =  http.send(req);
		 
            system.debug('Body response Auth: ' + res.getBody());
			//Helpful debug messages
			AuthTokenResponse response = (AuthTokenResponse)JSON.deserializeStrict(res.getBody(),AuthTokenResponse.class);
			System.debug('Response: ' + response);
			
			if(response.code == 200)
				return response.message;
			else
				throw new Cal_Cls_Infra_Exception('ERRO DoAuthToken: ' + response.message);
		}
		catch(Exception e) 
		{
			// Exception handling goes here....
			System.debug('Erroe: ' + e);
			throw e;
		}
    }
    
    private class AuthTokenRequest
    {
    	public string login {get;set;}
    	public string senha {get;set;}
    	public integer codempresa {get;set;}
    	public string urlws {get;set;}
    	public boolean baseproducao {get;set;}
    }
    
    private class AuthTokenResponse
    {
    	public integer code {get;set;}
    	public string type {get;set;}
    	public string message {get;set;}
    }
    
}