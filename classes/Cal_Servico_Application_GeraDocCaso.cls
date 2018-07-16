// Objeto responsável por buscar os arquivos base64 do UAU e salvar como Attachment no caso.
public class Cal_Servico_Application_GeraDocCaso {
	
    Cal_SA_UAU_GerarDocumentos gerarDocumentosServiceAgent = new Cal_SA_UAU_GerarDocumentos();
    
    Cal_Servico_Repo_AggregateLogIntegracao logIntegracaoRepository = new Cal_Servico_Repo_AggregateLogIntegracao();
   
    Cal_Servico_Repo_AggregateCase casoRepository = new Cal_Servico_Repo_AggregateCase();
    
    Cal_Servico_Repo_AggregateProduct productRepository = new Cal_Servico_Repo_AggregateProduct();
    
    Cal_Servico_Repo_AggregateAttachment attachmentRepository = new Cal_Servico_Repo_AggregateAttachment();
    
    // Gera o extrato financeiro pelo ID do caso
    public void GerarExtratoFinanceiro(string idCaso)
    {               
        // Buscar o caso
        System.debug('Buscando caso com o id: ' + idCaso);
        Case caso = casoRepository.GetCaseById(idCaso);
        System.debug('Caso encontrado: ' + caso);
        
        /// Caso não exista um caso com id inválido, então retorna erro para ser tratado.
        if(caso == null)
        	throw new Cal_Cls_Infra_Exception('Não foi encontrado nenhum resultado com o ID de caso igual a ' + idCaso);
           
        // Buscar informações de número de venda, empresa e obra na unidade
        System.debug('Selecionando produto');
        Product2 produto = productRepository.GetProductById(caso.TW1_Unidade__c);
        System.debug('Produto selecionado ' + produto);
        
        System.debug('Consultando arquivo base 64 para gerar PDF');
        system.debug('Numero de venda: ' + produto.TW1_Numero_Venda__c);
        system.debug('Numero Empreendimento: ' + produto.TW1_Codigo_Empreendimento_UAU__c);
        system.debug('Numero Empresa: ' + produto.TW1_Codigo_Empresa_UAU__c);
        string conteudoBase64 = gerarDocumentosServiceAgent.GetBase64ExtratoFinanceiro(integer.valueof(produto.TW1_Numero_Venda__c), produto.TW1_Codigo_Empreendimento_UAU__c, integer.valueof(produto.TW1_Codigo_Empresa_UAU__c));
        System.debug('StringRetornada: ' + conteudoBase64);
        
        System.debug('Criando anexo');
        Attachment anexo = MontarAttach('ExtratoFinanceira', conteudoBase64, idCaso, produto.TW1_Numero_Venda__c);
      	System.debug('Anexo criado: ' + anexo);
        
        System.debug('Salvando anexo');
        attachmentRepository.Incluir(anexo);
        System.debug('Anexo salvo');
	}
    
    // Gera o extrato financeiro pelo ID do caso
    public void GerarIR(string idCaso)
    {                
        // Buscar o caso
        System.debug('Buscando caso com o id: ' + idCaso);
        Case caso = casoRepository.GetCaseById(idCaso);
        System.debug('Caso encontrado: ' + caso);
        
        /// Caso não exista um caso com id inválido, então retorna erro para ser tratado.
        if(caso == null)
        	throw new Cal_Cls_Infra_Exception('Não foi encontrado nenhum resultado com o ID de caso igual a ' + idCaso);
           
        // Buscar informações de número de venda, empresa e obra na unidade
        System.debug('Selecionando produto');
        Product2 produto = productRepository.GetProductById(caso.TW1_Unidade__c);
        System.debug('Produto selecionado ' + produto);
        
        System.debug('Consultando arquivo base 64 para gerar PDF');
        system.debug('Numero de venda: ' + produto.TW1_Numero_Venda__c);
        system.debug('Numero Empreendimento: ' + produto.TW1_Codigo_Empreendimento_UAU__c);
        system.debug('Numero Empresa: ' + produto.TW1_Codigo_Empresa_UAU__c);
        string conteudoBase64 = gerarDocumentosServiceAgent.GetBase64InformeRendimentos(integer.valueof(produto.TW1_Numero_Venda__c), produto.TW1_Codigo_Empreendimento_UAU__c, integer.valueof(produto.TW1_Codigo_Empresa_UAU__c));
        System.debug('StringRetornada: ' + conteudoBase64);
        
        System.debug('Criando anexo');
        Attachment anexo = MontarAttach('InformeRendimentos', conteudoBase64, idCaso, produto.TW1_Numero_Venda__c);
      	System.debug('Anexo criado: ' + anexo);
        
        System.debug('Salvando anexo');
        attachmentRepository.Incluir(anexo);
        System.debug('Anexo salvo');
	}
    
