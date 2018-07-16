public with sharing class Cal_Servico_Application_Task {
    
    private static Cal_Servico_Repo_AggregateCase casoRepository = new Cal_Servico_Repo_AggregateCase();
    
    
    /// Método para incrementar contator de tarefas dentro de um caso
    public void AtualizaNumeroTarefasEmAbertoEmUmCaso(List<Task> listaTarefas)
    {
    	System.debug('Lista de tarefas: ' + listaTarefas.Size()); 
    	for(Task task: listaTarefas)
        {
        	System.debug('Status da tarefa: ' + task.Status); 
            Id idCaso = Task.WhatId;
            
            System.debug('Consultando caso pelo ID'); 
            Case casoAtualizar  = casoRepository.GetCaseById(idCaso);
            System.debug('Caso solicitado:' + casoAtualizar );
                        
            System.debug('Consultando lista de tarefa pelo caso ID:' + idCaso); 
            List<Task> tarefas = casoRepository.GetListOfTaskOpenFromCaseByCaseId(idCaso);
            System.debug('Total de tarefas do caso selecionado:' + tarefas.Size()); 
            
            System.debug('Incrementando o campo TW1_Tarefas_Abertas__c no caso: ' + tarefas.Size());
            casoAtualizar.TW1_Tarefas_Abertas__c = tarefas.Size(); 
            
            System.debug('Salvando o caso com atividades'); 
            casoRepository.Modify(casoAtualizar);
        }
    }
    
    public void SetDataApRepAnaliseCredito(Task oldSo, Task so)
    {
        if(oldSo.TW1_Aprovacao_Analise_Credito__c != so.TW1_Aprovacao_Analise_Credito__c)
        	so.TW1_Data_Ap_Rep_Analise_Credito__c = DateTime.now();
    }
}