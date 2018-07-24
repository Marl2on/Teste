<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Atualiza_SGL_Shopping</fullName>
        <field>TW1_SGL__c</field>
        <formula>TW1_Shopping__r.TW1_SGL_Empreendimento__c</formula>
        <name>Atualiza SGL Shopping</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>TW1_WF_RegLigacoes_PreencheSGL</fullName>
        <actions>
            <name>Atualiza_SGL_Shopping</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Preenche o campo SGL para regra de compartilhamento.</description>
        <formula>ISNEW() || ISCHANGED(TW1_Shopping__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
