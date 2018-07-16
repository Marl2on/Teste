public class Cal_SA_UAU_Venda 
{    
    /// Repositório de log no integração
    Cal_Servico_Repo_AggregateLogIntegracao logIntegracaoRepository = new Cal_Servico_Repo_AggregateLogIntegracao();
    
    public RetornoConsultaVenda GetVendas(VendasRequest requestObj)
    {
        system.debug('Executando chamada ao serviço de consulta de vendas UAU.');
		string bodyRequest = '';
        string bodyResponse = '';
        string statusIntegracao = 'Em processo';
        RetornoConsultaVenda retorno = new RetornoConsultaVenda();
        
        try 
		{
            /// Criar Token para acesso ao serviço
            System.debug('Gerando token para acesso ao serviço');
            String tokenAuth = Cal_SA_UAU_Auth.GetAuthUAUToken();
            System.debug('Token gerado: ' + tokenAuth);
            
            /// montar request para consultar empreendimento
            System.debug('Montando request');
            HttpRequest request = MontarRequestConsultaVendas(tokenAuth, requestObj);
            System.debug('Request montado: ' + request);
            
            /// Atualizando informação de request no Log
            bodyRequest = request.getEndpoint() + ' JSON Body: ' + request.getBody();        
            Http http = new Http();
              
			HTTPResponse res;   
			System.debug('Executando chamada a consulta de unidades quitadas');  
		    res =  http.send(request);
		    System.debug('Retorno de chamda: ' + res);
		    System.debug('Corpo do response: ' + res.getBody());
		  	
            if(res.getBody().Length() < 131072)
            	bodyResponse = 'Status: '+ res.getStatusCode()+ ' Corpo: '+  res.getBody();
    	   
		    if(res.getStatusCode() == 200)
		    {
                string corpoBuild =  res.getBody();
		    	System.debug('Parse da lista de unidades pelo copo' + corpoBuild);
                ResponseVenda listaDeVendas = (ResponseVenda)JSON.deserializeStrict(corpoBuild ,ResponseVenda.class);
		    	System.debug('Parse realizado com sucesso ' + listaDeVendas);
		    	retorno.ResponseVenda = listaDeVendas;     
		    }            
            else if(res.getStatusCode() == 404)
            {	
                retorno.ResponseVenda =  new ResponseVenda();
                retorno.ResponseVenda.Vendas = new List<Vendas>();
                retorno.ResponseVenda.Pessoas = new List<Pessoas>();
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
		}
        finally
        {
        	retorno.logIntegracao = logIntegracaoRepository.IncluirLogIntegracao('Consultar vendas','Processo consultar vendas por período no UAU.',bodyRequest, bodyResponse, statusIntegracao);
        }    
        
        return retorno;
    }
    
    private HttpRequest MontarRequestConsultaVendas(string tokenAuth, VendasRequest requestObj)
    {
      	HttpRequest req = new HttpRequest();
    	req.setHeader('Content-Type', 'application/json');
		//Set HTTPRequest Method
		req.setMethod('POST');
		/// SET URL Serviço
		req.setEndpoint(Cal_Cls_Infra_Utils.GetUrlApiUAU() + '/venda');
		req.setHeader('Authorization', tokenAuth);
        req.setTimeout(120000);
        
        string corpo = JSON.serialize(requestObj);
		System.debug('Request MontarRequestConsultaVendas body: ' + corpo);
        req.setBody(corpo);
        
		return req;
    }
    
    public class RetornoConsultaVenda
    {
        public Log_Integracao__c logIntegracao {get;set;}
        public ResponseVenda ResponseVenda {get;set;}
    }
    
    /// #region Request de chamada a consulta de vendas
    public class ResponseVenda {
		public List<Vendas> Vendas;
		public List<Pessoas> Pessoas;
	}
    
    public class VendasRequest{
        public list<DadosVendaRequest> listavendas{get;set;}
        public String datafinal{get;set;}
        public String datainicial{get;set;}       
    }
    
    public class DadosVendaRequest
    {
        public String obra{get;set;}
        public Integer empresa{get;set;}
        public Integer numvenda{get;set;}
    }
	
    /// #endregion Request de chamada a consulta de vendas 
	public class Itens {
		public integer CodigoProduto;
		public integer CodigoPersonalizacao;
		public Double Preco;
		public string Quantidade;
		public Double Contrato;
		public Double ValorComissaoDireta;
		public Double PercentualComissao;
		public integer NumeroItem;
        public boolean Securitizada;
	}

	public class Comentarios {
		public String Usuario;
		public String Data;
	}

	public class PessoaVenda {
		public String recebeBoletoCorreio;
		public String recebeBoletoEmail;
	}

	public class Recebimentos {
		public String Tipo;
		public Double BancoDeposito;
		public String AgenciaDeposito;
		public String ContaDeposito;
		public String DataDeposito;
		public Boolean Depositado;
		public Boolean Conciliado;
		public String DataConciliacao;
		public String ChequeNumero;
		public Double ChequeBanco;
		public String ChequeAgencia;
		public String ChequeConta;
		public String Data;
		public String DataCadastro;
		public String UsuarioResponsavel;
		public String Descricao;
		public Double ValorPercentualDoPrincipal;
		public Double ValorPercentualDeCorrecao;
		public Double ValorPercentualDeCorrecaoEmbutido;
		public Double ValorPercentualDaCorrecaoPorAtraso;
		public Double ValorPercentualDoJuros;
		public Double ValorPercentualDoJurosEmbutido;
		public Double ValorPercentualDoJurosAtraso;
		public Double ValorPercentualDaMultaPorAtraso;
		public Double ValorPercentualDoAcrescimo;
		public Double ValorPercentualDoDesconto;
		public Double ValorPercentualDoDescontoPorAntecipacao;
		public Double ValorPercentualDoDescontoDeCustas;
		public Double ValorPercentualDoDescontoDeImposto;
		public Double ValorPercentualDoDescontoCondicional;
		public Double ValorPercentualDaTaxaBoleto;
	}

	public class PessoaJuridica {
		public String contato1;
		public String contato2;
	}

	public class EnderecoCobranca {
		public String endereco;
        public String bairro;
        public String cidade;
        public String uf;
        public String cep;
        public String numero;
        public String referencia;
        public String complemento;
	}

	public class PessoaFisica {
		public String nomeEmpresa;
        public String cargo;
        public String sexo;
        public String estadoCivil;
        public String naturalidade;
        public String UFNaturalidade;
        public String nacionalidade;
        public String nomeMae;
        public String nomePai;
        public String uniaoEstavel;
        public String numeroRG;
        public String dataEmissaoRG;
        public String orgaoExpRG;
        public Integer profissao;
        public String ufRG;
        public Integer codigoEmpresa;
        public String dataAdmissao;
        public String regimeCasamento;
	}

	public class Pessoas {
		public String descricao;
		public integer fisJur;
		public CpfCnpj cpfCnpj;
		public String dtNasc;
		public String nomeFantasia;
		public String inscMunicipal;
		public String inscEstadual;
		public String email;
		public String homePage;
		public String endereco;
		public String setor;
		public String uf;
		public String cidade;
		public String cep;
		public String referencia;
		public List<Telefones> telefones;
		public PessoaJuridica pessoaJuridica;
		public PessoaFisica pessoaFisica;
		public EnderecoCobranca enderecoCobranca;
		public String habilitaRiscoSacado;
		public String complemento;
		public PessoaVenda pessoaVenda;
	}

	public class Parcelas {
		public integer NumeroParcela;
		public integer NumeroParcelaGeral;
		public Boolean ParcelaRecebida;
		public integer OrigemParcela;
		public integer TotalParcelasDoGrupo;
		public integer TotalParcelasDoGrupoInformado;
		public String TipoParcela;
		public String DataRecebimento;
		public String DataCalculoReajuste;
		public Double ValorPrincipal;
		public Double ValorResiduo;
		public String DataVencimento;
		public String DataPrimeiraParcelaGrupo;
		public String Amortizacao;
		public String BeginEndPrice;
		public String FrequenciaVencimento;
		public String DataInicioPrimeiroJuros;
		public Double TaxaPrimeiroJuros;
		public Double TaxaSegundoJuros;
		public String DataInicioReajuste;
		public String IndiceReajuste;
        public String DataProrrogacao;
		public Double GrupoPlanoIndexador;
		public String CobrarJurosPrimeiroPeriodo;
		public Double DiasCarenciaMultaJurosAtraso;
		public Double DiasCarenciaCorrecaoAtraso;
		public String CobrarJurosProRata;
		public String CobrarJurosProRataPrimeiroMes;
		public String CapPrincipal;
		public String CapAcrescimo;
		public String CapCorrecao;
		public String CapCorrecaoAtraso;
		public String CapDesconto;
		public String CapDescontoAntecipacao;
		public String CapDescontoCondicional;
		public String CapDescontoCusta;
		public String CapJuros;
		public String CapJurosAtraso;
		public String CapMulta;
		public String CapRepasse;
		public String CapTaxaBoleto;
		public Double TipoDaCusta;
		public String OrigemCusta;
		public String CobrarMultaCusta;
		public String CobrarJurosAtrasoCusta;
		public String CobrarTaxaAdministracaoCusta;
		public String CobrarImpostoCusta;
		public String CobrarCorrecaoCusta;
		public String RepassarValorLocadorCusta;
		public Double PadraoCobranca;
		public String TipoSeguro;
		public List<DescontosDeCusta> DescontosDeCusta;
		public List<DescontosDeCusta> DescontosDeImposto;
		public Double ValorDescontoCondicional;
		public Double ValorDescontoCondicionalConfirmado;
		public Double ValorPrincipalConfirmado;
		public Double ValorAcrescimo;
		public Double ValorAcrescimoConfirmado;
		public Double ValorDesconto;
		public Double ValorDescontoConfirmado;
		public Double ValorCorrecaoAtraso;
		public Double ValorCorrecaoAtrasoConfirmado;
		public Double ValorCorrecaoEmbutida;
		public Double ValorJurosAtraso;
		public Double ValorJurosAtrasoConfirmado;
		public Double ValorJurosContrato;
		public Double ValorJurosContratoConfirmado;
		public Double ValorJurosContratoEmbutido;
		public Double ValorJurosContratoEmbutidoConfirmado;
		public Double ValorMulta;
		public Double ValorMultaConfirmado;
		public Double ValorCorrecao;
		public Double ValorCorrecaoConfirmado;
		public Double ValorDescontoAdiantamento;
		public Double ValorDescontoAdiantamentoConfirmado;
		public List<Recebimentos> Recebimentos;
		public List<DescontosDeCusta> Prorrogacoes;
		public String UsuarioRecebeu;
		public String UsuarioCedeuDesconto;
		public String DataInicioPeriodoAluguel;
        public string datainiciosegundojuros;
        public string observacaocusta;
	}

	public class Comissoes {
		public Double NumeroComissao;
		public Double CodigoPessoa;
		public String CpfCnpjDaPessoa;
		public Double ValorDaComissao;
		public String DataPagamento;
		public Double PorcentagemVenda;
		public String StatusComissao;
		public String GerarProcessoDePagamento;
		public String TipoDePagamento;
		public String DataLiberacaoDaComissao;
		public String UsuarioRealizouPagamento;
		public Double ValorAcrescimo;
		public Double ValorDesconto;
		public String TipoDeLancamento;
		public Double NumeroRecibo;
	}

	public class CpfCnpj {
		public String cnpj;
        public String cpf;
	}

	public class Clientes {
		public integer CodigoCliente;
		public String CpfCnpjDoCliente;
		public Boolean EmitirBoleto;
		public Double PercentualDoTitular;
		public String TipoDeCliente;
		public Boolean Principal;
	}

	public class DescontosDeCusta {
       
	}
    
    public class PlanosIndexadores {
		public Double Grupo;
		public String IndiceReajuste;
		public String Data;
	}

	public class Vendas {
		public integer empresa;
		public String obra;
		public integer Numero;
		public integer CodigoVendedor;
		public String CpfCnpjVendedor;
		public Double PercentualJurosAtraso;
		public Double Multa;
		public Double Desconto;
		public String Usuario;
		public String DataDaVenda;
		public String StatusVenda;
		public Double Acrescimo;
		public String ContinuarCobrandoJurosContratualAoAtrasarParcela;
		public Boolean PossuiReajusteAnual;
		public Boolean GerarResiduo;
		public Double CarenciaAtraso;
		public Double QuantidadeMesesRetroagirCorrecao;
		public String DataBaseResiduo;
		public Boolean PossuiCorrecaoPorAtraso;
		public Boolean PossuiCorrecaoProRata;
		public String DataCancelamento;
		public String CobrarTaxaDeBoleto;
		public String DataDeCadastro;
		public String TipoDeVenda;
		public Double DiaDoRepasse;
		public Double ValorProvisaoCurto;
		public Double ValorProvisaoLongo;
		public String CapProvisaoCurto;
		public String CapProvisaoLongo;
		public Double DiasCarenciaCorrecaoPorAtraso;
		public Boolean AnteciparCorrecao;
		public String CobrarJurosPosChave;
		public String DataInicioContrato;
		public String DataFimContrato;
		public String TipoDeFianca;
		public Double ValorDaFianca;
		public Double ValorSeguroIncendio;
		public String CobrarMultaFracionada;
		public Boolean AnteciparJurosLinear;
		public Double ValorDescontoImposto;
		public String PeriodoDeReajuste;
		public Boolean ZerarCorrecaoNegativa;
		public String CobrarJurosPorAtrasoMensal;
		public Boolean CorrecaoCrescente;
		public Boolean EnviarSpedPisCofins;
		public String Atividade;
		public Double ValorProvisaoCurtoBaixa;
		public Double ValorProvisaoLongoBaixa;
		public Double ValorProvisaoCurtoCessao;
		public Double ValorProvisaoLongoCessao;
		public String CapProvisaoCurtoBaixa;
		public String CapProvisaoLongoBaixa;
		public String CobrarCorrecaoMaisProrataMesRecebimento;
		public String CobrarJurosAnual;
		public String PeriodoCobrancaDeJuros;
		public Double ValorPrestacaoDeServicos;
		public Boolean AnteciparCorrecaoProximoPeriodo;
		public List<Clientes> Clientes;
		public List<Itens> Itens;
		public List<Parcelas> Parcelas;
		public List<DescontosDeCusta> Impostos;
		public List<Comissoes> Comissoes;
		public List<DescontosDeCusta> Seguros;
		public List<PlanosIndexadores> PlanosIndexadores;
		public List<Comentarios> Comentarios;
		public Double StatusEscritura;
	}

	public class Telefones {
		public String ddd;
		public String fone;
		public String tipoTelefone;
		public String ramal;
	}
    
    
    public class ErroResponse
	{
		public string code {get;set;}
        public string type {get;set;}
		public string message {get;set;}
	}
}