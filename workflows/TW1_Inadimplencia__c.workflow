<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Aprovada</fullName>
        <field>TW1_Status_Aprovacao__c</field>
        <literalValue>Aprovado</literalValue>
        <name>Aprovada</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Aprovado_Dir_Fin_Extra</fullName>
        <field>TW1_Aprovacao_Diretoria_Financeira_Extra__c</field>
        <literalValue>Sim</literalValue>
        <name>Aprovado Dir Fin (Extra)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Gravar_Data_Aprovacao_Dir_Fin</fullName>
        <field>TW1_Data_Aprovacao_Diretoria_Financeira__c</field>
        <formula>NOW()</formula>
        <name>Gravar Data Aprovação Dir Financeira</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reprovada</fullName>
        <field>TW1_Status_Aprovacao__c</field>
        <literalValue>Reprovado</literalValue>
        <name>Reprovada</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reprovado_Dir_Fin</fullName>
        <field>TW1_Aprovacao_Diretoria_Financeira_Extra__c</field>
        <literalValue>Não</literalValue>
        <name>Reprovado Dir Fin (Extra)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Aprovada_Judicial</fullName>
        <field>TW1_Status_Aprovacao__c</field>
        <literalValue>Aprovado</literalValue>
        <name>Aprovada Judicial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Aprovada_pela_Diretoria_Financeira</fullName>
        <field>TW1_Aprovacao_Diretoria_Financeira__c</field>
        <literalValue>Sim</literalValue>
        <name>Aprovada pela Diretoria Financeira</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Atualiza_Etapa_Inadimplencia</fullName>
        <field>TW1_Etapa__c</field>
        <literalValue>Negociação Definida/Aguardando Conclusão da Inadimplência</literalValue>
        <name>Atualiza Etapa Inadimplência</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Atualizar_Data_Ap_Dir_Fin_Extra</fullName>
        <field>TW1_Data_Aprovacao_Dir_Financeira_Extra__c</field>
        <formula>now()</formula>
        <name>Atualizar Data Ap Dir Financeira (Extra)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Atualizar_data_Aprovacao</fullName>
        <field>TW1_Data_Aprovacao_Diretoria_Financeira__c</field>
        <formula>NOW()</formula>
        <name>Atualizar data Aprovação</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Reprovada_Judicial</fullName>
        <field>TW1_Status_Aprovacao__c</field>
        <literalValue>Reprovado</literalValue>
        <name>Reprovada Judicial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Reprovada_pela_Diretoria_Financeira</fullName>
        <field>TW1_Aprovacao_Diretoria_Financeira__c</field>
        <literalValue>Não</literalValue>
        <name>Reprovada pela Diretoria Financeira</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
