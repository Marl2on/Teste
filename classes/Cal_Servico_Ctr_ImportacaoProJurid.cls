global class Cal_Servico_Ctr_ImportacaoProJurid {
    
    public static String id {get;set;}
    
    static Cal_Servico_Application_Pessoa pessoaApplication = new Cal_Servico_Application_Pessoa();
    
    public Cal_Servico_Ctr_ImportacaoProJurid()
    {        
        id = ApexPages.currentPage().getParameters().get('AccountId');
        system.debug(id);
    }
    
    @RemoteAction
    global static string ImportarProcessosProJurid(string accountId)
    {
        try
        {
            pessoaApplication.ImportarProcessoProJuridDaConta(accountId);
        }
        catch(Exception e)
        {}
        
        return accountId;
    }	
}