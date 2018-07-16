trigger Cal_Servico_Task_Trigger on Task (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    Cal_Cls_Infra_TriggerFactory.createHandler(Task.sObjectType);
}