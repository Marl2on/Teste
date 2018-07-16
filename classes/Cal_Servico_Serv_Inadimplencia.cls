@RestResource(urlMapping='/WsInadimplencia/*')
global with sharing class Cal_Servico_Serv_Inadimplencia {
	
    static Cal_Servico_Application_Inadimplencia inadimplenciaApplication = new Cal_Servico_Application_Inadimplencia();
    
    /// Método de CallBack para implantar as inadimplências
    @HttpPost
	global static RequestInformaInadimplencia PostInformaInadimplencia(List<RequestInadimplencia> request) {
        
        system.debug('Serviço acionado com o request: ' + request);
        inadimplenciaApplication.ProcessarCallBackInadimplencia(request);
              
        RequestInformaInadimplencia response = new RequestInformaInadimplencia();
        response.IsSucesso = true;
        response.MenssagemErro = '';
        return response;
    }
    
    global class Vendas {
		global Integer empresa;
		global String obra;
		global Integer venda;
		global double totalprincipalreaj;
		global double totalprincipal;
		global Integer numparcelas;
		global Integer tempoinadimplencia;
		global DateTime maiordatavencimento;
		global List<Parcelas> parcelas;
	}

   global class RequestInadimplencia {
		public String CodigoPessoa;
		public String Status;
		public List<Vendas> Vendas;
	}

	global class Parcelas {
		global Integer numeroparcela;
		global Integer numeroparcelageral;
		global Boolean parcelarecebida;
		global String tipoparcela;
		global double valorreaj;
		global double valor;
		global DateTime datavencimento;
		global DateTime datarecebimento;
		global DateTime dataprevistadeposito;
		global Boolean deposito;
		global Boolean conciliado;
	}
    
    global class RequestInformaInadimplencia
    {
        global boolean IsSucesso {get;set;}
        
        global string MenssagemErro {get;set;}
    }
}