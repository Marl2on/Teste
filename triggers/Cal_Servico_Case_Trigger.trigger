trigger Cal_Servico_Case_Trigger on Case (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    Cal_Cls_Infra_TriggerFactory.createHandler(Case.sObjectType);
}