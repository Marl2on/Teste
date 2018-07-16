trigger Cal_Servico_AreaComun_Trigger on TW1_Item_area_Comum__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    Cal_Cls_Infra_TriggerFactory.createHandler(TW1_Item_area_Comum__c.sObjectType);
}