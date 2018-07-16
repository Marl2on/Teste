public with sharing class Cal_Servico_Application_Cases {
    
    /// @@@ Inicia referencias aos repositórios @@@ 
    
    private static Cal_Servico_Repo_AggregatePessoa accountRepository = new Cal_Servico_Repo_AggregatePessoa();
    
    private static Cal_Servico_Repo_AggregateCase casoRepository = new Cal_Servico_Repo_AggregateCase();
    
    private static Cal_Servico_Repo_AggregateProduct productRepository = new Cal_Servico_Repo_AggregateProduct();
    
    //private static Cal_Servico_Repo_AggregateBloco blocoRepository = new Cal_Servico_Repo_AggregateBloco();
    
    private static Cal_Servico_Repo_AggregateUser userRepository = new Cal_Servico_Repo_AggregateUser();
    
    private static Cal_Servico_Repo_AggregateContact contatoRepository = new Cal_Servico_Repo_AggregateContact();
    
    private static Cal_Servico_Repo_AggregateCustomSe customSettings = new Cal_Servico_Repo_AggregateCustomSe();
    
    /// Repositório de log no integração
    private static Cal_Servico_Repo_AggregateLogIntegracao logIntegracaoRepository = new Cal_Servico_Repo_AggregateLogIntegracao();
    
    /// ### Fim referencias aos repositórios ###
    
    /// @@@ Inicia referência aos services agents
    
    private static Cal_SA_UAU_Atendimentos atendimentosServiceAgent = new Cal_SA_UAU_Atendimentos();
    
    /// ### Fim de referencias aos services agents
    
    /// Buscar caso por ID
    public Case GetCasoByID(ID idCaso)
    {
        return  casoRepository.GetCaseById(idCaso);          
    }
    
    /// Busca todos os casos por CPF
    public List<Case> GetCasosPorAccountId(String accountId)
    {
        /// Verifica se o CPF informado não está null ou em branco.
        if(accountId == null || accountId == '' )
            throw new Cal_Cls_Infra_Exception('O ID da conta não pode ser null nem em branco');
        
        return casoRepository.GetListaCasosPorAccountIdOrigemWeb(accountId);
    }
    
    /// Metodo para atualizar o status do serviço assitencia tecnica
    public Cal_Servico_Serv_Cases.AtualizaCasoResult AtualizarStatusServicoAssitenciaTecnica(Cal_Servico_Serv_Cases.AtualizaCasoRequest request)
    {
        /// Criar mensagem de retorno do serviço
        Cal_Servico_Serv_Cases.AtualizaCasoResult result = new Cal_Servico_Serv_Cases.AtualizaCasoResult();
        result.Request = request;
        
        try
        {
            Case casoAtualizar  = casoRepository.GetCaseById(request.id);
            
            /// Caso não exista um caso com id inválido, então retorna erro para ser tratado.
            if(casoAtualizar == null)
                throw new Cal_Cls_Infra_Exception('Não foi encontrado nenhum resultado com o ID de caso igual a ' + request.id);
            
            system.debug('IDCaso usado para teste '+ casoAtualizar.id);
            system.debug('Setando novo status '+ request.StatusSistemaAssistenciaTecnica);
            casoAtualizar.Tw1_Status_Assistencia_Tecnica__c = request.StatusSistemaAssistenciaTecnica;
            system.debug('Novo status setado '+ request.StatusSistemaAssistenciaTecnica);
            system.debug('Atualizando '+ request.StatusSistemaAssistenciaTecnica);
            casoRepository.Modify(casoAtualizar);
            system.debug('Ataulizado');
            
            /// Liberando resposta sem erro
            result.isfailed = false;
            result.DescricaoErro = '';            
        }
        catch(Exception e)
        {
            result.isfailed = true;
            result.DescricaoErro = e.getMessage();
            system.debug('AtualizarStatusServicoAssitenciaTecnica: Error (' + result.DescricaoErro + ')');          
        }
        
        return result;
    }
    
    public void CriarChamadoATTrigger(Case caso)
    {
        Cal_Servico_Application_Cases.CriarChamadoAT(caso.Id);
    }
    
    /// Método cria chamados no serviço Assistencia tecnica para todos os casos informados no parâmetro
    @future(callout=true)
    public static void CriarChamadoAT(string idCaso)
    { 
        //string idCaso = caso.Id;
        /// Caso para ser atualizado com a URL do serviço AT
        Case casoAtualizar  = casoRepository.GetCaseById(idCaso);
        
        string IdManutencaoAreaComum = [select id, name FROM recordtype where name = 'Manutenção de Área Comum'].Id;
        string IdManutencaoUnidade = [select id, name FROM recordtype where name = 'Manutenção de Unidade'].Id;
        System.debug('Tipo do caso sendo processado no CriarChamadoATPelaListaDeCasos: ' + casoAtualizar.RecordTypeId);
        if(casoAtualizar.RecordTypeId == IdManutencaoAreaComum || casoAtualizar.RecordTypeId == IdManutencaoUnidade)
        {   
            System.debug('Consultando o contato');
            /// Produto relacionado ao caso
            Contact contato = contatoRepository.GetContatoById(casoAtualizar.ContactId);
            System.debug('Contato selecionado ' + contato);
            
            /// O contato é obrigatório para crair o caso no AT, caso não tenha, então não deve
            /// ser criado um caso.
            if(contato == null)
            {
                System.debug('Contato em branco, então salva erro no caso');
                String msgErroContatoNull = 'Não foi possível abrir um chamado no serviço de assitencia técnica. O contato é obrigatório';
                casoAtualizar.TW1_Erro_IntegracaoAT__c = msgErroContatoNull;
                casoRepository.Modify(casoAtualizar);
                throw new Cal_Cls_Infra_Exception('Não foi possível abrir um chamado no serviço de assitencia técnica. O contato é obrigatório');
            }
            
            System.debug('Selecionando produto');
            Product2 produto = productRepository.GetProductById(casoAtualizar.TW1_Unidade__c);
            System.debug('Produto selecionado ' + produto);
            
            //System.debug('Selecionando bloco');
            //TW1_Bloco__c bloco = blocoRepository.GetBlocoById(casoAtualizar.TW1_Bloco__c);
            //System.debug('Bloco selecionado ' + bloco);
            
            System.debug('Selecionando Usuário');
            User usuario = userRepository.GetUserById(casoAtualizar.ownerid);
            System.debug('Usuário selecionado ' + usuario);
            
            /// Mapear em objeto a ser enviado para o serviço de assitencia tecnica
            System.debug('Montando request para serviço AT');
            Cal_SA_AT_AbrirChamado.AbrirChamadoRequest atRequest = MapRequestAT(casoAtualizar,contato,produto,usuario);          
            System.debug('Request montado ' + atRequest);
            
            /// Criar chamada ao serviço de AT
            Cal_SA_AT_AbrirChamado ATServiceAgent = new Cal_SA_AT_AbrirChamado();
            
            /// Salvar o caso com a URL do chamado          
            try
            {
                Cal_SA_AT_AbrirChamado.AbrirChamadoResponse response = ATServiceAgent.AbrirChamado(atRequest);
                
                if(response.IdOcorrenciaAt == '0')
                {
                    casoAtualizar.TW1_Detalhe_erro_integracao__c = 'Ocorreu um erro em executar a integraçãoo entre os serviços.' + '\n' + 'Detalhe do erro: ' + response.dscRetorno;
                    casoAtualizar.TW1_URLCallBack__c = response.UriRetorno;
                }
                else
                {   
                    casoAtualizar.TW1_URLCallBack__c = response.UriRetorno;    
                    casoAtualizar.TW1_ID_Assistencia_Tecnica__c = response.IdOcorrenciaAt;
                    casoAtualizar.TW1_URLCallBack__c = response.UriRetorno;
                }
            }
            catch(Exception ex)
            {
                system.debug('Erro em executar a chamada ao serviço: ' + ex.getMessage());
                casoAtualizar.TW1_Detalhe_erro_integracao__c = 'Ocorreu um erro em executar a integraçãoo entre os serviços.' + '\n' + 'Detalhe do erro: '+ ex.getMessage();
            }
            
            casoRepository.Modify(casoAtualizar);
            System.debug('Chamado atualizado');
        }
    }
    
    /// Realiza o mapeamento do objetos para o ARRequest
    private static Cal_SA_AT_AbrirChamado.AbrirChamadoRequest MapRequestAT(Case caso, Contact contato, Product2 unidade, User usuario)
    {
        Cal_SA_AT_AbrirChamado.AbrirChamadoRequest request = new Cal_SA_AT_AbrirChamado.AbrirChamadoRequest();
        
        request.IdChamadoOrigem = caso.Id;
        request.URLCallBack = customSettings.GetURLCallBackAT();
        request.Id = 0;
        request.CodigoObra = unidade.TW1_Codigo_Obra_UAU__c;
        request.Bloco = unidade.TW1_Codigo_Bloco_UAU__c;
        request.Cpfsolicitante = contato.Tw1_CPF__c;
        request.nomeSolicitante = contato.Name;
        request.emailSolicitante = contato.Email;
        request.tefoneSolicitante = contato.Phone;
        request.detalhamentoSolicitacao = caso.TW1_Detalhamento_Solicitacao_Manutencao__c; 
        request.cpfUsuarioCadastrado = usuario.Tw1_CPF__c;
        request.NumeroCaso = caso.CaseNumber;
        
        if(unidade.TW1_Bloco__r.TW1_Responsavel_Manutencao_Vistoria__c == 'Manutenção')
            request.ResponsavelManutencao = 'Manut';
        else if(unidade.TW1_Bloco__r.TW1_Responsavel_Manutencao_Vistoria__c == 'Engenharia')
            request.ResponsavelManutencao = 'Engen';
        
        if(unidade != null)
        {   
            request.DataHabiteSe = unidade.TW1_Data_Habite_se__c;
            request.Unidade = unidade.TW1_Unidade__c;
            request.DataHabiteSeAverbada = unidade.TW1_Data_Averbacao_Habite_se__c;
        }
        
        return request;  
    }
    
    public void ValidarContaContatoDeUmCaso(Case casoTratar)
    {
        system.debug('ValidarContaContatoDeUmCaso (casoTratar = ' + casoTratar + ')');
        
        /// Caso o caso tenha uma conta e um contato, realizar a validação do objetos
        system.debug('Valida se existe uma conta e um cliente associado ao cahamado.');
        if(casoTratar.AccountId != null && casoTratar.ContactId != null)
        {
            system.debug('Consultando contato.');
            Contact contatoCaso = contatoRepository.GetContatoById(casoTratar.ContactId);
            system.debug('Contato selecionado: ' + contatoCaso);
            
            system.debug('valida relacionamento entre contato do caso e conta selecionada no caso. (contatoCaso.AccountId = ' + contatoCaso.AccountId + '; (casoTratar.AccountId = ' + casoTratar.AccountId + ')' );
            if(contatoCaso.AccountId != casoTratar.AccountId)
            {
                casoTratar.addError('O contato selecionado não está associado a conta do caso.');
                //throw new Cal_Cls_Infra_Exception('O contato selecionado não está associado a conta do caso.');
            }
            
            /// Verifica se o caso tem alguma unidade relacionada para realizar a validação de conta.
            if(casoTratar.TW1_Unidade__c != null)
            {    
                system.debug('Consultando unidade.');
                Product2 unidade = productRepository.GetProductById(casoTratar.TW1_Unidade__c);
                system.debug('Unidade selecionada: ' + unidade);
                
                system.debug('valida relacionamento entre conta do caso e conta da unidade. (unidade.TW1_Conta__c = ' + unidade.TW1_Conta__c + '; (casoTratar.AccountId = ' + casoTratar.AccountId + ')' );
                if(unidade.TW1_Conta__c != casoTratar.AccountId)
                {
                    casoTratar.addError('A conta selecionada não está associado a unidade do caso.');
                    //throw new Cal_Cls_Infra_Exception('A conta selecionada não está associado a unidade do caso.');
                }
            }
            
            system.debug('Nenhuma divergencia encontrada.');
        }    
    }
    
    // Atualiza a quantidade de itens de área comum
    public void AtualizaQuantidadeItensAreaComum(ID IdCaso)
    {
        system.debug('Recebendo IdCaso = ' + IdCaso);
        Case caso = casoRepository.GetCaseById(string.valueOf(idCaso));
        system.debug('Caso selecionado:  ' + caso);
        
        system.debug('Buscando lista de área comum.');
        List<TW1_Item_area_Comum__c> listaItemAreaComum = casoRepository.GetListOfItemAreaComumFromCaseByCaseId(string.valueOf(caso.Id));
        system.debug('Lista recebida: ' + listaItemAreaComum);
        
        system.debug('Atribuindo valor ao campo Tw1_Itens_de_Vistoria_Abertos__c = ' +  listaItemAreaComum.size());
        caso.Tw1_Itens_de_Vistoria_Abertos__c = listaItemAreaComum.size();
        
        System.debug('Salvando o caso com atividades'); 
        casoRepository.Modify(caso);
    }
    
    /// Criar caso pelo serviço
    public void CriarCasoPorServico(Cal_Servico_Serv_Cases.CriarCasoRequest request)
    {
        system.debug('Criando objeto de novo caso');
        Case caso = new Case();
        
        /// Verificar se existe a conta informada
        Account contaCaso = accountRepository.GetAccountById(request.IdClienteSalesforce);
        system.debug('Conta consulta com o ID ' + request.IdClienteSalesforce + ' | Dados da conta: ' + contaCaso);
        if(contaCaso == null)
            throw new Cal_Cls_Infra_Exception('Cliente com ID "'+ request.IdClienteSalesforce +'" não corresponde a um cliente no CRM.');
        
        caso.AccountId = request.IdClienteSalesforce;
        
        /// Buscar todos os contatos relacionados de uma conta
        List<AccountContactRelation> contatosPrincipaisDaConta = contatoRepository.GetListaContatosPrincipaisDeUmaConta(request.IdClienteSalesforce);
        system.debug('Lista de contatos relacionados da conta: ' + contatosPrincipaisDaConta);
        if(contatosPrincipaisDaConta.size() < 1)
            throw new Cal_Cls_Infra_Exception('Nenhum contato encontrado para o cliente com ID "'+ request.IdClienteSalesforce +'" no CRM.');
        
        caso.ContactId = contatosPrincipaisDaConta[0].ContactId;
        caso.Description = request.DescricaoChamadoUAU;
        caso.Origin = 'Web';
        
        if(request.IsCasoFechado)
            caso.Status = 'Fechado';
        else
            caso.Status = 'Em atendimento';
        
        /// Verificar se existe a unidade pela empresa, obra e número de venda
        Product2 unidade = productRepository.GetUnidadePorEmpresaObraVenda(request.CodigoEmpresaUau, request.CodigoObraUau, request.NumeroVendaUau);
        if(unidade == null)
            throw new Cal_Cls_Infra_Exception('Não foi encontrado nenhuma unidade correspondente para a empresa "'+request.CodigoEmpresaUau+'" na obra "'+request.CodigoObraUau+'" com número de venda "'+request.NumeroVendaUau+'"');
        
        caso.TW1_Unidade__c = unidade.Id;
        
        /// Verificar se o tipo de caso é válido
        system.debug('Consultando tipo de caso: ' + request.TipoDoCaso);
        List<RecordType> tipoCaso = [Select id FROM RecordType WHERE developername =: request.TipoDoCaso];
        
        system.debug('Recordtypes encontrado: ' + tipoCaso);
        if(tipoCaso.size() <1)
            throw new Cal_Cls_Infra_Exception('O tipo do caso "'+ request.TipoDoCaso +'" não é válido.');
        
        caso.RecordTypeId = tipoCaso[0].Id;
        casoRepository.Incluir(caso);
    }
    
    //// #region Time Line methods
    public void AtualizaInserirStatusTimeLine(Case oldSo, Case so){
        System.debug('--- INÍCIO DO MÉTODO atualizarInserirStatusCase ---');
        
        if(Cal_Cls_Infra_Utils.ExisteCampo(so, 'TW1_Timeline_Repasse__c') && Cal_Cls_Infra_Utils.ExisteCampo(oldSo, 'TW1_Timeline_Repasse__c')){
            
            System.debug('--- O campo TW1_Timeline_Repasse__c dos parâmetros do método (so e oldSo) existem ---');
            
            if(! so.TW1_Timeline_Repasse__c.equals(oldSo.TW1_Timeline_Repasse__c)){
                
                System.debug('--- O status (TW1_Timeline_Repasse__c) do so e do oldSo são diferentes (o status mudou) ---');
                
                System.debug('--- Chamando o método atualizaCaseStatus do Cal_Servico_Application_Cases_Status com o oldSo ---');
                System.debug('oldSo:');
                System.debug(oldSo);
                Cal_Servico_Application_Cases_Status.atualizaCaseStatus(oldSo);
                
                System.debug('--- Chamando o método insereCaseStatus do Cal_Servico_Application_Cases_Status com o so ---');
                System.debug('so:');
                System.debug(so);
                Cal_Servico_Application_Cases_Status.insereCaseStatus(so);
            }
        }else if(Cal_Cls_Infra_Utils.ExisteCampo(so, 'TW1_Timeline_Repasse__c') && ! Cal_Cls_Infra_Utils.ExisteCampo(oldSo, 'TW1_Timeline_Repasse__c')){
            System.debug('--- O campo TW1_Timeline_Repasse__c dos parâmetros do método (so e oldSo) existe no so, mas não no oldSo: apenas inserir ---');
            
            System.debug('--- Chamando o método insereCaseStatus do Cal_Servico_Application_Cases_Status com o so ---');
            System.debug('so:');
            System.debug(so);
            Cal_Servico_Application_Cases_Status.insereCaseStatus(so);
        }
    }
    
    public void InserirStatusTimeLine(Case so){
        System.debug('--- INÍCIO DO MÉTODO inserirStatusCase (sem oldSo) ---');
        
        if(Cal_Cls_Infra_Utils.ExisteCampo(so, 'TW1_Timeline_Repasse__c') ){
            
            System.debug('--- O campo TW1_Timeline_Repasse__c do parâmetro do método (so) existe ---');
            
            System.debug('--- Chamando o método insereCaseStatus do Cal_Servico_Application_Cases_Status com o so ---');
            System.debug('so:');
            System.debug(so);
            Cal_Servico_Application_Cases_Status.insereCaseStatus(so);
        }
    }
    
    public void AtualizarStatusTimeLine(Case oldSo){
        System.debug('--- INÍCIO DO MÉTODO atualizarStatusCase (sem so) ---');
        
        if(
            Cal_Cls_Infra_Utils.ExisteCampo(oldSo, 'TW1_Timeline_Repasse__c')
            && oldSo.TW1_Timeline_Repasse__c == Cal_Repo_LinhaTempoCase.getLastStatusValue()
            && Cal_Repo_LinhaTempoCase.statusIsClosed(oldSo.status)
        ){
            System.debug('--- Chamando o método atualizaCaseStatus do Cal_Servico_Application_Cases_Status com o oldSo ---');
            System.debug('oldSo:');
            System.debug(oldSo);
            Cal_Servico_Application_Cases_Status.atualizaCaseStatus(oldSo);
        }
    }
    //// #endregion
    
    public void AtualizarIdGestorFinanceiro(case Caso)
    {
        User usuarioCaso = userRepository.GetUserById(Caso.LastModifiedById);
        if(usuarioCaso.Profile.Name == 'Gestor de Financiamento')
            Caso.TW1_ID_Gestor_Financiamento__c = usuarioCaso.Id;
    }
    
    /// @@@ Início  Implementação do serviço de busca de atendimentos gerados no UAU automáticos
    
    @Future(callout=true)
    public static void ExecutarCargaDeAtendimentosDeIReBoletos()
    {
        Cal_SA_UAU_Atendimentos.AtendimentosRequest request = new Cal_SA_UAU_Atendimentos.AtendimentosRequest();
        system.debug('Inciando carga de vendas');
        system.debug('Consultando última execução com sucesso');
        DateTime ultimaExecucaoComSucesso = logIntegracaoRepository.DataUltimoProcessoComSucesso('Consultar atendimentos');
        
        request.listacategoria = new List<string>();
        request.listacategoria.add('Boleto - 2 Via');
        request.listacategoria.add('Financeiro-10');
        
        request.periodoincio = ultimaExecucaoComSucesso;
        request.periodofim = DateTime.now();
        
        system.debug('Montando request de consulta a atendimentos: ' + request);
        system.debug('Executando chamada ao serviço de busca de atendimento [atendimentosServiceAgent.GetListaAtendimentos]');
        Cal_SA_UAU_Atendimentos.RetornoAtendimentos response = atendimentosServiceAgent.GetListaAtendimentos(request);
        system.debug('Response da requisição: ' + response);
        
        List<Case> casosInserir = new List<case>();
        
        for(Cal_SA_UAU_Atendimentos.AtendimentosResponse atendimento : response.ListaAtendimentos)
        {
            if(atendimento.UsuarioResponsavel != 'IRPF' && atendimento.UsuarioResponsavel != 'BOLETO')
            {
                system.debug('Usuário do atendimento não bate com nenhum item mapeado: ' + atendimento.UsuarioResponsavel);
                continue;
            }
            
            system.debug('Percorrendo item: ' + atendimento);
            system.debug('Consultando cliente pelo código do UAU: ' + atendimento.CodigoCliente);
            Account contaAtendimento = accountRepository.GetAccountByCodigoUau(atendimento.CodigoCliente);
            system.debug('Conta selecionada: ' + contaAtendimento);
            system.debug('Consultando unidade pelo GetUnidadePorEmpresaObraVenda: Empresa: ' + atendimento.Empresa + ' Obra: ' + atendimento.Obra + ' Venda: ' +  atendimento.Venda);
            Product2 unidade = productRepository.GetUnidadePorEmpresaObraVenda(atendimento.Empresa, atendimento.Obra,atendimento.Venda);
            system.debug('Unidade selecionada: ' + unidade);
            
            Case caso = new Case();
            caso.AccountId = contaAtendimento.Id;
            caso.ProductId = unidade.Id;
            caso.TW1_Data_do_envio__c = atendimento.DataCadastro;
            
            if(atendimento.UsuarioResponsavel == 'IRPF')
                caso.RecordTypeId = [Select id,SobjectType,Name From RecordType where DeveloperName  ='TW1_Envio_Informe_Rendimentos' limit 1].Id;
            if(atendimento.UsuarioResponsavel == 'BOLETO')
                caso.RecordTypeId = [Select id,SobjectType,Name From RecordType where DeveloperName  =' TW1_Envio_Boleto' limit 1].Id;
            
            caso.TW1_Email_Enviado__c = atendimento.Email;
            
            system.debug('Caso montado para inclusão: ' + caso);
            casosInserir.add(caso);
        }
        
        system.debug('Inserindo lista de casos automáticos');
        insert casosInserir;
    }
    
    // ### Fim da Implementação do serviço de busca de atendimentos gerados no UAU automáticos
    // 
    public void FecharMarcos(case casoold, Case casoNovo)
    {
        if(casoNovo.Status == 'Fechado' || casoNovo.Status == 'Cancelado')
        {
            system.debug('Buscando marcos');
            List<CaseMilestone> marcos = [SELECT id FROM CaseMilestone WHERE CaseId = :casoold.Id AND IsCompleted != true];
            system.debug('Marcos selecionados: ' + marcos);
            for(CaseMilestone marco : marcos)
            {
                system.debug('Atualizando conclusão do marco: ' + marco);
                marco.CompletionDate = Datetime.now();
                system.debug('Atualizando: ' + marco);
            }
            
            system.debug('Atualizando marcos');
            update marcos;
            system.debug('Marcos atualizados');
            return;
        }
        
        if(casoold.TW1_Status_Gerais__c != casoNovo.TW1_Status_Gerais__c)
        {
            system.debug('Buscando marcos');
            List<CaseMilestone> marcos = [SELECT id FROM CaseMilestone WHERE CaseId = :casoold.Id AND MilestoneType.Name != 'SLA Total' AND IsCompleted != true];
            
            system.debug('Marcos selecionados: ' + marcos);
            for(CaseMilestone marco : marcos)
            {
                system.debug('Atualizando conclusão do marco: ' + marco);
                marco.CompletionDate = Datetime.now();
            }
            
            system.debug('Atualizando marcos');
            update marcos;
            system.debug('Marcos atualizados');
        }
    }
}