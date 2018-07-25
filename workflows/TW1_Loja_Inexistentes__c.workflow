<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Copia_SGL</fullName>
        <field>TW1_SGL_Shopping__c</field>
        <formula>TW1_Shopping__r.TW1_SGL_Empreendimento__c</formula>
        <name>Copia SGL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>TW1_WF_LojaInexistente_CopiaSGL</fullName>
        <actions>
            <name>Copia_SGL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copia a sigla do shopping para o campos SGL do Shopping do objeto Loja Inexistente para ser utilizado na regra de compartilhamento.</description>
        <formula>ISNEW() || ISCHANGED(TW1_Shopping__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
