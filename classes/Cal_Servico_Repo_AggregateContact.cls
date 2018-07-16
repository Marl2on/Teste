public with sharing class Cal_Servico_Repo_AggregateContact {
    
    public Contact GetContatoById(String id)
    {
    	List<Contact> retorno =  [
		    	SELECT id,Tw1_CPF__c, Name,Email,Phone, AccountID
		    	FROM contact
 		    	WHERE
		    	Id = :Id];
		    	
		if(retorno.Size() == 0)
    		return null;
    	else
    		return retorno[0];
    }
    
    public List<AccountContactRelation> GetListaContatosPrincipaisDeUmaConta(string accountId)
    {
       return [SELECT 
               id,
               AccountID, 
               Account.Name,
               ContactId,
               Contact.Name,
               Tw1_Principal__c
		       FROM AccountContactRelation WHERE AccountId =:accountId];
    }
}