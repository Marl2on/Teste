trigger Cal_Servico_Pendencia_Trigger on TW1_Pendencia__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    Cal_Cls_Infra_TriggerFactory.createHandler(TW1_Pendencia__c.sObjectType);
}