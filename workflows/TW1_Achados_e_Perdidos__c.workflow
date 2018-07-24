<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Atualiza_Status</fullName>
        <description>Prenche o campo status para devolvido</description>
        <field>TW1_Status__c</field>
        <literalValue>Devolvido</literalValue>
        <name>Atualiza Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>atualizar_status_doacao</fullName>
        <field>TW1_Status__c</field>
        <literalValue>Doado</literalValue>
        <name>atualizar status doacao</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>TW1_WF_AchadoPerdido_atualizaStatus</fullName>
        <actions>
            <name>Atualiza_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Quando a data de devolução for preenchida o status será alterado para &quot;Devolvido&quot;.</description>
        <formula>OR ( 

AND ( 

ISNEW(), 
NOT(ISBLANK(TW1_Data_da_Devolucao__c)) 
), 

AND ( 
ISCHANGED(TW1_Data_da_Devolucao__c), 
NOT(ISBLANK(TW1_Data_da_Devolucao__c)) 
))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TW1_WF_AchadoPerdido_atualizaStatus_doacao</fullName>
        <actions>
            <name>atualizar_status_doacao</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Quando a data de doação for preenchida o status será alterado para &quot;Doado&quot;.</description>
        <formula>OR ( 

AND ( 

ISNEW(), 
NOT(ISBLANK(TW1_Data_da_Doacao__c)) 
), 

AND ( 
ISCHANGED(TW1_Data_da_Doacao__c), 
NOT(ISBLANK(TW1_Data_da_Doacao__c)) 
))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
