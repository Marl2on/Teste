<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Atualizar_Forma_de_Pagamento</fullName>
        <field>TW1_Forma_de_pagamento__c</field>
        <formula>TEXT( Forma_de_Pagamento_Picklist__c)</formula>
        <name>Atualizar Forma de Pagamento</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>TW1 Atualizar Forma de Pagamento Texto</fullName>
        <actions>
            <name>Atualizar_Forma_de_Pagamento</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>NTFS__c.Forma_de_Pagamento_Picklist__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>TW1 Atualizar Forma de Pagamento Texto</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
