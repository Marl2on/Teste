trigger TW1_Ancar_Servico_NotaFiscal_Participante_trigger on NTFS__c (before insert) {
	TriggerFactory.createHandler(NTFS__c.sObjectType);   
}