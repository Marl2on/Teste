<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>TW1_Preenche_nome</fullName>
        <field>Name</field>
        <formula>TW1_Numero_da_Oportunidade__c</formula>
        <name>Preenche nome</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Gerar Numeração Automatica</fullName>
        <actions>
            <name>TW1_Preenche_nome</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Criar Numero sequencia para Oportunidades</description>
        <formula>NOT(ISNULL( CreatedDate ))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
