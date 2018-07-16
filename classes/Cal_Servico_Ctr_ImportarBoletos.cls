public class Cal_Servico_Ctr_ImportarBoletos {
    
    private Cal_Servico_Application_GeraDocCaso geraDocApplication = new Cal_Servico_Application_GeraDocCaso();
    
    public integer numeroBoletoSelecionado {get;set;}
    
    public integer numeroBanco {get;set;}
    
    /// ID do caso passado por parâmetro
    public string IdCaso {get;set;}
    
    public Cal_Servico_Ctr_ImportarBoletos()
    {
        IdCaso = ApexPages.currentPage().getParameters().get('idcaso');
        system.debug(IdCaso);
        
        /// Buscar caso
     	ListaBoletos = geraDocApplication.GetListaBoletosPorUnidade(IdCaso);        
    }
    
    public List<Cal_SA_UAU_GerarDocumentos.BoletosDto> ListaBoletos {get;set;}

	public PageReference GerarPPF()
    {
        system.debug('Iniciando geração de boleto para o caso ' + IdCaso + '; Banco ' + string.valueOf(numeroBanco) + '; Número Boleto: ' +  string.valueOf(numeroBoletoSelecionado));
     	geraDocApplication.GerarBoleto(IdCaso, string.valueOf(numeroBanco), string.valueOf(numeroBoletoSelecionado));
        system.debug('Redirecionando para página do caso ' + IdCaso);
       
        PageReference pr = new PageReference('/' + IdCaso);
        pr.setRedirect(true);
        return pr;
    } 
}