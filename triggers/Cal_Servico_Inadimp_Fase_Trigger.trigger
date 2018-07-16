trigger Cal_Servico_Inadimp_Fase_Trigger on TimeLine_Fase_Inadimpl_ncia__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    Cal_Cls_Infra_TriggerFactory.createHandler(TimeLine_Fase_Inadimpl_ncia__c.sObjectType);
}