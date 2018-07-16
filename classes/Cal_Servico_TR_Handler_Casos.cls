public with sharing class Cal_Servico_TR_Handler_Casos implements Cal_Cls_Infra_ITrigger {
	
    Cal_Servico_Application_Cases casoApplication = new Cal_Servico_Application_Cases();
    
    private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	
	// Construtor
	public Cal_Servico_TR_Handler_Casos(boolean isExecuting, integer size)
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
        try
        {
            system.debug('Validar ValidarContaContatoDeUmCaso');
            casoApplication.ValidarContaContatoDeUmCaso((case)so);
        }
        catch(Exception e)
        {
            so.addError(e.getMessage());
        }
	}
	
	public void beforeUpdate(SObject oldSo, SObject so)
	{		
        try
        {
            system.debug('Validar ValidarContaContatoDeUmCaso');
            casoApplication.ValidarContaContatoDeUmCaso(((case)so));
            system.debug('Validar AtualizaInserirStatusTimeLine');
            casoApplication.AtualizaInserirStatusTimeLine(((Case)oldSo), ((Case)so));
            system.debug('Validar AtualizarStatusTimeLine');
            casoApplication.AtualizarStatusTimeLine( ((Case)oldSo) );
            system.debug('Validar AtualizarIdGestorFinanceiro');
            casoApplication.AtualizarIdGestorFinanceiro(((case)so));
            system.debug('Validar FecharMarcos');
            casoApplication.FecharMarcos(((Case)oldSo), ((Case)so));
        }
        catch(Exception e)
        {
            so.addError(e.getMessage());
        }
	}
	
	public void beforeDelete(SObject so)
	{	
		// Adicionando o erro ao objeto
		//Object.addError('Você não pode deletar o seu contato Contact');
		
	}
	
	public void afterInsert(SObject so)
	{
        casoApplication.InserirStatusTimeLine(((Case)so));
	}
	
	public void afterUpdate(SObject oldSo, SObject so)
	{		
	}
	
	public void afterDelete(SObject so)
	{		
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