public class Cal_SA_UAU_Atendimentos {
    
    /// Repositório de log no integração
    Cal_Servico_Repo_AggregateLogIntegracao logIntegracaoRepository = new Cal_Servico_Repo_AggregateLogIntegracao();
    
    public RetornoAtendimentos GetListaAtendimentos(AtendimentosRequest requestObj)
    {
        RetornoAtendimentos retorno = new RetornoAtendimentos();
        
        string bodyRequest = '';
        string bodyResponse = '';
        string statusIntegracao = 'Processada com sucesso';
        
        /// Criar Token para acesso ao serviço
        System.debug('Iniciando chamada ao método de buscar atendimentos do UAU');
        System.debug('Gerando token para acesso ao serviço');
        String tokenAuth = Cal_SA_UAU_Auth.GetAuthUAUToken();
        System.debug('Token gerado: ' + tokenAuth);
        
        HttpRequest request = MontarRequest(tokenAuth, requestObj);
        
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
            
            if(res.getStatusCode() == 200)
            {
                string corpoBuild =  res.getBody();
                System.debug('Parse da lista de unidades pelo copo' + corpoBuild);
                List<AtendimentosResponse> listaAtendimentos = (List<AtendimentosResponse>)JSON.deserializeStrict(corpoBuild ,List<AtendimentosResponse>.class);
                System.debug('Parse realizado com sucesso ' + listaAtendimentos);
                retorno.ListaAtendimentos = listaAtendimentos;     
            }   
            else if(res.getStatusCode() == 404)
            {	
                retorno.ListaAtendimentos = new List<AtendimentosResponse>();                
            }
            else if(res.getStatusCode() != 404 && res.getStatusCode() != 200 )
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
            string tempBodyResponse = bodyResponse;
            bodyResponse = 'Erro em consultar venda no serviço do UAU: Response['+ tempBodyResponse +']';
            statusIntegracao = 'Processada com erro';
            throw e;
        }
        finally
        {
            retorno.logIntegracao = logIntegracaoRepository.IncluirLogIntegracao('Consultar atendimentos','Processo consulta de todos os atendimentos por período no UAU.',bodyRequest, bodyResponse, statusIntegracao);
        }
        
        return retorno;
    }
    
    private HttpRequest MontarRequest(string tokenAuth, AtendimentosRequest requestObj)
    {
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type', 'application/json');
        //Set HTTPRequest Method
        req.setMethod('POST');
        /// SET URL Serviço
        req.setEndpoint(Cal_Cls_Infra_Utils.GetUrlApiUAU() + '/Atendimento/ConsultarAtendimentos');
        req.setTimeout(120000);
        req.setHeader('Authorization', tokenAuth);
        
        string corpo = JSON.serialize(requestObj);
        System.debug('Request ExtratoFinanceiro body: ' + corpo);
        req.setBody(corpo);
        
        return req;        
    }
    
    public class RetornoAtendimentos
    {
        public Log_Integracao__c logIntegracao {get;set;}
        public List<AtendimentosResponse> ListaAtendimentos {get;set;}
    }
    
    public class AtendimentosRequest
    {
        public List<string> listacategoria {get;set;}
        
        public datetime periodoincio {get;set;}
        
        public datetime periodofim {get;set;}
    }
    
    public class AtendimentosResponse
    {
        public string CodigoCliente {get; set;}
        
        public string Venda {get; set;}
        
        public string Empresa {get; set;}
        
        public string Obra {get; set;}
        
        public datetime DataCadastro {get;set;}
        
        public string TipoAtendimento {get; set;}
        
        public string Mensagem {get; set;}
        
        public string Email {get;set;}
        
        public string UsuarioResponsavel {get;set;}
    }
    
    public class ErroResponse
    {
        public string code {get;set;}
        public string type {get;set;}
        public string message {get;set;}
    }
}