@RestResource(urlMapping='/WsPessoas/*')
global with sharing class Cal_Servico_Serv_Pessoas {
	
    static Cal_Servico_Application_Pessoa pessoaApplication = new Cal_Servico_Application_Pessoa();
    
    @HttpGet
	global static ClienteResponse GetAccountByCPF() {
        String cpf =  RestContext.request.params.get('cpf');
        return pessoaApplication.GetClienteByCPF(cpf);
    }
    
    @HttpPost
    global static void PutAtualizaPessoa(RequestCallBackAtualizacaoCadastral request)
    {
        
    }
    
    global class ClienteResponse
    {
        global string IdClienteSalesForce {get;set;}
        
        global string CodigoClienteUAU {get;set;}
        
        global string Nome {get;set;}
        
        global string CPF {get;set;}
        
        global string EmailPrincipal {get;set;}
       
        global string EmailAlternativo {get;set;}
        
        global string TelefonePrincipal {get;set;}
        
        global ClienteEnderecoDto enderecoCobranca {get;set;}
        
        global List<EmpreendimentoDto> Empreendimentos {get;set;}
    }
    
    global class ClienteEnderecoDto
    {
        global string rua {get;set;}
        
        global string complemento {get;set;}
        
        global string referencia {get;set;}
        
        global string cidade {get;set;}
        
        global string estado {get;set;}
        
        global string cep {get;set;}
        
        global string pais {get;set;}
    }
    
    global class EmpreendimentoDto
    {
        global string CodigoEmpresaUAU {get;set;}
       
        global string CodigoObraUAU {get;set;}
        
        global string Nome {get;set;}
        
        global List<BlocoDto> Blocos {get;set;}
    }
    
    global class BlocoDto
    {
        global string Nome {get;set;}
        
        global List<UnidadeDto> Unidades {get;set;}           
    }
    
    global class UnidadeDto
    {
        global string NumeroVenda {get;set;}
        
        global string NomeUnidade {get;set;}
        
        global string Unidade {get;set;}
    }
    
    /// #region Contrato de callback do UAU para atualização cadastral
 	global class RequestCallBackAtualizacaoCadastral
    {
        public integer code {get;set;}
        public string type {get;set;}
        public string message {get;set;}
    }

}