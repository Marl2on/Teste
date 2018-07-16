public class Cal_Servico_Repo_AggregatePessoa {
	
   public Account GetAccountById(string accountId)
   {
   		List<Account> contas = [SELECT id,
            Tw1_Codigo_Cliente_UAU__c,
            Name,
            Tw1_N_Documento__c,
            Tw1_E_mail__c,
            Tw1_E_mail_Alternativo__c,
            Tw1_Celular__c,
            Tw1_Data_de_Nascimento__c,
            recordtype.Name,
            BillingStreet,
            TW1_Complemento_Endereco_Cobranca__c,	
            BillingCity,
            BillingState,
            BillingPostalCode,
            BillingCountry,
            Tw1_CEP__c,
			Tw1_Estado__c,
            Tw1_Identidade__c,
            Tw1_Profissao__c,
            Tw1_Sexo__c,
            Tw1_Estado_Civil__c,
            Tw1_Naturalidade__c,
            Tw1_Nome_Fantasia__c,
            Tw1_Inscricao_Municipal__c,
            Tw1_Inscricao_Estadual__c,
            ShippingStreet,
            ShippingState,
            ShippingCity,
            ShippingPostalCode,
            TW1_Nacionalidade_st__c,
            TW1_Profissao_UAU__c
            FROM Account where Id = :accountId];
       
        if(contas.size() < 1)
            return null;
        else
            return contas[0];
   } 
   
   public Account GetAccountByCodigoUau(string codigoUau)
   {
   		List<Account> contas = [SELECT id,
            Tw1_Codigo_Cliente_UAU__c,
            Name,
            Tw1_N_Documento__c,
            Tw1_E_mail__c,
            Tw1_E_mail_Alternativo__c,
            Tw1_Celular__c,
            Tw1_Data_de_Nascimento__c,
            recordtype.Name,
            BillingStreet,
            TW1_Complemento_Endereco_Cobranca__c,	
            BillingCity,
            BillingState,
            BillingPostalCode,
            BillingCountry,
            Tw1_CEP__c,
			Tw1_Estado__c,
            Tw1_Identidade__c,
            Tw1_Profissao__c,
            Tw1_Sexo__c,
            Tw1_Estado_Civil__c,
            Tw1_Naturalidade__c,
            Tw1_Nome_Fantasia__c,
            Tw1_Inscricao_Municipal__c,
            Tw1_Inscricao_Estadual__c,
            ShippingStreet,
            ShippingState,
            ShippingCity,
            ShippingPostalCode,
            TW1_Nacionalidade_st__c,
            TW1_Profissao_UAU__c
            FROM Account where Tw1_Codigo_Cliente_UAU__c = :codigoUau];
       
        if(contas.size() < 1)
            return null;
        else
            return contas[0];
   } 
    
   public List<Tw1_Dados_de_Contato_adicionais__c> GetContatosAdcionais(ID AccountId)
   {
       return [SELECT 
               id, 
               Tw1_Account__c, 
               Tw1_Contact__c,
               recordtype.name, 
               Tw1_Contato__c 
               FROM Tw1_Dados_de_Contato_adicionais__c
               WHERE Tw1_Account__c = :AccountId];
   }
    
   public Account GetAccountByCPF(string cpf)
   {
   		List<Account> contas = [
            SELECT id,
            Tw1_Codigo_Cliente_UAU__c,
            Name,
            Tw1_N_Documento__c,
            Tw1_E_mail__c,
            Tw1_E_mail_Alternativo__c,
            Tw1_Celular__c,
            Tw1_Data_de_Nascimento__c,
            recordtype.Name,
            BillingStreet,
            TW1_Complemento_Endereco_Cobranca__c,	
            BillingCity,
            BillingState,
            BillingPostalCode,
            BillingCountry,
            Tw1_CEP__c,
			Tw1_Estado__c,
            Tw1_Identidade__c,
            Tw1_Profissao__c,
            Tw1_Sexo__c,
            Tw1_Estado_Civil__c,
            Tw1_Naturalidade__c,
            Tw1_Nome_Fantasia__c,
            Tw1_Inscricao_Municipal__c,
            Tw1_Inscricao_Estadual__c,
            ShippingStreet,
            ShippingState,
            ShippingCity,
            ShippingPostalCode,
            TW1_Nacionalidade_st__c         
            FROM Account 
            where Tw1_N_Documento__c = :cpf];
        if(contas.size() < 1)
            return null;
        else
            return contas[0];
   } 
    
    public List<Account> GetListaClientesNaoAtualizadosEmPeriodoDias(integer tempoNaoAtualizado)
    {
        return [SELECT id FROM Account Where LastModifiedDate >= :DateTime.now().addDays(-tempoNaoAtualizado) LIMIT 1000];
    }
    
    public void Modify(Account pessoa)
    {
        update pessoa;
    }
    
    public TW1_Projurid__c GetProcessoPorNumeroEConta(Id accountId, string numeroProcesso)
    {
        List<TW1_Projurid__c> retorno = [SELECT id FROM TW1_Projurid__c WHERE TW1_Conta__c =:accountId AND TW1_Numero_Processo__c = :numeroProcesso];
   		
        if(retorno.size() < 1)
            return null;
        else
            return retorno[0];
    }
    
    public void IncluirProcessos(List<TW1_Projurid__c> listaProcessos)
    {
        UpSert listaProcessos;
    }
    
    public RecordType GetRecordTypePessoaFisica()
    {
        return [Select Id,Name FROM RecordType Where name = 'Pessoa Fisica'];
    }
    
    public RecordType GetRecordTypePessoaJuridica()
    {
        return [Select Id,Name FROM RecordType Where name = 'Pessoa Jurídica'];
    }
    
    public RecordType GetTipoContatoAdcionalByTipoTelefoneUAU(string tipoTelefoneUAU)
    {
        if(tipoTelefoneUAU == '0')
            return [Select Id,Name FROM RecordType Where name = 'Telefone'];
        else if(tipoTelefoneUAU == '1')
        	return [Select Id,Name FROM RecordType Where name = 'Comercial'];
        else if(tipoTelefoneUAU == '2')
            return [Select Id,Name FROM RecordType Where name = 'Celular'];
        else if(tipoTelefoneUAU == '4')
            return [Select Id,Name FROM RecordType Where name = 'Fax'];
        
        throw new Cal_Cls_Infra_Exception('Não foi encontrado o tipo de telefone com o tipo do UAU ' + tipoTelefoneUAU);
    }
    
    public List<Tw1_Dados_de_Contato_adicionais__c> GetContatoAdcioinaisByAccountID(string AccountId)
    {
        return [SELECT id FROM Tw1_Dados_de_Contato_adicionais__c WHERE Tw1_Account__c =:AccountId];
    }
}