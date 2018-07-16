global class Cal_Servico_Ctr_ImportExtracoFinanceiro {
   
    static Cal_Servico_Application_GeraDocCaso gerarDocumentoParaCaso = new Cal_Servico_Application_GeraDocCaso();
    
    public static String id {get;set;}
    
    public Cal_Servico_Ctr_ImportExtracoFinanceiro()
    {        
    	id = ApexPages.currentPage().getParameters().get('idcaso');
        system.debug(id);
    }
    
    @RemoteAction
    global static string ImportarExtratoFinanceiro(string idcaso)
    {
        gerarDocumentoParaCaso.GerarExtratoFinanceiro(idcaso);
       	return idcaso;
    }	
}