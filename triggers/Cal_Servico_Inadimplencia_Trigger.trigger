trigger Cal_Servico_Inadimplencia_Trigger on TW1_Inadimplencia__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
Cal_Cls_Infra_TriggerFactory.createHandler(TW1_Inadimplencia__c.sObjectType);
}