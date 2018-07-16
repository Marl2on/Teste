public with sharing class Cal_Servico_Repo_AggregateCase {

    /// Método para buscar lista de casos por CPF    
    public List<Case> GetListaCasosPorAccountId(String accountId, string origin)
    {
        return [select id, AccountId, ContactId, Subject, Origin, CreatedDate, LastModifiedDate, Type, TW1_Status_Portal__c
                from Case  
                where AccountId = :accountId AND Origin =:origin];
    }
    
    /// Método para buscar lista de casos por CPF    
    public List<Case> GetListaCasosPorAccountIdOrigemWeb(String accountId)
    {
        return GetListaCasosPorAccountId(accountId,'Web');
    }
    
    /// Busca caso por ID
    public Case GetCaseById(String id)
    {
        List<Case> casos =[select id, 
                AccountId,
                ContactId, 
                OwnerId, 
                TW1_Unidade__c, 
                TW1_Bloco__c,
                Subject, 
                Description, 
                Origin, 
                TW1_URLCallBack__c, 
                TW1_ID_Assistencia_Tecnica__c, 
                Tw1_Status_Assistencia_Tecnica__c, 
                TW1_Detalhamento_Solicitacao_Manutencao__c,
                RecordTypeId,
                CaseNumber,
                Account.Name,
                TW1_Empreendimento__c,
                TW1_ID_Empreendimento__c,
                Contact.Name,
                TW1_Numero_Unidade__c,
                TW1_Data_inicio_para_agendar_vistoria__c
                from 
                    Case  
                where 
                    id =:id];
                 
        if(casos.Size() == 0)
            return null;
        else
            return casos[0];
    }
    
    /// Atualiza caso 
    public void Modify(Case caso)
    {
        update caso;
    }
    
    public void Incluir(Case caso)
    {
        Insert caso;
    }
    
    /// Busca lista de tarefas abertas dentro de um caso pelo Id do caso.
    public List<Task> GetListOfTaskOpenFromCaseByCaseId(string IdCase)
    {
        return [SELECT Id, IsClosed, Status FROM Task Where WhatId = :IdCase AND Status != 'Tw1_Concluida' AND Status != 'TW1_Cancelada' AND Status != 'Repassado'];
    }
    
    /// Busca lista de pendencias não resolvidas dentro de um caso pelo Id do caso.
    public List<TW1_Pendencia__c> GetListOfPendenciasNotResolvedFromCaseByCaseId(string IdCase)
    {
        return [select id,TW1_Status__c,TW1_Caso_Relacionado__c from TW1_Pendencia__c where TW1_Caso_Relacionado__c = :IdCase and TW1_Status__c != 'Resolvida'];
    }
    
     /// Busca lista de pendencias não resolvidas dentro de um caso pelo Id do caso.
    public List<TW1_Item_area_Comum__c> GetListOfItemAreaComumFromCaseByCaseId(string IdCase)
    {
        return [select id,TW1_Relacionado_ao_Caso__c, Tw1_Status_da_Vistoria__c from TW1_Item_area_Comum__c where TW1_Relacionado_ao_Caso__c = :IdCase and Tw1_Status_da_Vistoria__c != 'Aprovado'];
    }
}