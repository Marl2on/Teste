public with sharing class Cal_Servico_TR_Handler_Pendencias implements Cal_Cls_Infra_ITrigger {
	
    private Cal_Servico_Application_Pendencia pendenciaApplication = new Cal_Servico_Application_Pendencia();
    
    private Cal_Servico_Repo_AggregateCase caseRepository = new Cal_Servico_Repo_AggregateCase();
	
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	
	// Construtor
	public Cal_Servico_TR_Handler_Pendencias(boolean isExecuting, integer size)
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
	
	}
	
	public void beforeUpdate(SObject oldSo, SObject so)
	{
		
	}
	
	public void beforeDelete(SObject so)
	{	
		// Adicionando o erro ao objeto
		//Object.addError('Você não pode deletar o seu contato Contact');
		
	}
	
	public void afterInsert(SObject so)
	{
        TW1_Pendencia__c pendencia = (TW1_Pendencia__c)so;
        Case caso = caseRepository.GetCaseById(pendencia.TW1_Caso_Relacionado__c);
        
        // Caso o case não exista, então não contabiliza valor no caso
        if(caso != null)
        {    
            System.debug('Trigger inserir tarefa'); 
            List<TW1_Pendencia__c> pendenciasProcessar = new List<TW1_Pendencia__c>();
            pendenciasProcessar.add((TW1_Pendencia__c)so);
            
			/// Atualiza quantidade de tarefas em aberto do caso relacionado a Tarefa
            pendenciaApplication.AtualizaNumeroPendenciaNaoResolcidaEmUmCaso(pendenciasProcessar);
        }
	}
	
	public void afterUpdate(SObject oldSo, SObject so)
	{
		TW1_Pendencia__c pendencia = (TW1_Pendencia__c)so;
        Case caso = caseRepository.GetCaseById(pendencia.TW1_Caso_Relacionado__c);
        
        // Caso o case não exista, então não contabiliza valor no caso
        if(caso != null)
        {    
            System.debug('Trigger inserir tarefa'); 
            List<TW1_Pendencia__c> pendenciasProcessar = new List<TW1_Pendencia__c>();
            pendenciasProcessar.add((TW1_Pendencia__c)so);
            
			/// Atualiza quantidade de tarefas em aberto do caso relacionado a Tarefa
            pendenciaApplication.AtualizaNumeroPendenciaNaoResolcidaEmUmCaso(pendenciasProcessar);
        }
	}
	
	public void afterDelete(SObject so)
	{
		TW1_Pendencia__c pendencia = (TW1_Pendencia__c)so;
        Case caso = caseRepository.GetCaseById(pendencia.TW1_Caso_Relacionado__c);
        
        // Caso o case não exista, então não contabiliza valor no caso
        if(caso != null)
        {    
            System.debug('Trigger inserir tarefa'); 
            List<TW1_Pendencia__c> pendenciasProcessar = new List<TW1_Pendencia__c>();
            pendenciasProcessar.add((TW1_Pendencia__c)so);
            
			/// Atualiza quantidade de tarefas em aberto do caso relacionado a Tarefa
            pendenciaApplication.AtualizaNumeroPendenciaNaoResolcidaEmUmCaso(pendenciasProcessar);
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