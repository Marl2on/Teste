/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData=true)
private class Cal_SA_UAU_Empreendimento_Test {

	static Cal_Servico_Repo_AggregateLogIntegracao logIntegracaoRepository = new Cal_Servico_Repo_AggregateLogIntegracao();
    static Cal_SA_UAU_Empreendimento empreendimentoServiceAgent = new Cal_SA_UAU_Empreendimento();
    
    static private string idLogIntegracao;
    
    static private void init()
    {
    	Log_Integracao__c log = new Log_Integracao__c();
    	log.Nome_integracao__c = 'Carga empreendimento';
    	log.Descricao__c = 'Processo carga de empreendimento iniciado com sucesso.';
    	idLogIntegracao = logIntegracaoRepository.IncluirLogIntegracao(log).Id;
    	System.debug('Log de integração criado com sucesso com o id: ' + idLogIntegracao);
    	
    	Test.startTest();
    	Test.setMock(HttpCalloutMock.class, new Cal_Cls_MockResponseGenerator());
    	Test.stopTest();
    }
        
    static testMethod void TesteChamadaEmpreendimento() {
       	System.debug('Inicializando contexto para teste');
       	
       	init();
                
        try
        {
        	System.debug('inciando classe de service agente');
        	Cal_SA_UAU_Empreendimento.EmpreendimentoDto empreendimento = empreendimentoServiceAgent.GetEmpreendimento(idLogIntegracao,'1994','1');
        }
        catch(Exception ex)
        {
        	System.debug('Erroe: ' + ex);
        	system.assert(false);
        }        
    }
    
    static testMethod void TesteMontarDtoEmpreendimento() 
    {
        Cal_SA_UAU_Empreendimento.EmpreendimentoDto empreendimento = new Cal_SA_UAU_Empreendimento.EmpreendimentoDto();
        empreendimento.idobra = '1';
        empreendimento.descricao = 'Teste de emprendimento';
        empreendimento.Empresa = new Cal_SA_UAU_Empreendimento.Empresa();
        
        empreendimento.Empresa.idempresa =0;
	    empreendimento.Empresa.razaosocial ='';
	    empreendimento.Empresa.cnpj ='';
	    empreendimento.Empresa.inscricaoestadual ='';
	    empreendimento.Empresa.inscricaomunicipal ='';
	    empreendimento.Empresa.endereco ='';
	    empreendimento.Empresa.bairro ='';
	    empreendimento.Empresa.cidade ='';
	    empreendimento.Empresa.uf ='';
	    empreendimento.Empresa.cep ='';
	    empreendimento.Empresa.numero ='';
	    empreendimento.Empresa.telefone ='';
	    empreendimento.Empresa.email ='';
	
        empreendimento.produto = new List<Cal_SA_UAU_Empreendimento.Produto>();
        Cal_SA_UAU_Empreendimento.Produto produto = new Cal_SA_UAU_Empreendimento.Produto();
        produto.idproduto  = 0;
	    produto.descricao = '';
        
	    produto.personalizacoes  = new List<Cal_SA_UAU_Empreendimento.Personalizaco>();
        Cal_SA_UAU_Empreendimento.Personalizaco personalizacao = new Cal_SA_UAU_Empreendimento.Personalizaco();
        personalizacao.idpersonalizacao = 0;
        personalizacao.identificador = '';
        personalizacao.status = '';
        personalizacao.bloco = new Cal_SA_UAU_Empreendimento.Bloco();
        personalizacao.bloco.idbloco = 0;
        personalizacao.bloco.codigo = '';
        personalizacao.bloco.descricao = '';
            
        produto.personalizacoes.add(personalizacao);
        empreendimento.produto.add(produto);
    }
    
    static testMethod void TesteMontarDtoConsultaSaldo()
    {
        Cal_SA_UAU_Empreendimento.SaldosDeUmaUnidadeDto saldoDto = new Cal_SA_UAU_Empreendimento.SaldosDeUmaUnidadeDto();
        saldoDto.idunidade = ID.valueOf('01t0v000000h1RW');
        saldoDto.saldodevedor = 12500.00;
        saldoDto.saldopago = 12500.00;
        saldoDto.saldoematraso = 12500.00;
        saldoDto.valorvenda = 12500.00;
    }
           
    static testMethod void TesteConsultaSaldoAberto()
    {
        Test.startTest();
    	Test.setMock(HttpCalloutMock.class, new Cal_Cls_MockResponseGenerator());
    	Test.stopTest();
        
        Cal_SA_UAU_Empreendimento.SaldosDeUmaUnidadeDto saldo = empreendimentoServiceAgent.GetSaldoAberto(ID.valueOf('01t0v000000h1RW'), '34', 'R3467', 560);
                
        if(saldo.idunidade == ID.valueOf('01t0v000000h1RW') && saldo.saldodevedor == 300000 && saldo.saldopago == 100000 && saldo.saldoematraso == 0 && saldo.valorvenda == 400000)
			system.assert(true);
        else
            system.assert(false);
    }
}