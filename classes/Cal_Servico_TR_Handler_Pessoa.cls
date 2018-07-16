public class Cal_Servico_TR_Handler_Pessoa implements Cal_Cls_Infra_ITrigger {
    
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    
    // Construtor
    public Cal_Servico_TR_Handler_Pessoa(boolean isExecuting, integer size)
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
        
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {	
        Cal_Servico_Application_Pessoa.AtualizarDadosCadastraisUAU(((Account)so).Id);
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