    public List<Cal_SA_UAU_GerarDocumentos.BoletosDto> GetListaBoletosPorUnidade(string IdCaso)
    {
       	// Buscar o caso
        System.debug('Buscando caso com o id: ' + idCaso);
        Case caso = casoRepository.GetCaseById(idCaso);
        System.debug('Caso encontrado: ' + caso);
        
        /// Caso não exista um caso com id inválido, então retorna erro para ser tratado.
        if(caso == null)
        	throw new Cal_Cls_Infra_Exception('Não foi encontrado nenhum resultado com o ID de caso igual a ' + idCaso);
           
        // Buscar informações de número de venda, empresa e obra na unidade
        System.debug('Selecionando produto');
        Product2 produto = productRepository.GetProductById(caso.TW1_Unidade__c);
        System.debug('Produto selecionado ' + produto);
            
        System.debug('Código pessoa ' + produto.TW1_Codigo_Conta_UAU__c);
        return gerarDocumentosServiceAgent.GetListaBoletosPorUnidade(integer.valueOf(produto.TW1_Codigo_Conta_UAU__c), integer.valueOf(produto.TW1_Codigo_Empresa_UAU__c), produto.TW1_Codigo_Empreendimento_UAU__c, integer.valueOf(produto.TW1_Numero_Venda__c), false);
    }
       
    // Gera o extrato financeiro pelo ID do caso
    public void GerarBoleto(string IdCaso, string banco, string seuNumero)
    {        
        // Buscar o caso
        System.debug('Buscando caso com o id: ' + idCaso);
        Case caso = casoRepository.GetCaseById(idCaso);
        System.debug('Caso encontrado: ' + caso);
        
        /// Caso não exista um caso com id inválido, então retorna erro para ser tratado.
        if(caso == null)
        	throw new Cal_Cls_Infra_Exception('Não foi encontrado nenhum resultado com o ID de caso igual a ' + idCaso);
              
        System.debug('Consultando arquivo base 64 para gerar PDF');
        system.debug('Banco: ' + banco);
        system.debug('Seu número do boleto: ' + seuNumero);
        string conteudoBase64 = gerarDocumentosServiceAgent.GetBase64EmitirBoleto(banco, seuNumero);
        System.debug('StringRetornada: ' + conteudoBase64);
        
        System.debug('Criando anexo');
        Attachment anexo = MontarAttach('EmissaoBoleto', conteudoBase64, idCaso, seuNumero);
      	System.debug('Anexo criado: ' + anexo);
        
        System.debug('Salvando anexo');
        attachmentRepository.Incluir(anexo);
        System.debug('Anexo salvo');
	}
    
    
    private Attachment MontarAttach(string nomeArquivo, string conteudoBase64, string idCaso, string complemento)
    {
        Attachment attach = new Attachment();
        attach.contentType = 'application/pdf';
        attach.name = nomeArquivo + '_' + complemento + '.pdf';
        attach.parentId = idCaso;
        attach.body = EncodingUtil.base64Decode(conteudoBase64);
        return attach;
    }
    
  
}