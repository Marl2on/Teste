<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>TW1_Update_Nome_INCC</fullName>
        <description>Update do campo Nome de INCC pelo campo Mês Ano.</description>
        <field>Name</field>
        <formula>CASE(MID(TW1_Mes_Ano__c,4,2), 
 &quot;01&quot;,&quot;JAN&quot;,
 &quot;02&quot;,&quot;FEV&quot;,
 &quot;03&quot;,&quot;MAR&quot;,
 &quot;04&quot;,&quot;ABR&quot;,
 &quot;05&quot;,&quot;MAI&quot;,
 &quot;06&quot;,&quot;JUN&quot;,
 &quot;07&quot;,&quot;JUL&quot;,
 &quot;08&quot;,&quot;AGO&quot;,
 &quot;09&quot;,&quot;SET&quot;,
 &quot;10&quot;,&quot;OUT&quot;,
 &quot;11&quot;,&quot;NOV&quot;,
 &quot;12&quot;,&quot;DEZ&quot;,
 &quot;None&quot;) &amp; &quot;/&quot; &amp; RIGHT(TW1_Mes_Ano__c,4)</formula>
        <name>Update Nome INCC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Validar Nome de INCC</fullName>
        <actions>
            <name>TW1_Update_Nome_INCC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(     ISCHANGED(TW1_Mes_Ano__c),     NOT(REGEX(Name,&quot;[A-Z]{3}/[0-9]{4}&quot;))          )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
