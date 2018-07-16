/**
* Classe TriggerFactory
*
* Usada para instanciar e executar Trigger Handlers associados a objetos.
*/
global with sharing class Cal_Cls_Infra_TriggerFactory
{
    //@future
    public static void createHandler(Schema.sObjectType soType)
    {
        //Recebe o handle apropriado para o objeto processado
        Cal_Cls_Infra_ITrigger handler = getHandler(soType);
        
        // Verifica se existe um handler registrado, caso não tenha, subimos uma exception
        if (handler == null)
        {
            throw new Cal_Cls_Infra_Exception('Nâo Existe uma Trigger Handler registrada para esse tipo de Objeto: ' + soType);
        }
        
        // Executa o handler correspondente a sua trigger
        execute(handler);
    }
    
    private static void execute(Cal_Cls_Infra_ITrigger handler)
    {
        // Before Trigger
        if (Trigger.isBefore)
        {
            // Call the bulk before to handle any caching of data and enable bulkification
            handler.bulkBefore();
            
            // Iterate through the records to be deleted passing them to the handler.
            if (Trigger.isDelete)
            {
                for (SObject so : Trigger.old)
                {
                    handler.beforeDelete(so);
                }
            }
            // Iterate through the records to be inserted passing them to the handler.
            else if (Trigger.isInsert)
            {
                for (SObject so : Trigger.new)
                {
                    handler.beforeInsert(so);
                }
            }
            // Iterate through the records to be updated passing them to the handler.
            else if (Trigger.isUpdate)
            {
                for (SObject so : Trigger.old)
                {
                    handler.beforeUpdate(so, Trigger.newMap.get(so.Id));
                }
            }
        }
        else
        {
            // Call the bulk after to handle any caching of data and enable bulkification
            handler.bulkAfter();
            
            // Iterate through the records deleted passing them to the handler.
            if (Trigger.isDelete)
            {
                for (SObject so : Trigger.old)
                {
                    handler.afterDelete(so);
                }
            }
            // Iterate through the records inserted passing them to the handler.
            else if (Trigger.isInsert)
            {
                for (SObject so : Trigger.new)
                {
                    handler.afterInsert(so);
                }
            }
            // Iterate through the records updated passing them to the handler.
            else if (Trigger.isUpdate)
            {
                for (SObject so : Trigger.old)
                {
                    handler.afterUpdate(so, Trigger.newMap.get(so.Id));
                }
            }
            else if(Trigger.isUnDelete){
                for (SObject so : Trigger.new)
                {
                    handler.OnUndelete(so);   
                }
            }
        }
        
        // Perform any post processing
        handler.andFinally();
    }
    
    private static Cal_Cls_Infra_ITrigger getHandler(Schema.sObjectType soType)
    {
        if (soType == Task.sObjectType)
        {
            return new Cal_Servico_TR_Handler_Task(Trigger.isExecuting, Trigger.size);
        }
        
        if (soType == TW1_Pendencia__c.sObjectType)
        {
            return new Cal_Servico_TR_Handler_Pendencias(Trigger.isExecuting, Trigger.size);
        }
        
        if (soType == Case.sObjectType)
        {
            return new Cal_Servico_TR_Handler_Casos(Trigger.isExecuting, Trigger.size);
        }
        
        if (soType == TW1_Item_area_Comum__c.sObjectType)
        {
            return new Cal_Servico_TR_Handler_ItemAC(Trigger.isExecuting, Trigger.size);
        }
        
        if (soType == TW1_TimeLineStatus_Case__c.sObjectType)
        {
            return new Cal_Servico_TR_Handler_Casos_Status(Trigger.isExecuting, Trigger.size);
        }
        
        if (soType == TW1_Inadimplencia__c.sObjectType)
        {
            return new Cal_Servico_TR_Handler_Inadimplencia(Trigger.isExecuting, Trigger.size);
        }
        
        if (soType == TimeLine_Fase_Inadimpl_ncia__c.sObjectType)
        {
            return new Cal_Servico_TR_Handler_Inadimp_Fase(Trigger.isExecuting, Trigger.size);
        }
       
        return null;
    }
}