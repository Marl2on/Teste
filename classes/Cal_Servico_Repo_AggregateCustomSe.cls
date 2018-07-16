public class Cal_Servico_Repo_AggregateCustomSe {
    
    public integer GetTempoAtualizacaoCadastral()
    {
        List<TW1_Padroes_relacionamento__c> settings = [
            SELECT 
            TW1_Tempo_Atualizacao_Cadastral__c 
            FROM TW1_Padroes_relacionamento__c];
        if(settings.size() >0)
            return (integer)settings[0].TW1_Tempo_Atualizacao_Cadastral__c;
        else
            return 160;
    }
    
    public string GetUtlApiUAU()
    {
        List<TW1_Custom_Settings__c> settings = [
            SELECT 
            TW1_URLBaseServicoUau__c 
            FROM TW1_Custom_Settings__c];
        if(settings.size() >0)
            return (string)settings[0].TW1_URLBaseServicoUau__c;
        else
            return null;
    }
    
    public string GetUrlApiAssitenciaTecnica()
    {
        List<TW1_Custom_Settings__c> settings = [
            SELECT 
            TW1_URLBaseServicoAT__c 
            FROM TW1_Custom_Settings__c];
        if(settings.size() >0)
            return (string)settings[0].TW1_URLBaseServicoAT__c;
        else
            return null;
    }
    
    public string GetURLCallBackAT()
    {
        //URLCallBackAT
        List<TW1_Custom_Settings__c> settings = [
            SELECT 
            TW1_URLCallBackAT__c 
            FROM TW1_Custom_Settings__c];
        if(settings.size() >0)
            return (string)settings[0].TW1_URLCallBackAT__c;
        else
            return null;
    }
    
    public string GetParcelaNaoConciliadaInadimplencia()
    {
        List<TW1_Padroes_Inadimplencia__c> settings =  [SELECT 
                                                        TW1_parcelaNaoConciliada__c 
                                                        FROM TW1_Padroes_Inadimplencia__c];
        if(settings.size() >0)
            return string.valueOf(settings[0].TW1_parcelaNaoConciliada__c);
        else
            return null; 
    }
    
    public string GetQtdDiasVencimentoInadimplencia()
    {
        List<TW1_Padroes_Inadimplencia__c> settings =  [SELECT 
                                                        TW1_qtdDiasVencimento__c 
                                                        FROM TW1_Padroes_Inadimplencia__c];
        if(settings.size() > 0)
            return string.valueOf(settings[0].TW1_qtdDiasVencimento__c);
        else
            return null; 
    }
    
    public string GetUrlCallbackInadimplencia()
    { 
        List<TW1_Padroes_Inadimplencia__c> settings =  [SELECT 
                                                        TW1_urlCallback__c 
                                                        FROM TW1_Padroes_Inadimplencia__c];
        if(settings.size() > 0)
            return string.valueOf(settings[0].TW1_urlCallback__c);
        else
            return null;     	
    }
    
    public string GetCallBackAtualizacaoCadastralUAU()
    { 
        List<TW1_Custom_Settings__c> settings =  [SELECT 
                                                  TW1_URLCallBackAtualizacaoCadastralUAU__c 
                                                  FROM TW1_Custom_Settings__c];
        if(settings.size() > 0)
            return string.valueOf(settings[0].TW1_URLCallBackAtualizacaoCadastralUAU__c);
        else
            return null;     	
    }
    
    public string GetLoginAuthUAU()
    { 
        List<TW1_Custom_Settings__c> settings =  [SELECT 
                                                  TW1_LoginUau__c  
                                                  FROM TW1_Custom_Settings__c];
        if(settings.size() > 0)
            return string.valueOf(settings[0].TW1_LoginUau__c);
        else
            return null;     	
    }
    
    public string GetSenhaAuthUAU()
    { 
        List<TW1_Custom_Settings__c> settings =  [SELECT 
                                                  TW1_SenhaUau__c   
                                                  FROM TW1_Custom_Settings__c];
        if(settings.size() > 0)
            return string.valueOf(settings[0].TW1_SenhaUau__c );
        else
            return null;     	
    }
    
     public Boolean GetUsaBaseProducaoAuthUAU()
    { 
        List<TW1_Custom_Settings__c> settings =  [SELECT 
                                                  TW1_BaseProducaoUau__c    
                                                  FROM TW1_Custom_Settings__c];
        if(settings.size() > 0)
            return settings[0].TW1_BaseProducaoUau__c;
        else
            return null;     	
    }
}