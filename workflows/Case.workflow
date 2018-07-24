<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ApagaValorDataEncerramento</fullName>
        <description>Apaga o valor do campo Data/Hora de encerramento</description>
        <field>TW1_DataHora_encerramento__c</field>
        <name>ApagaValorDataEncerramento</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Atualiza_Tipo_Elogio</fullName>
        <field>Type</field>
        <literalValue>Elogios</literalValue>
        <name>Atualiza Tipo Elogio</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Atualiza_Tipo_Reclamacao</fullName>
        <field>Type</field>
        <literalValue>Reclamações</literalValue>
        <name>Atualiza Tipo Reclamacao</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Atualiza_Tipo_Solicitacao</fullName>
        <field>Type</field>
        <literalValue>Solicitações</literalValue>
        <name>Atualiza Tipo Solicitacao</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Atualiza_Tipo_Sugestao</fullName>
        <field>Type</field>
        <literalValue>Sugestões</literalValue>
        <name>Atualiza Tipo Sugestao</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PreencheDataEncerramento</fullName>
        <description>Preenche a data de encerramento do caso com a data atual.</description>
        <field>TW1_DataHora_encerramento__c</field>
        <formula>NOW()</formula>
        <name>PreencheDataEncerramento</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>TW1_WF_OcorrenciaLimpaDataConclusao</fullName>
        <actions>
            <name>ApagaValorDataEncerramento</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Pendente</value>
        </criteriaItems>
        <description>Se o status de uma ocorrência, encerrada, resolvida ou cancelada, for alterado para pendente, o sistema deve limpar o valor do campo Data/Hora de encerramento.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TW1_WF_Ocorrencia_Preenche_DataEncerramento</fullName>
        <actions>
            <name>PreencheDataEncerramento</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Encerrada,Cancelada,Resolvida</value>
        </criteriaItems>
        <description>Preenche a data de encerramento do caso quando o status é alterado para  encerrada,resolvida ou cancelada</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TW1_WF_Ocorrencia_Preenche_Tipo_Elogio</fullName>
        <actions>
            <name>Atualiza_Tipo_Elogio</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Elogios</value>
        </criteriaItems>
        <description>Preenche o tipo da ocorrência de acordo com o tipo de registro.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>TW1_WF_Ocorrencia_Preenche_Tipo_Reclamacao</fullName>
        <actions>
            <name>Atualiza_Tipo_Reclamacao</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Reclamações</value>
        </criteriaItems>
        <description>Preenche o tipo da ocorrência de acordo com o tipo de registro.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>TW1_WF_Ocorrencia_Preenche_Tipo_Solicitacao</fullName>
        <actions>
            <name>Atualiza_Tipo_Solicitacao</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Solicitações</value>
        </criteriaItems>
        <description>Preenche o tipo da ocorrência de acordo com o tipo de registro.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>TW1_WF_Ocorrencia_Preenche_Tipo_Sugestao</fullName>
        <actions>
            <name>Atualiza_Tipo_Sugestao</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sugestões</value>
        </criteriaItems>
        <description>Preenche o tipo da ocorrência de acordo com o tipo de registro.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
