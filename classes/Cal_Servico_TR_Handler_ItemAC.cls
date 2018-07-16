// Objeto Handler de Trigger área comum
public class Cal_Servico_TR_Handler_ItemAC implements Cal_Cls_Infra_ITrigger {
	
    Cal_Servico_Application_Cases casoApplication = new Cal_Servico_Application_Cases();
    
    private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	
	// Construtor
	public Cal_Servico_TR_Handler_ItemAC(boolean isExecuting, integer size)
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
        TW1_Item_area_Comum__c item = (TW1_Item_area_Comum__c)so;
        
        /// Atualiza quantidade de intens de área comum
        casoApplication.AtualizaQuantidadeItensAreaComum(item.TW1_Relacionado_ao_Caso__c);
	}
	
	public void afterUpdate(SObject oldSo, SObject so)
	{		
        TW1_Item_area_Comum__c item = (TW1_Item_area_Comum__c)so;
        
        /// Atualiza quantidade de intens de área comum
        casoApplication.AtualizaQuantidadeItensAreaComum(item.TW1_Relacionado_ao_Caso__c);
	}
	
	public void afterDelete(SObject so)
	{		
        TW1_Item_area_Comum__c item = (TW1_Item_area_Comum__c)so;
        
        /// Atualiza quantidade de intens de área comum
        casoApplication.AtualizaQuantidadeItensAreaComum(item.TW1_Relacionado_ao_Caso__c);
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