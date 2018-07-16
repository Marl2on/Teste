public with sharing class Cal_Servico_Ctr_ImportacoesUAU 
{
	Cal_Servico_Application_CargaUnidades cargaUnidadeApplication = new Cal_Servico_Application_CargaUnidades();
		
    public String CargaEmpreendimento_Empresa {get;set;}
    
    public String CargaEmpreendimento_Obra {get;set;}
    
    public Boolean CargaEmpreendimento_Habilitarcarga  {get; set;}
    
    public List<Log_Integracao__c> LogsEmpreendimentos {get;set;}
    
    public Cal_Servico_Ctr_ImportacoesUAU()
	{
		/// Carregando lista de integraão de carga de empreendimentos
		LogsEmpreendimentos = cargaUnidadeApplication.GetListLogIntegracao('Carga empreendimento');
		ValidarInicioCargaEmpreendimentos();
	}
    
    public void CargaEmpreendimento_ExecutarCarga()
    {
    	/// Inserir um processo em log processo
    	system.debug('Inicinando novo processo de carga de empreendimento.');
        system.debug('Empresa: ' + CargaEmpreendimento_Empresa);
        system.debug('Obra: ' + CargaEmpreendimento_Obra);
        cargaUnidadeApplication.IniciarNovoProcesso(CargaEmpreendimento_Empresa,CargaEmpreendimento_Obra);    	
    	system.debug('Validando se pode ser acionada outra carga de empreendimentos');
        ValidarInicioCargaEmpreendimentos();
        system.debug('CargaEmpreendimento_Habilitarcarga: ' + CargaEmpreendimento_Habilitarcarga);
    	
        system.debug('Zerando valores de empresa e obra');
        CargaEmpreendimento_Empresa = '';
    	CargaEmpreendimento_Obra = '';
    	
        system.debug('Atualizando lista de integrações de Carga empreendimento');
    	LogsEmpreendimentos = cargaUnidadeApplication.GetListLogIntegracao('Carga empreendimento');
        system.debug('Lista: ' + LogsEmpreendimentos);
    } 
        
    private void ValidarInicioCargaEmpreendimentos()
    {
   		CargaEmpreendimento_Habilitarcarga = cargaUnidadeApplication.ExisteProcessoEmAberto();
    }
}