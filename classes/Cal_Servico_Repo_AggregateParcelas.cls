public class Cal_Servico_Repo_AggregateParcelas {

    public List<TW1_Parcelas__c> GetParcelasDeUmaUnidade(String idUnidade)
    {
        return [SELECT id
		    	FROM TW1_Parcelas__c
 		    	WHERE
		    	TW1_Unidade__c = :idUnidade];
    }
    
    public void DeleteLista(List<TW1_Parcelas__c> lista)
    {
        delete lista;
    }
    
}