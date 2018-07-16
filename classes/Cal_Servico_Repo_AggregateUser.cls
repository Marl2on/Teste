public with sharing class Cal_Servico_Repo_AggregateUser {
    
    public User GetUserById(string Id)
    {
    	List<User> retorno =  [
		    	SELECT 
                    id, 
                    Tw1_CPF__c,
            		Profile.Name
		    	FROM User
 		    	WHERE
		    	Id = :Id];
		    	
		if(retorno.Size() == 0)
    		return null;
    	else
    		return retorno[0];
    }
}