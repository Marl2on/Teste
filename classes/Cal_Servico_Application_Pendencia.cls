public class Cal_Servico_Application_Pendencia {
	
    private static Cal_Servico_Repo_AggregateCase casoRepository = new Cal_Servico_Repo_AggregateCase();
  	
     /// Método para incrementar contator de tarefas dentro de um caso
    public void AtualizaNumeroPendenciaNaoResolcidaEmUmCaso(List<TW1_Pendencia__c> listaPendencias)
    {
    	System.debug('Lista de pendencias: ' + listaPendencias.Size()); 
    	for(TW1_Pendencia__c pendencia: listaPendencias)
        {
        	System.debug('Status da pendencia: ' + pendencia.TW1_Status__c); 
            Id idCaso = pendencia.TW1_Caso_Relacionado__c;
            
            System.debug('Consultando caso pelo ID'); 
            Case casoAtualizar  = casoRepository.GetCaseById(idCaso);
            System.debug('Caso solicitado:' + casoAtualizar );
                        
            System.debug('Consultando lista de pendencias pelo caso ID:' + idCaso); 
            List<TW1_Pendencia__c> pendencias = casoRepository.GetListOfPendenciasNotResolvedFromCaseByCaseId(idCaso);
            System.debug('Total de pendencias do caso selecionado:' + pendencias.Size()); 
            
            System.debug('Incrementando o campo TW1_Pendencias_Abertas__c  no caso: ' + pendencias.Size());
            casoAtualizar.TW1_Pendencias_Abertas__c  = pendencias.Size(); 
            
            System.debug('Salvando o caso com pêndencias'); 
            casoRepository.Modify(casoAtualizar);
        }
    }
}