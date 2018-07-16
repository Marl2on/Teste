<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_para_Abertura_Antecipacao</fullName>
        <description>Email para Abertura de Caso Antecipacao</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SUPPORTCaseResponsewithSolutionSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>Email_para_Abertura_Caso</fullName>
        <description>Email para Abertura de Caso</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SUPPORTSelfServiceResetPasswordSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>Email_para_Abertura_Cessao</fullName>
        <description>Email para Abertura de Caso Cessão de Direitos</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SUPPORTCaseescalationnotificationSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>TW1_Reapresentacao_Cheque_Nao_Possivel</fullName>
        <description>Reapresentação de Cheque Não Possível</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/ContactFollowUpSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>TW1_Reapresentacao_Cheque_pode_ser_reapresentado</fullName>
        <description>Reapresentação de Cheque pode ser reapresentado</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SUPPORTCaseescalationnotificationSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>X12_dias_Provienciar_Certidoes_AF</fullName>
        <description>12 dias - Provienciar Certidoes - AF</description>
        <protected>false</protected>
        <recipients>
            <recipient>TW1_Coordenador_Financiamento</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SUPPORTSelfServiceResetPasswordSAMPLE2</template>
    </alerts>
    <alerts>
        <fullName>X2_dias_Em_atendimento_Aliena_o_fiduciaria</fullName>
        <description>2 dias - Em atendimento - Alienação fiduciaria</description>
        <protected>false</protected>
        <recipients>
            <recipient>TW1_Gestor_Financiamento</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SUPPORTSelfServiceResetPasswordSAMPLE2</template>
    </alerts>
    <alerts>
        <fullName>X4_horas_Informar_Tratativa_AF</fullName>
        <description>4 horas - Informar Tratativa - AF</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SUPPORTSelfServiceResetPasswordSAMPLE2</template>
    </alerts>
    <alerts>
        <fullName>X8_dias_Providenciando_Certidoes_AF</fullName>
        <description>8 dias - Providenciando Certidoes - AF</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SUPPORTSelfServiceResetPasswordSAMPLE2</template>
    </alerts>
    <fieldUpdates>
        <fullName>Altera_Status_Informar_Negativa</fullName>
        <field>Status</field>
        <literalValue>Informar Negativa ao Cliente</literalValue>
        <name>Altera Status - Informar Negativa</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Altera_Status_Negociacao_com_cliente</fullName>
        <field>Status</field>
        <literalValue>Em negociação com o cliente</literalValue>
        <name>Altera Status - Negociação com cliente</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Altera_Status_Providenciando_Minuta</fullName>
        <field>Status</field>
        <literalValue>Providenciando Minuta</literalValue>
        <name>Altera Status - Providenciando Minuta</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Aprovada_pela_Diretoria</fullName>
        <field>Status</field>
        <literalValue>Aprovada pela Diretoria</literalValue>
        <name>Aprovada pela Diretoria</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Aprovado</fullName>
        <field>Status</field>
        <literalValue>Aprovada pela Diretoria</literalValue>
        <name>Aprovado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Aprovado_pela_Gerencia</fullName>
        <field>Status</field>
        <literalValue>Em aprovação da Diretoria</literalValue>
        <name>Aprovado pela Gerencia</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Atualiza_Aprovacao</fullName>
        <field>TW1_Aprovacao_Diretoria__c</field>
        <literalValue>Sim</literalValue>
        <name>Atualiza Aprovação</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Atualiza_Necessita_Diretoria</fullName>
        <field>TW1_Necessita_Aprovacao_Diretoria__c</field>
        <literalValue>Sim</literalValue>
        <name>Atualiza Necessita Diretoria</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Atualiza_Reprovacao</fullName>
        <field>TW1_Aprovacao_Diretoria__c</field>
        <literalValue>Não</literalValue>
        <name>Atualiza Reprovação</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Atualiza_Sinal_SLA_Amarelo</fullName>
        <field>TW1_Sinal_Sla_Total__c</field>
        <literalValue>Amarelo</literalValue>
        <name>Atualiza Sinal SLA Amarelo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Atualiza_Sinal_SLA_Vermelho</fullName>
        <field>TW1_Sinal_Sla_Total__c</field>
        <literalValue>Vermelho</literalValue>
        <name>Atualiza_Sinal_SLA_Vermelho</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Atualiza_Status_Analise_Area</fullName>
        <field>Status</field>
        <literalValue>Em análise da área</literalValue>
        <name>Atualiza Status Analise Area</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Atualiza_descri_o</fullName>
        <field>Description</field>
        <formula>&quot;Workflow acionado depois do Processo de Aprovação&quot;</formula>
        <name>Atualiza descrição</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Atualizar_Campo_AP_Ger_Comercial</fullName>
        <field>TW1_Aprovacao_Gerencia__c</field>
        <literalValue>Sim</literalValue>
        <name>Atualizar Campo AP Ger Com</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Atualizar_Status_Gerais</fullName>
        <field>TW1_Status_Gerais__c</field>
        <formula>IF( 

	ISCHANGED(TW1_Status_Cessao_Direitos__c),
	TEXT(TW1_Status_Cessao_Direitos__c),
	IF( 
		ISCHANGED(TW1_Status_Repasse__c), 
		TEXT(TW1_Status_Repasse__c),
		IF(
                        ISCHANGED( TW1_Status_do_Registro__c ), 
		        TEXT(TW1_Status_do_Registro__c),
		        IF(  
					ISCHANGED(TW1_Status_Rescisao_Judicial__c), 
					TEXT(TW1_Status_Rescisao_Judicial__c),
					IF( 
						ISCHANGED(TW1_Status_Entrega_Chaves__c),
						TEXT(TW1_Status_Entrega_Chaves__c),
						IF( 
							ISCHANGED(Status),
							TEXT(Status), 
							IF(
								AND(
									RecordType.DeveloperName = &quot;TW1_Vip_Line&quot;,
									ISCHANGED(TW1_Status_Portal__c)
									),
								TEXT(TW1_Status_Portal__c),	
								TW1_Status_Gerais__c 
							)
						)
					)
				)
		)
	)
)</formula>
        <name>Atualizar Status Gerais</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Data_AP_Diretoria</fullName>
        <field>TW1_Data_Ap_Rep_Diretoria__c</field>
        <formula>NOW()</formula>
        <name>Data AP Diretoria</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Em_negocia_o_com_Cliente</fullName>
        <field>Status</field>
        <literalValue>Em negociação com o cliente</literalValue>
        <name>Em negociação com Cliente</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Gravar_ID_Cartorio</fullName>
        <field>TW1_ID_Cartorio__c</field>
        <formula>OwnerId</formula>
        <name>Gravar ID Cartório</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Gravar_ID_Consultor_de_Atendimento</fullName>
        <field>TW1_ID_Consultor_de_Atendimento__c</field>
        <formula>OwnerId</formula>
        <name>Gravar ID Consultor de Atendimento</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Gravar_ID_Consultor_de_Relacionamento</fullName>
        <field>TW1_ID_Consultor_de_Relacionamento__c</field>
        <formula>OwnerId</formula>
        <name>Gravar ID Consultor de Relacionamento</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Gravar_ID_Operador_Financiamento</fullName>
        <field>TW1_ID_Operador_Financiamento__c</field>
        <formula>OwnerId</formula>
        <name>Gravar ID Operador de Financiamento</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Gravar_ID_Operador_de_Financiamento</fullName>
        <field>TW1_ID_Operador_Financiamento__c</field>
        <formula>OwnerId</formula>
        <name>Gravar ID Operador de Financiamento</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Muda_Status_Em_Atendimento</fullName>
        <field>Status</field>
        <literalValue>Em atendimento</literalValue>
        <name>Muda Status Em Atendimento</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Necessita_Aprovacao_Diretoria</fullName>
        <field>TW1_Necessita_Aprovacao_Diretoria__c</field>
        <name>Necessita Aprovação da Diretoria</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rep_Ger_Comercial</fullName>
        <field>TW1_Aprovacao_Gerencia__c</field>
        <literalValue>Não</literalValue>
        <name>Rep Ger Comercial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reprovado</fullName>
        <field>Status</field>
        <literalValue>Reprovado pela Gerência</literalValue>
        <name>Reprovado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reprovado_Pela_Diretoria</fullName>
        <field>Status</field>
        <literalValue>Reprovada pela Diretoria</literalValue>
        <name>Reprovado Pela Diretoria</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reprovado_pela_Gerencia</fullName>
        <field>Status</field>
        <literalValue>Reprovado pela Gerência</literalValue>
        <name>Reprovado pela Gerencia</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Aprovacao_Comercial</fullName>
        <field>Status</field>
        <literalValue>Em aprovação Comercial</literalValue>
        <name>Status - Aprovação Comercial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Altera_Status_Aprovada_pela_Dir</fullName>
        <field>Status</field>
        <literalValue>Aprovada pela Diretoria</literalValue>
        <name>Altera Status - Aprovada pela Diretoria</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Altera_Status_Em_Analise_Credito</fullName>
        <field>Status</field>
        <literalValue>Em análise de crédito</literalValue>
        <name>Altera Status Em Análise de Crédito</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Altera_Status_Reprovada_pela_Dir</fullName>
        <field>Status</field>
        <literalValue>Reprovada pela Diretoria</literalValue>
        <name>Altera Status - Reprovada pela Diretoria</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Alterar_Status_Em_Aprovacao_Dir</fullName>
        <field>Status</field>
        <literalValue>Em aprovação da Diretoria</literalValue>
        <name>Alterar Status - Em Aprovação Diretoria</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Apagar_Enviar_Aprovacao</fullName>
        <field>TW1_Enviar_Aprovacao__c</field>
        <literalValue>0</literalValue>
        <name>Apagar Enviar Aprovação</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Atribuir_Fila_Consultor_Relacionamen</fullName>
        <field>OwnerId</field>
        <lookupValue>Tw1_Fila_Consultor_de_Relacionamento</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Atribuir Fila - Consultor de Relacioname</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Atualiza_Campo_Aprovacao_Diretoria_N</fullName>
        <field>TW1_Aprovacao_Diretoria__c</field>
        <literalValue>Não</literalValue>
        <name>Atualiza Campo Aprovação Diretoria - Não</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Atualiza_Campo_Aprovacao_Diretoria_s</fullName>
        <field>TW1_Aprovacao_Diretoria__c</field>
        <literalValue>Sim</literalValue>
        <name>Atualiza Campo Aprovação Diretoria - Sim</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Atualiza_Data_AP_REP_Dir</fullName>
        <field>TW1_Data_Ap_Rep_Diretoria__c</field>
        <formula>NOW()</formula>
        <name>Atualiza Data AP/REP Dir</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Atualiza_Houve_Aprova_o</fullName>
        <field>TW1_Houve_Aprovacao__c</field>
        <literalValue>1</literalValue>
        <name>Atualiza Houve Aprovação</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Atualiza_Isencao_Aprovada</fullName>
        <field>TW1_Isencao_Aprovada__c</field>
        <literalValue>Sim</literalValue>
        <name>Atualiza Isenção Aprovada</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Atualiza_Isencao_Reprovada</fullName>
        <field>TW1_Isencao_Aprovada__c</field>
        <literalValue>Não</literalValue>
        <name>Atualiza Isenção Reprovada</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Atualiza_Propr_Contas_Receber</fullName>
        <field>OwnerId</field>
        <lookupValue>Tw1_Fila_Contas_a_Receber</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Atualiza Proprietário - Contas a Receber</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Atualiza_Proprietario_AnaliseCredito</fullName>
        <field>OwnerId</field>
        <lookupValue>Tw1_Fila_Analise_Credito_FInanciamento</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Atualiza Proprietário - Análise de Crédi</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Atualiza_Proprietario_Cartorio</fullName>
        <field>OwnerId</field>
        <lookupValue>Tw1_Fila_Cartorio</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Atualiza Proprietário - Cartório</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Atualiza_Proprietario_Contratos</fullName>
        <field>OwnerId</field>
        <lookupValue>Tw1_Fila_Contratos_Contrato</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Atualiza Proprietário - Contratos</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Atualiza_Proprietario_Gestor_RC</fullName>
        <field>OwnerId</field>
        <lookupValue>Tw1_Fila_Gestor_de_Relacionamento</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Atualiza Proprietário - Gestor RC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Atualiza_Proprietario_Manutencao</fullName>
        <field>OwnerId</field>
        <lookupValue>Tw1_Fila_Manutencao</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Atualiza Proprietário - Manutenção</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Atualiza_Status_Aprovado_Gerencia</fullName>
        <field>Status</field>
        <literalValue>Aprovado pela Gerência</literalValue>
        <name>Atualiza Status - Aprovado pela Gerência</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Atualiza_Status_Caso_Antecipacao</fullName>
        <field>Status</field>
        <literalValue>Aprovada pela Diretoria</literalValue>
        <name>Atualiza Status - Caso - Antecipacao</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Atualiza_Status_Caso_AntecipacaoNega</fullName>
        <field>Status</field>
        <literalValue>Reprovada pela Diretoria</literalValue>
        <name>Atualiza Status - Caso - Antecipacao</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Atualiza_Status_Reprovado_Gerencia</fullName>
        <field>Status</field>
        <literalValue>Reprovado pela Gerência</literalValue>
        <name>Atualiza Status - Reprovado Gerência</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Bandeira_Verde</fullName>
        <field>TW1_Bandeiras__c</field>
        <literalValue>Verde</literalValue>
        <name>Bandeira Verde</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Bandeira_Vermelha</fullName>
        <field>TW1_Bandeiras__c</field>
        <literalValue>Vermelho</literalValue>
        <name>Bandeira Vermelha</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Bandeiras_Amarela</fullName>
        <field>TW1_Bandeiras__c</field>
        <literalValue>Amarelo</literalValue>
        <name>Bandeiras Amarela</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Condicoes_Reprovadas</fullName>
        <field>TW1_Condicoes_Reprovadas__c</field>
        <literalValue>1</literalValue>
        <name>Condições Reprovadas</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Contratos</fullName>
        <field>OwnerId</field>
        <lookupValue>Tw1_Fila_Analise_Juridica_Contratos</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Fila Contratos Analise Juridica</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Correcao_para_Aprovacao</fullName>
        <field>Status</field>
        <literalValue>Correção para Aprovação</literalValue>
        <name>Correção para Aprovação</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Desativa_Enviar_Aprovacao</fullName>
        <field>TW1_Enviar_Aprovacao__c</field>
        <literalValue>0</literalValue>
        <name>Desativa Enviar Aprovação</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Desmarcar_Enviar_Aprovacao</fullName>
        <field>TW1_Enviar_Aprovacao__c</field>
        <literalValue>0</literalValue>
        <name>Desmarcar Enviar Aprovação</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Fila_Analise_Credito</fullName>
        <field>OwnerId</field>
        <lookupValue>Tw1_Fila_Analise_Credito_FInanciamento</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Fila Análise de Crédito</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Fila_Cartorio</fullName>
        <field>OwnerId</field>
        <lookupValue>Tw1_Fila_Cartorio</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Fila Cartório</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Fila_Consultor_Relacionamento</fullName>
        <field>OwnerId</field>
        <lookupValue>Tw1_Fila_Consultor_de_Relacionamento</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Fila Consultor de Relacionamento</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Fila_Contratos</fullName>
        <field>OwnerId</field>
        <lookupValue>Tw1_Fila_Contratos_Contrato</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Fila Contratos</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Fila_Diretoria_Financeira</fullName>
        <field>OwnerId</field>
        <lookupValue>TW1_Fila_Diretoria_Financeira</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Fila Diretoria Financeira</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Fila_Juridico_Interno</fullName>
        <field>OwnerId</field>
        <lookupValue>Tw1_Fila_Equipe_Juridica_Interna</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Fila Jurídico Interno</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Fila_Operador_Financiamento</fullName>
        <field>OwnerId</field>
        <lookupValue>Tw1_Fila_Operador_Repasse_Financiamento</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Fila Operador Financiamento</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Gravar_ID_Consultor_de_Atendimento</fullName>
        <field>TW1_ID_Consultor_de_Atendimento__c</field>
        <formula>OwnerId</formula>
        <name>Gravar ID do Consultor de Atendimento</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Precisa_Implantar_Negocia_o</fullName>
        <field>TW1_Precisa_Implantar_Negociacao__c</field>
        <literalValue>1</literalValue>
        <name>Precisa Implantar Negociação</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Status_Cessao_Aprovado</fullName>
        <field>TW1_Status_Cessao_Direitos__c</field>
        <literalValue>Confirmando Proposta</literalValue>
        <name>Status Cessão - Aprovado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Status_Cessao_Reprovado</fullName>
        <field>TW1_Status_Cessao_Direitos__c</field>
        <literalValue>Confirmando Proposta</literalValue>
        <name>Status Cessão - Reprovado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TW1_Teste</fullName>
        <field>Description</field>
        <formula>&quot;Teste Atualizar Usuário RC&quot;</formula>
        <name>Teste</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Teste</fullName>
        <field>Description</field>
        <name>Teste</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tw1_Altera_Envia_Area_Nulo</fullName>
        <field>TW1_Enviar_Area_relacionada__c</field>
        <name>Altera Envia Área - Nulo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tw1_Atualiza_Status</fullName>
        <field>Status</field>
        <literalValue>Em análise da área</literalValue>
        <name>Atualiza Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tw1_Caso_Atualiza_o_Cadastral_RC</fullName>
        <description>Quando criar o caso, será atribuída a fila Consultor de Relacionamento - RC</description>
        <field>OwnerId</field>
        <lookupValue>Tw1_Fila_Consultor_de_Relacionamento</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Caso Atualização Cadastral - RC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tw1_Caso_ESRI_Fila_Comercial</fullName>
        <field>OwnerId</field>
        <lookupValue>Tw1_Fila_Equipe_Comercial_Comercial</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Caso ESRI - Fila Comercial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tw1_Caso_ESRI_Fila_Financeiro</fullName>
        <field>OwnerId</field>
        <lookupValue>Tw1_Fila_Gestor_Financeiro</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Caso ESRI - Fila Financeiro</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tw1_Caso_ESRI_Fila_Financiamento</fullName>
        <field>OwnerId</field>
        <lookupValue>Tw1_Fila_Gerente_Financiamento</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Caso ESRI - Fila Financiamento</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tw1_Caso_ESRI_Fila_Jur_dico</fullName>
        <field>OwnerId</field>
        <lookupValue>Tw1_Fila_Diretor_Juridico</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Caso ESRI - Fila Jurídico</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tw1_Caso_ESRI_Fila_Relacionamento</fullName>
        <field>OwnerId</field>
        <lookupValue>Tw1_Fila_Consultor_de_Atendimento</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Caso ESRI - Fila Relacionamento</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tw1_ESRI_Fila_Engenharia</fullName>
        <field>OwnerId</field>
        <lookupValue>Tw1_Fila_Engenharia</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Caso ESRI Fila Engenharia</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tw1_Muda_Status_Analise_area</fullName>
        <field>Status</field>
        <literalValue>Em análise da área</literalValue>
        <name>Muda Status Analise da Área</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Atribuir Caso  - Fila Cartório Rescisão com Venda Nova</fullName>
        <actions>
            <name>TW1_Fila_Cartorio</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Atribuir para fila do Cartório os Casos de Rescisão com Venda Nova do Financiamento e Rescisão com Venda Nova do RC</description>
        <formula>OR(  AND(  RecordType.DeveloperName = &quot;TW1_Rescisao_Venda_Nova_Fin&quot;,  ISCHANGED(Status),  ISPICKVAL(Status, &quot;Providenciando Minuta&quot;),  ISPICKVAL(TW1_Tipo_de_Contrato__c, &quot;Pública&quot;)  ),  AND(      RecordType.DeveloperName = &quot;TW1_Rescisao_Venda_Nova&quot;,      ISCHANGED(Status),      ISPICKVAL(Status, &quot;Providenciando Minuta&quot;),      ISPICKVAL(TW1_Tipo_de_Contrato__c, &quot;Pública&quot;)    )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Atribuir Caso - Atualização Cadastral - Atribuir Fila Relacionamento</fullName>
        <actions>
            <name>TW1_Fila_Consultor_Relacionamento</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Tw1_Muda_Status_Analise_area</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(      RecordType.DeveloperName = &quot;Tw1_Atualizacao_Cadastral_Passiva&quot;,      INCLUDES( TW1_Tipo_Alteracao_Cadastral__c , &quot;Endereco&quot;)     )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Atribuir Caso Manutenção Unidade</fullName>
        <actions>
            <name>TW1_Atualiza_Proprietario_Manutencao</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  RecordType.DeveloperName = &quot;TW1_Manutencao_Unidade&quot;,  ISCHANGED(Status),  ISPICKVAL(Status,&quot;Em análise da área&quot;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Atribuir Caso Manutenção Área Comum - Fila Manutenção</fullName>
        <actions>
            <name>TW1_Atualiza_Proprietario_Manutencao</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  RecordType.DeveloperName = &quot;TW1_Manutencao_Area_Comum&quot;,  ISCHANGED(Status),  ISPICKVAL(Status,&quot;Em análise da área&quot;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Atribuir Caso Rescisão com Venda Nova - Fila Análise de Crédito</fullName>
        <actions>
            <name>TW1_Altera_Status_Em_Analise_Credito</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>TW1_Desmarcar_Enviar_Aprovacao</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>TW1_Fila_Analise_Credito</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(       RecordType.DeveloperName = &quot;TW1_Rescisao_Venda_Nova&quot;,      ISPICKVAL(TW1_Cliente_vai_quitar__c, &quot;Não&quot;),       ISCHANGED(TW1_Enviar_Aprovacao__c),      TW1_Enviar_Aprovacao__c = True    )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Atribuir Caso Rescisão com Venda Nova - Fila Relacionamento</fullName>
        <actions>
            <name>Atualiza_Status_Analise_Area</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>TW1_Fila_Consultor_Relacionamento</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(     ISNEW(),      RecordType.DeveloperName = &quot;TW1_Rescisao_Venda_Nova&quot;    )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Atribuir Caso Rescisão com Venda Nova Fin - Fila Financiamento</fullName>
        <actions>
            <name>Atualiza_Status_Analise_Area</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>TW1_Fila_Operador_Financiamento</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(     ISNEW(),      RecordType.DeveloperName = &quot;TW1_Rescisao_Venda_Nova_Fin&quot;    )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Atribuir Fila - Análise Jurídica Contratos - Rescisão com Venda Nova</fullName>
        <actions>
            <name>TW1_Fila_Contratos</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(  AND(      RecordType.DeveloperName = &quot;TW1_Rescisao_Venda_Nova&quot;,      ISCHANGED(Status),      ISPICKVAL(Status, &quot;Contrato assinado&quot;)    ),  AND(  RecordType.DeveloperName = &quot;TW1_Rescisao_Venda_Nova_Fin&quot;,  ISCHANGED(Status),  ISPICKVAL(Status, &quot;Contrato assinado&quot;)  )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Atribuir Fila - Contratos</fullName>
        <actions>
            <name>TW1_Atualiza_Proprietario_Contratos</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Cessão de Direitos - Rescisão com Venda Nova</description>
        <formula>OR	( 		AND( 				RecordType.DeveloperName = &quot;TW1_Cessao_Direitos&quot;,   				ISCHANGED(Status), 				ISPICKVAL(Status,&quot;Informar Dados de Registro&quot;) 			), 			 		OR	( 				AND( 						RecordType.DeveloperName = &quot;TW1_Rescisao_Venda_Nova&quot;,   						ISCHANGED(Status),   						ISPICKVAL(Status, &quot;Providenciando Minuta&quot;),   						ISPICKVAL(TW1_Tipo_de_Contrato__c, &quot;Particular&quot;)   					)  			), 			 		OR	( 				AND( 						RecordType.DeveloperName = &quot;TW1_Rescisao_Venda_Nova_Fin&quot;,   						ISCHANGED(Status),   						ISPICKVAL(Status, &quot;Providenciando Minuta&quot;),   						ISPICKVAL(TW1_Tipo_de_Contrato__c, &quot;Particular&quot;)   					 					 					)    			) 	)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Atribuir Fila - Gestor RC</fullName>
        <actions>
            <name>TW1_Atualiza_Proprietario_Gestor_RC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Cessão de Direitos</description>
        <formula>AND(  RecordType.DeveloperName = &quot;TW1_Cessao_Direitos&quot;,  ISCHANGED(Status),  ISPICKVAL(Status,&quot;Em Analise - Gestor Relacionamento&quot;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Gravar Status SLA</fullName>
        <actions>
            <name>Atualizar_Status_Gerais</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(  AND(     ISCHANGED(Status), 	RecordType.DeveloperName = &quot;TW1_Alienacao_Fiduciaria&quot;,     OR(ISPICKVAL(Status,&quot;Em atendimento&quot;),        ISPICKVAL(Status,&quot;Análise de crédito Aprovada&quot;),        ISPICKVAL(Status,&quot;Informar Negativa ao Cliente&quot;),        ISPICKVAL(Status,&quot;Atendimento Realizado&quot;),        ISPICKVAL(Status,&quot;Negociação Aprovada&quot;),        ISPICKVAL(Status,&quot;Reprovado pela Gerência&quot;),        ISPICKVAL(Status,&quot;Aprovado pela Gerência&quot;),        ISPICKVAL(Status,&quot;Em Tratativa Financeira&quot;),        ISPICKVAL(Status,&quot;Providenciando Certidões&quot;),        ISPICKVAL(Status,&quot;Aguardando assinatura do cliente&quot;),        ISPICKVAL(Status,&quot;Pendência Documental&quot;),        ISPICKVAL(Status,&quot;Analisando Documentos&quot;),        ISPICKVAL(Status,&quot;Em aprovação da Diretoria&quot;),        ISPICKVAL(Status,&quot;Contrato Assinado&quot;)       ) 	), 	AND(     ISCHANGED(Status), 	RecordType.DeveloperName = &quot;TW1_Antecipacao&quot;,     NOT(OR(ISPICKVAL(Status,&quot;Em atendimento&quot;),        ISPICKVAL(Status,&quot;Reprovada pela Diretoria&quot;),        ISPICKVAL(Status,&quot;Aprovada pela Diretoria&quot;)       )) 	),        AND(     ISCHANGED(Status), 	RecordType.DeveloperName = &quot;TW1_Conferencia_de_Contratos&quot;,     NOT(OR(ISPICKVAL(Status,&quot;Em Tratativa Financeira&quot;),            ISPICKVAL(Status,&quot;Aprovada pela Diretoria&quot;)       )) 	), AND(  ISCHANGED(Status),  RecordType.DeveloperName = &quot;TW1_Rescisao&quot;,  NOT(OR(ISPICKVAL(Status,&quot;Aprovada pela Diretoria&quot;),  ISPICKVAL(Status,&quot;Pendência contratualz&quot;)    ))   ),AND(     ISCHANGED(Status), 	RecordType.DeveloperName = &quot;TW1_Conferencia_de_Contratos_de_Venda&quot;,     NOT(OR(ISPICKVAL(Status,&quot;Aguardando assinatura do cliente&quot;),            ISPICKVAL(Status,&quot;Aprovada pela Diretoria&quot;)       )) 	),        AND(     ISCHANGED(TW1_Status_Cessao_Direitos__c), 	RecordType.DeveloperName = &quot;TW1_Cessao_Direitos&quot;,     NOT(OR(TEXT(TW1_Status_Cessao_Direitos__c) = &quot;Aguardando assinatura do cliente&quot;,            TEXT(TW1_Status_Cessao_Direitos__c) = &quot;Aprovada pela Diretoria&quot;       )) 	),       AND(         ISCHANGED(Status), 	RecordType.DeveloperName = &quot;TW1_Conferencia_de_Contratos_AF&quot;,         NOT(ISPICKVAL(Status,&quot;Em Tratativa Financeira&quot;)                           )          	),         AND(         ISCHANGED(TW1_Status_do_Registro__c), 	RecordType.DeveloperName = &quot;TW1_Conferencia_de_Contratos_AF&quot;,         NOT(OR(ISPICKVAL(TW1_Status_do_Registro__c,&quot;Aguardando conta para depósito&quot;),                ISPICKVAL(TW1_Status_do_Registro__c,&quot;Pendência contratualz&quot;)                              ))            	), 	AND(         ISCHANGED(Status), 	RecordType.DeveloperName = &quot;TW1_Permuta&quot;,         NOT(OR(ISPICKVAL(Status,&quot;Novo&quot;),                ISPICKVAL(Status,&quot;Em atendimento&quot;),                ISPICKVAL(Status,&quot;Aguardando documentação de crédito&quot;),                ISPICKVAL(Status,&quot;Em análise contratual&quot;)                              ))            	),     AND(OR(ISCHANGED( TW1_Status_Cessao_Direitos__c ), ISCHANGED( TW1_Status_Cessao_Direitos__c ), ISCHANGED( TW1_Status_Rescisao_Judicial__c ), ISCHANGED( TW1_Status_Entrega_Chaves__c ), AND(RecordType.DeveloperName = &quot;TW1_Vip_Line&quot;, ISCHANGED(TW1_Status_Portal__c)), ISCHANGED( Status )),         NOT(OR(RecordType.DeveloperName = &quot;TW1_Alienacao_Fiduciaria&quot;,         RecordType.DeveloperName = &quot;TW1_Antecipacao&quot;,         RecordType.DeveloperName = &quot;TW1_Conferencia_de_Contratos&quot;,         RecordType.DeveloperName = &quot;TW1_Conferencia_de_Contratos_de_Venda&quot;,         RecordType.DeveloperName = &quot;TW1_Conferencia_de_Contratos_AF&quot;, 		RecordType.DeveloperName = &quot;TW1_Permuta&quot;,         RecordType.DeveloperName = &quot;TW1_Cessao_Direitos&quot;))) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
