global class Cal_Servico_Ctr_ImportacaoIR {
	
    static Cal_Servico_Application_GeraDocCaso gerarDocumentoParaCaso = new Cal_Servico_Application_GeraDocCaso();
    
    public static String id {get;set;}
    
    public Cal_Servico_Ctr_ImportacaoIR()
    {        
    	id = ApexPages.currentPage().getParameters().get('idcaso');
        system.debug(id);
    }
    
    @RemoteAction
    global static string ImportarIR(string idcaso)
    {
        gerarDocumentoParaCaso.GerarIR(idcaso);
       	//Cal_Cls_Infra_Utils.Sleep(5000);
        return idcaso;
    }	
}