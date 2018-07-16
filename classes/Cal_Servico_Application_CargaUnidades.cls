/// Classe responsável para realizar carga de unidade, Empreendimento e bloco
public with sharing class Cal_Servico_Application_CargaUnidades {
    
    static Cal_Servico_Repo_AggregateLogIntegracao logIntegracaoRepository = new Cal_Servico_Repo_AggregateLogIntegracao();
    
    static Cal_SA_UAU_Empreendimento empreendimentoServiceAgent = new Cal_SA_UAU_Empreendimento();
    
    static Cal_Servico_Repo_AggregateProduct produtosRepository = new Cal_Servico_Repo_AggregateProduct();
    
    static Cal_SA_UAU_Unidade unidadesServiceAgent = new Cal_SA_UAU_Unidade();
    
    /// Busca lista de log de integração pelo nome da integração
    public  List<Log_Integracao__c> GetListLogIntegracao(string nomeIntegracao)
    {
        system.debug('Carregando lista de log de integração para a integração: ' + nomeIntegracao);
        return logIntegracaoRepository.GetListLogIntegracao(nomeIntegracao);
    }
    
    /// Inicia um novo processo de carga de empreendimentos e unidade
    public void IniciarNovoProcesso(string empresa, string obra)
    {
        /// Incluíndo novo log de processamento
        system.debug('Inserindo um novo log de integração');
        Log_Integracao__c logProcesso = IncluirLog();
        system.debug('Log de integração inserido: ' + logProcesso);
        system.debug('Executando chamada async da carga de empreendimentos.');
        ExecutaCarga(logProcesso.Id, empresa, obra);    	    	
    }
    
    /// Incluir novo log de integração 
    private Log_Integracao__c IncluirLog()
    {
        Log_Integracao__c log = new Log_Integracao__c();
        log.Nome_integracao__c = 'Carga empreendimento';
        log.Descricao__c = 'Processo carga de empreendimento iniciado com sucesso.';
        return logIntegracaoRepository.IncluirLogIntegracao(log);
    }
    
    public Boolean ExisteProcessoEmAberto()
    {
        system.debug('Verificando se existe alguma integração de empeendimentos em andamento.');
        List<Log_Integracao__c> lista =  logIntegracaoRepository.GetListLogIntegracaoEmProcesso('Carga empreendimento');
        system.debug('Existe: ' + (lista.size() > 0 ));
        return (lista.size() > 0 );
    }
    
    @future(callout=true)
    public static void ExecutaCarga(String idLogProcesso, string codEmpresa, string obra)
    {
        system.debug('Selecionando LOG de integração pelo id: ' + idLogProcesso );
        Log_Integracao__c log = logIntegracaoRepository.GetLogIntegracaoById(idLogProcesso);
        system.debug('Log selecionado: ' + log );
        
        try
        {
            system.debug('Executando chamada ao serviceagent de empreendimentos');
            Cal_SA_UAU_Empreendimento.EmpreendimentoDto empreendimentoDto = empreendimentoServiceAgent.GetEmpreendimento(idLogProcesso,codEmpresa,obra);
            system.debug('Retorno de empreendimentos: ' + empreendimentoDto);
            
            /// Realizar MAP do empreendimento para os objetos do Sales
            system.debug('Montando empresa');
            TW1_Empresa__c empresa = MontarEmpresa(empreendimentoDto);
            system.debug('Inserindo ou atualizando empresa: ' + empresa);
            produtosRepository.InserirAtualizarEmpresa(empresa);
            
            system.debug('Montando empreendimento');
            TW1_Empreendimento__c empreendimento = MontarEmpreendimento(empreendimentoDto, empresa.Id);
            system.debug('Inserindo ou atualizando empreendimento: ' + empreendimento);
            produtosRepository.InserirAtualizarEmpreendimento(empreendimento);
            
            /// Percorrendo todos os blocos do empreendimento
            for (Cal_SA_UAU_Empreendimento.Produto blocoDto : empreendimentoDto.produto) {
                
                system.debug('Montando bloco: ' + blocoDto.descricao);
                TW1_Bloco__c bloco = MontarBloco(blocoDto, empreendimento.Id);
                bloco.TW1_Codigo_Obra_UAU__c = obra;
                system.debug('Inserindo ou atualizando bloco');
                produtosRepository.InserirAtualizarBloco(bloco);
                
                Map<string, Product2> unidades = produtosRepository.GelListaUnidadesPorBloco(bloco.Id);
                
                List<Product2> listaInserir = new List<Product2>();
                List<Product2> listaAtualizar = new List<Product2>();
                
                /// Percorrendo todas as unidades de um bloco.
                for(Cal_SA_UAU_Empreendimento.Personalizaco unidadeDto : blocoDto.personalizacoes)
                {
                    system.debug('Montando unidade: ' + unidadeDto.identificador);
                    Product2 unidade = MontarUnidade(unidadeDto, bloco);
                    system.debug('Inserindo ou atualizando unidade');
                    
                    if(unidades.get(unidade.Name) == null)
                        listaInserir.add(unidade);
                    else
                    {   
                        unidade.Id = unidades.get(unidade.Name).Id;
                        listaAtualizar.add(unidade);
                    }
                }
                
                produtosRepository.AtualizarRange(listaAtualizar);
                produtosRepository.IncluirRange(listaInserir);
            }
            
            system.debug('Fechando log de processamento');
            logIntegracaoRepository.FecharLogIntegracao(log, true);
            system.debug('Log fechado com sucesso');
        }
        catch(Exception ex)
        {
            system.debug('Salvando msg de erro em log de processamento.');
            log.Descricao__c = ex.getMessage();
            system.debug('MSG de erro a ser salva: ' + log.Descricao__c );
            system.debug('Fechando log de processamento');
            if(!Test.isRunningTest())
                logIntegracaoRepository.FecharLogIntegracao(log, false);
            system.debug('Log fechado com erro');
        }    	
    }
    
    /// Montar objeto empresa
    private static TW1_Empresa__c MontarEmpresa(Cal_SA_UAU_Empreendimento.EmpreendimentoDto empreendimento)
    {
        TW1_Empresa__c empresa = new TW1_Empresa__c();
        empresa.TW1_cod_empresa_UAU__c = string.valueOf(empreendimento.Empresa.idempresa);
        empresa.Name = empreendimento.Empresa.razaosocial;
        empresa.TW1_CNPJ__c = empreendimento.Empresa.cnpj;
        empresa.TW1_Inscricao_Estadual__c = empreendimento.Empresa.inscricaoestadual;
        empresa.TW1_IM__c = empreendimento.Empresa.inscricaomunicipal;
        empresa.TW1_Endereco__c = empreendimento.Empresa.endereco;
        empresa.TW1_Bairro__c = empreendimento.Empresa.bairro;
        empresa.TW1_Cidade__c = empreendimento.Empresa.cidade;
        empresa.TW1_Estado__c = empreendimento.Empresa.uf;
        empresa.TW1_CEP__c = empreendimento.Empresa.cep;
        empresa.TW1_Complemento__c = empreendimento.Empresa.numero;
        empresa.TW1_Telefone__c = empreendimento.Empresa.telefone;
        empresa.TW1_E_mail__c = empreendimento.Empresa.email;
        return empresa;
    }
    
    /// Montar objeto emprrendimento
    private static TW1_Empreendimento__c MontarEmpreendimento(Cal_SA_UAU_Empreendimento.EmpreendimentoDto empreendimentoDto, Id idEmpresa)
    {
        TW1_Empreendimento__c empreendimento = new TW1_Empreendimento__c();
        empreendimento.TW1_Codigo_Obra_UAU__c =  empreendimentoDto.idobra;
        empreendimento.Name = empreendimentoDto.descricao;
        empreendimento.TW1_Empresa__c = idEmpresa;
        return empreendimento;
    }
    
    /// Montar o bloco para ser inserido ou atualizado 
    private static TW1_Bloco__c MontarBloco(Cal_SA_UAU_Empreendimento.Produto produto, Id idEmpreendimento)
    {
        TW1_Bloco__c bloco = new TW1_Bloco__c();
        bloco.TW1_Codigo_Produto_UAU__c = string.valueOf(produto.idproduto);
        bloco.Name = produto.descricao;
        
        if(produto.personalizacoes.size() > 0)
        {    
            bloco.TW1_Codigo_Bloco_UAU__c = produto.personalizacoes[0].bloco.codigo;
            bloco.TW1_ID_Bloco_UAU__c = string.valueOf(produto.personalizacoes[0].bloco.idbloco);
            bloco.TW1_Descricao_Bloco_UAU__c = produto.personalizacoes[0].bloco.descricao;
        }
        
        bloco.TW1_Empreendimento__c = idEmpreendimento;
        return bloco;
    }        
    
    /// Montar a unidade por um objeto personalização
    private static Product2 MontarUnidade(Cal_SA_UAU_Empreendimento.Personalizaco unidadeDto, TW1_Bloco__c bloco)
    {
        Product2 unidade = new Product2();
        unidade.TW1_Bloco__c = bloco.Id;
        unidade.TW1_Codigo_Personalizacao_UAU__c = string.valueOf(unidadeDto.idpersonalizacao);
        unidade.TW1_Identificador_UAU__c = unidadeDto.identificador;
        unidade.Tw1_Status__c = MapStatusUnidade(unidadeDto.status);
        unidade.TW1_Unidade__c = unidadeDto.identificador;
        unidade.Name = bloco.Name + ' - ' + unidadeDto.identificador;
        return unidade;
    }
    
    private static string MapStatusUnidade(string statusUau)
    {
        if(statusUau == '0')
            return 'Disponível';
        else if (statusUau == '1')
            return 'Vendido';
        else if (statusUau == '2')
            return 'Reservado';
        else if (statusUau == '3')
            return 'Proposta';
        else if (statusUau == '4')
            return 'Quitado';
        else if (statusUau == '5')
            return 'Escriturado';
        else if (statusUau == '6')
            return 'Em venda';
        else if (statusUau == '7')
            return 'Suspenso';
        else if (statusUau == '8')
            return 'Fora de venda';
        else if (statusUau == '9')
            return 'Em acerto';
        else if (statusUau == '10')
            return 'Dação';
        
        throw new Cal_Cls_Infra_Exception('Nenhum status foi mapeado para o satus UAU: ' + statusUau);
    }
    
    /// Método que executa carga dos saldos em aberto das unidades com contrato ativo
    @future(callout = true)
    public static void ExecutaCargaSaldosAbertosEmUnidades()
    {        
        // Listar todas as unidades com contrato ativos
        system.debug('Buscando lista de unidades a serem processadas');
        Map<Id,Product2> unidades = produtosRepository.GetListaUnidadesContratosAtivos();
        system.debug('Lista de unidades ' + unidades);
        
        /// Lista de saldos em aberto
        system.debug('Montando lista de saldos');
        List<Cal_SA_UAU_Empreendimento.SaldosDeUmaUnidadeDto> listaSaldos = new List<Cal_SA_UAU_Empreendimento.SaldosDeUmaUnidadeDto>();
        
        system.debug('Percorrendo lista de unidades para consultar saldos');
        for (ID unidadeId: unidades.keyset()) {
            system.debug('Selecionando unidade em memória para consulta');
            Product2  unidade = unidades.get(unidadeId);
            system.debug('Unidade selecionada ' + unidade);
            system.debug('Consultando saldo em serviço do UAU');
            Cal_SA_UAU_Empreendimento.SaldosDeUmaUnidadeDto saldo = empreendimentoServiceAgent.GetSaldoAberto(unidadeId, unidade.TW1_Codigo_Empresa_UAU__c, unidade.TW1_Codigo_Empreendimento_UAU__c,Integer.valueOf(unidade.TW1_Numero_Venda__c));
            system.debug('Saldo consultado ' + saldo);
            system.debug('Incluindo saldo na lista');
            listaSaldos.add(saldo);
        }
        
        system.debug('Inicio de atualização dos saldos');
        /// Atualizando saldos nas unidades
        for(Cal_SA_UAU_Empreendimento.SaldosDeUmaUnidadeDto saldo: listaSaldos)
        {
            Product2  unidade = unidades.get(saldo.idunidade);
            system.debug('Unidade Old ' + unidade);
            unidade.TW1_Saldo_Devedor_UAU__c = saldo.saldodevedor;
            unidade.TW1_Valor_da_Venda_UAU__c = saldo.valorvenda;
            unidade.TW1_Valor_de_Venda_Atualizado_UAU__c = saldo.saldopago + saldo.saldodevedor;
            unidade.TW1_Saldo_em_atraso__c = saldo.saldoematraso;
            unidade.TW1_Valor_Total_Pago_UAU__c = saldo.saldopago;
            system.debug('Unidade New ' + unidade);
            produtosRepository.Atualizar(unidade);
        }
    }
    
    /// Método responsável para executar carga de unidades quitadas
    @future(callout = true)
    public static void ExecutaCargaUnidadesQuitadas()
    {
        system.debug('Consultando lista de unidades quitadas');
        List<Cal_SA_UAU_Unidade.UnidadesQuitadasDto> unidadesQuitadas = unidadesServiceAgent.GetListaUnidadesQuitadas();
        
        List<Product2> unidadesQuitadasSalvar = new List<Product2>();
        List<Cal_SA_UAU_Unidade.UnidadesQuitadasDto> unidadesAtualizadas = new List<Cal_SA_UAU_Unidade.UnidadesQuitadasDto>();
        
        system.debug('Percorrendo lista de unidades quitadas');
        for(Cal_SA_UAU_Unidade.UnidadesQuitadasDto unidadeQuitada : unidadesQuitadas)
        {
            system.debug('Consultando unidade IdEmpresa:' + unidadeQuitada.idempresa + 'IdObra: ' + unidadeQuitada.idobra + 'IdPersonalizacao: ' + unidadeQuitada.idpersonalizacao);
            Product2 unidadeDb = produtosRepository.GetUnidadePorEmpresaObraPersonalisacao(unidadeQuitada.idempresa, unidadeQuitada.idobra, unidadeQuitada.idpersonalizacao);
            system.debug('Unidade encontrada no CRM = ' + unidadeDb);
            
            /// Caso não exista a unidade com os parâmetros passado, então segue o baile
            if(unidadeDb != null)
            {    
                /// Atualizar campo
                unidadeDb.TW1_Status_Venda__c = 'Quitada';
                unidadeDb.TW1_Valor_Principal_Inadimplencia__c = 0;
                unidadeDb.TW1_Valor_Reajustado_Inadimplencia__c = 0;
                unidadesQuitadasSalvar.add(unidadeDb);
                unidadesAtualizadas.add(unidadeQuitada);
            }
        }
        
        system.debug('Atualizando lista de unidades quitadas');
        produtosRepository.AtualizarRange(unidadesQuitadasSalvar);       
        
        system.debug('Retornando as unidades quitadas para o UAU');
        //unidadesServiceAgent.InformaRecebimentoUnidadesQuitadas(unidadesAtualizadas);
    }
}