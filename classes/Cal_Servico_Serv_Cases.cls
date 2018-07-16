@RestResource(urlMapping='/WsCases/*')
global with sharing class Cal_Servico_Serv_Cases {

   	global static Cal_Servico_Application_Cases applicationCases = new Cal_Servico_Application_Cases();
    
  	@HttpGet
	global static List<Case> getListaCasosPorAccountId() {
    	
    	String AccountId =  RestContext.request.params.get('AccountId');
        system.debug('AccountId recebido por request ' + AccountId);
        
    	return applicationCases.GetCasosPorAccountId(AccountId);
    }
    
    @HttpPost
    global static List<Case> postCriarCaso(CriarCasoRequest request)
    {
       	applicationCases.CriarCasoPorServico(request);
        return applicationCases.GetCasosPorAccountId(request.IdClienteSalesforce);
    }
    
    @HttpPut
    global static AtualizaCasoResult postAtualizaStatusAssitenciaTecnica(AtualizaCasoRequest request)
    {
        //AtualizaCasoResult result = new AtualizaCasoResult();
        //result.isfailed = false;
        //result.DescricaoErro = '';
        //result.Request = request;
    	//return result;
        return applicationCases.AtualizarStatusServicoAssitenciaTecnica(request);
    }
    
    ///Contratos usados nos serviços Rest na base WsCases
    
    /// Contrato para atualização de casos
    global class AtualizaCasoRequest {
    	
    	/// ID do caso
    	global String id {get;set;}
    
    	/// Status do sistema assistência técnica
    	global String StatusSistemaAssistenciaTecnica {get;set;}
	}
	
	global class AtualizaCasoResult {
    	
    	/// ID do caso
    	global Boolean isfailed {get;set;}
    	    
    	/// Status do sistema assistência técnica
    	global String DescricaoErro {get;set;}
    	
    	/// Objeto recebido no request
    	global AtualizaCasoRequest Request {get;set;}
	}
    
     /// Contrato para inclusão de um novo caso
    global class CriarCasoRequest {
    	
    	/// ID do cliente no Salesforce AccountID
    	global String IdClienteSalesforce {get;set;}
    
        /// Código de empresa UAU
    	global String CodigoEmpresaUau {get;set;}
        
        /// Código da obra no UAU
    	global String CodigoObraUau {get;set;}
        
        /// Número de venda da unidade no UAU
    	global String NumeroVendaUau {get;set;}
        
    	/// Número de venda da unidade no UAU
    	global String DescricaoChamadoUAU {get;set;}
        
        /// Número de venda da unidade no UAU
    	global Boolean IsCasoFechado {get;set;}
        
        /// Tipo de caso a ser aberto
    	global String TipoDoCaso {get;set;}
	}
}