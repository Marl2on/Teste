public class TR_Historico_Rep {
    
    public List<TW1_Historico__c> GetHistoricocExpiradoEmDias(Integer dias)
    {
        return [SELECT id FROM TW1_Historico__c WHERE TW1_Data_fim__c > :dias LIMIT 1000];
    }
}