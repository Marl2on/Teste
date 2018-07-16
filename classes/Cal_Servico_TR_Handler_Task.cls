public with sharing class Cal_Servico_TR_Handler_Task implements Cal_Cls_Infra_ITrigger {
	
	private Cal_Servico_Application_Task taskApplication = new Cal_Servico_Application_Task();
    
    private Cal_Servico_Repo_AggregateCase caseRepository = new Cal_Servico_Repo_AggregateCase();
	
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	
	// Construtor
	public Cal_Servico_TR_Handler_Task(boolean isExecuting, integer size)
	{
		m_isExecuting = isExecuting;
		BatchSize = size;
	}
	
	
	public void bulkBefore()
	{

	}
	
	public void bulkAfter()
	{
	}
		
	public void beforeInsert(SObject so)
	{
		Task tarefa = (Task)so;
        Case caso = caseRepository.GetCaseById(tarefa.WhatId);
        
        // Caso o case não exista, então não preenche o lookup
        if(caso != null)
        	tarefa.TW1_Caso__c =  tarefa.WhatId;	
	}
	
	public void beforeUpdate(SObject oldSo, SObject so)
	{
		Task tarefa = (Task)so;
        Case caso = caseRepository.GetCaseById(tarefa.WhatId);
        
        // Caso o case não exista, então não preenche o lookup
        if(caso != null)
        	tarefa.TW1_Caso__c =  tarefa.WhatId;	
        
        taskApplication.SetDataApRepAnaliseCredito((Task)oldSo, (Task)so);
	}
	
	public void beforeDelete(SObject so)
	{	
		// Adicionando o erro ao objeto
		//Object.addError('Você não pode deletar o seu contato Contact');
		
	}
	
	public void afterInsert(SObject so)
	{
        Task tarefa = (Task)so;
        Case caso = caseRepository.GetCaseById(tarefa.WhatId);
        
        // Caso o case não exista, então não contabiliza valor no caso
        if(caso != null)
        {    
            System.debug('Trigger inserir tarefa'); 
            List<Task> tarefasProcecssar = new List<Task>();
            tarefasProcecssar.add((Task)so);
            
			/// Atualiza quantidade de tarefas em aberto do caso relacionado a Tarefa
            taskApplication.AtualizaNumeroTarefasEmAbertoEmUmCaso(tarefasProcecssar);
        }
	}
	
	public void afterUpdate(SObject oldSo, SObject so)
	{
		Task tarefa = (Task)so;
        Case caso = caseRepository.GetCaseById(tarefa.WhatId);
        
        // Caso o case não exista, então não contabiliza valor no caso
        if(caso != null)
        {    
            System.debug('Trigger atualizar tarefa');
		
            List<Task> tarefasProcecssar = new List<Task>();
            tarefasProcecssar.add((Task)so);
            
            /// Atualiza quantidade de tarefas em aberto do caso relacionado a Tarefa
            taskApplication.AtualizaNumeroTarefasEmAbertoEmUmCaso(tarefasProcecssar);
        }
	}
	
	public void afterDelete(SObject so)
	{
		Task tarefa = (Task)so;
        Case caso = caseRepository.GetCaseById(tarefa.WhatId);
        
        // Caso o case não exista, então não contabiliza valor no caso
        if(caso != null)
        {   
            System.debug('Trigger excluir uma tarefa');
		
            List<Task> tarefasProcecssar = new List<Task>();
            tarefasProcecssar.add((Task)so);
            
            /// Atualiza quantidade de tarefas em aberto do caso relacionado a Tarefa
            taskApplication.AtualizaNumeroTarefasEmAbertoEmUmCaso(tarefasProcecssar);
        }
	}
	
	public void OnUndelete(SObject restoredSObject){
		
	}
	
	public boolean IsTriggerContext{
		get{ return m_isExecuting;}
	}
	
	public boolean IsVisualforcePageContext{
		get{ return !IsTriggerContext;}
	}
	
	public boolean IsWebServiceContext{
		get{ return !IsTriggerContext;}
	}
	
	public boolean IsExecuteAnonymousContext{
		get{ return !IsTriggerContext;}
	}
	
	public void andFinally()
	{

	}
    
}