trigger Cal_Servico_CaseStatus_Trigger on TW1_TimeLineStatus_Case__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    Cal_Cls_Infra_TriggerFactory.createHandler(TW1_TimeLineStatus_Case__c.sObjectType);
}