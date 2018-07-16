public class Cal_Servico_Application_Pessoa {
    
    
    static Cal_Servico_Repo_AggregatePessoa pessoaRepository = new Cal_Servico_Repo_AggregatePessoa();
    
    static Cal_Servico_Repo_AggregateContact contatoRepository = new Cal_Servico_Repo_AggregateContact();
    
    static Cal_Servico_Repo_AggregateProduct produtoRepository = new Cal_Servico_Repo_AggregateProduct();
    
    static Cal_SA_UAU_Pessoa pessoaServiceAgent = new Cal_SA_UAU_Pessoa();
    
    static Cal_Servico_Repo_AggregateCustomSe customSettingsRepository = new Cal_Servico_Repo_AggregateCustomSe();
    
    Cal_SA_ProJurid proJuridServiceAgent = new Cal_SA_ProJurid();
    
    /// Repositório de log no integração
    Cal_Servico_Repo_AggregateLogIntegracao logIntegracaoRepository = new Cal_Servico_Repo_AggregateLogIntegracao();
    
    public Cal_Servico_Serv_Pessoas.ClienteResponse GetClienteByCPF(String cpf)
    {
        System.debug('Consultando cliente com o CPF: ' + cpf);
        Account pessoa = pessoaRepository.GetAccountByCPF(cpf);
        
        System.debug('Cliente selecionado ' + pessoa);
        if(pessoa == null)
            throw new Cal_Cls_Infra_Exception('Não foi encontrado o cliente com o CPF ' + cpf + ' no CRM.');
        
        System.debug('Consultando unidade do clienteID: ' + pessoa.Id);
        List<Product2> produtos = produtoRepository.GetTodasPropriedadesDeUmCLiente(pessoa.Id);
        
        // Realizar mapeamento de pessoa
        Cal_Servico_Serv_Pessoas.ClienteResponse response = MapAccountEmClienteResponse(pessoa);
        
        // Realizar mapeamento de produto
        response.Empreendimentos.addAll(MapProdutoParaEmpreendimentoDto(produtos));
        System.debug('Response de PessoaDto montado: ' + response);
        
        return response;
    }
    
    /// Método do Job para verificar clientes não atualizados dentro de um período de tempo
    /// definido na custom seetings TW1_Padroes_relacionamento__c.TW1_Tempo_Atualizacao_Cadastral__c
    @future
    public static void JobValidaTempoAtualizacaoCadastral()
    {
        integer tempoMaximo = customSettingsRepository.GetTempoAtualizacaoCadastral();
        system.debug('Tempo de máximo de atualização: ' +  tempoMaximo);
        List<Account> listaPessoas = pessoaRepository.GetListaClientesNaoAtualizadosEmPeriodoDias(tempoMaximo);
        System.debug('Lista de pessoas selecionadas: ' + listaPessoas);
        
        List<Account> listaContas = new List<Account>();
        
        for(Account pessoa : listaPessoas)
        {
            system.debug('Atualizando: ' + pessoa);
            pessoa.TW1_Atualizar_Dados_Cadastrais__c = true;
            listaContas.add(pessoa);
            system.debug('Pessoa atualizada com sucesso');
        }
        
        update listaContas;
    } 
    
    /// #region MAP response de consulta de cliente pelo serviço de pessoa
    private Cal_Servico_Serv_Pessoas.ClienteResponse MapAccountEmClienteResponse(Account cliente)
    {
        Cal_Servico_Serv_Pessoas.ClienteResponse clienteresponse = new Cal_Servico_Serv_Pessoas.ClienteResponse();
        clienteresponse.IdClienteSalesForce = cliente.Id;
        clienteresponse.CodigoClienteUAU = cliente.Tw1_Codigo_Cliente_UAU__c;
        clienteresponse.Nome = cliente.Name;
        clienteresponse.CPF = cliente.Tw1_N_Documento__c;
        clienteresponse.EmailPrincipal = cliente.Tw1_E_mail__c;
        clienteresponse.EmailAlternativo = cliente.Tw1_E_mail_Alternativo__c;
        clienteresponse.TelefonePrincipal = cliente.Tw1_Celular__c;
        
        clienteresponse.enderecoCobranca = new Cal_Servico_Serv_Pessoas.ClienteEnderecoDto();
        clienteresponse.enderecoCobranca.rua = cliente.BillingStreet;
        clienteresponse.enderecoCobranca.complemento = cliente.TW1_Complemento_Endereco_Cobranca__c;
        clienteresponse.enderecoCobranca.referencia = '';
        clienteresponse.enderecoCobranca.cidade = cliente.BillingCity;
        clienteresponse.enderecoCobranca.estado = cliente.BillingState;
        clienteresponse.enderecoCobranca.cep = cliente.Tw1_CEP__c;
        clienteresponse.enderecoCobranca.pais = cliente.BillingCountry;
        
        clienteresponse.Empreendimentos = new List<Cal_Servico_Serv_Pessoas.EmpreendimentoDto>();
        
        return clienteresponse;
    }
    
    private List<Cal_Servico_Serv_Pessoas.EmpreendimentoDto> MapProdutoParaEmpreendimentoDto(List<Product2> produtos)
    {
        system.debug('Criando lista de empreendimentos');
        List<Cal_Servico_Serv_Pessoas.EmpreendimentoDto> result = new List<Cal_Servico_Serv_Pessoas.EmpreendimentoDto>();
        
        system.debug('Total de produtos encontrado: ' + produtos);
        for(Product2 produto : produtos)
        {
            
            boolean empreendimentoEncontrado = false;
            Cal_Servico_Serv_Pessoas.EmpreendimentoDto empreendimentoDto;
            
            // verificar se já existe o empreendimento
            for(Cal_Servico_Serv_Pessoas.EmpreendimentoDto empreendimento :result)
            {
                system.debug('Comparando valores : ' + empreendimento.CodigoEmpresaUAU+' == ' + produto.TW1_Codigo_Empresa_UAU__c + 'AND' + empreendimento.CodigoObraUAU + ' == ' + produto.TW1_Codigo_Empreendimento_UAU__c);
                // Verifica se o empreendimento tem o código empresa e o código obra igual.
                if(empreendimento.CodigoEmpresaUAU == produto.TW1_Codigo_Empresa_UAU__c 
                   && empreendimento.CodigoObraUAU == produto.TW1_Codigo_Empreendimento_UAU__c)
                {
                    // Carrega o empreendimento para ser trabalhado
                    empreendimentoDto = empreendimento;
                    empreendimentoEncontrado = true;
                    system.debug('Set empreendimento: ' + empreendimentoDto);
                }
            }
            
            // Caso não tenha o empreendimento já na lista, então cria um novo empreendimentto
            if(empreendimentoEncontrado == false)
            {
                empreendimentoDto = new Cal_Servico_Serv_Pessoas.EmpreendimentoDto();
                empreendimentoDto.CodigoEmpresaUAU = produto.TW1_Codigo_Empresa_UAU__c;
                empreendimentoDto.CodigoObraUAU = produto.TW1_Codigo_Empreendimento_UAU__c;
                empreendimentoDto.Nome = produto.TW1_Empreendimento__c;
                empreendimentoDto.Blocos = new List<Cal_Servico_Serv_Pessoas.BlocoDto>();
                system.debug('Criando empreendimento : ' + empreendimentoDto);
                result.add(empreendimentoDto);
            }
            
            boolean blocoEncontrado = false;
            Cal_Servico_Serv_Pessoas.BlocoDto blocoDto;
            
            // Percorre blocos do empreendimentos para verificar se já existe o bloco no objeto
            for(Cal_Servico_Serv_Pessoas.BlocoDto bloco :empreendimentoDto.Blocos)
            {
                if(bloco.Nome == produto.TW1_Nome_Bloco__c)
                {
                    blocoDto = bloco;
                    blocoEncontrado = true;
                }
            }
            
            // Caso o bloco não exista, então cria
            if(blocoEncontrado == false)
            {
                blocoDto = new Cal_Servico_Serv_Pessoas.BlocoDto();
                blocoDto.Nome = produto.TW1_Nome_Bloco__c;
                blocoDto.Unidades = new List<Cal_Servico_Serv_Pessoas.UnidadeDto>();
                empreendimentoDto.Blocos.add(blocoDto);
            }
            
            // Montando unidade nova
            Cal_Servico_Serv_Pessoas.UnidadeDto unidade = new Cal_Servico_Serv_Pessoas.UnidadeDto();
            unidade.NomeUnidade = produto.Name;
            unidade.NumeroVenda = produto.TW1_Numero_Venda__c;
            unidade.Unidade = produto.TW1_Unidade__c;
            
            blocoDto.Unidades.add(unidade);
        }
        
        return result;
    }
    /// #endregion MAP response de consulta de cliente pelo serviço de pessoa
    
    /// #region Início de atualização cadastral no UAU
    public static void AtualizarDadosCadastraisUAU(Id accountId)
    {
        System.debug('Executando atualização de dados cadastrais no UAU');
        System.debug('Realizando mapeamento de pessoas para request');
        
        Account pessoa = pessoaRepository.GetAccountById(accountId);
        
        try
        {
            Cal_SA_UAU_Pessoa.PessoaRequest requestPessoa = MapPessoaParaPessoaRequestUAU(pessoa);
            
            /// Enviando atualização cadastral para o UAU
            System.debug('Enviando request para service agent: ' + requestPessoa);
            pessoaServiceAgent.AtualizarDadosCadastraisUAU(requestPessoa);
            pessoa.TW1_Status_Atualizacao_UAU__c = 'Atualização cadastral enviada para o UAU no dia ' + DateTime.now();
            
            system.debug('Atualizando lista de account enviadas para o UAU: ' + pessoa);
        }
        catch(Exception e)
        {
            system.debug('Erro em atualizar pessoa no UAU: ' + e.getMessage());
            pessoa.TW1_Status_Atualizacao_UAU__c = 'Ocorreu um erro em atualizar dados cadastrais da pessoa no UAU, favor olhar log de integração ' + DateTime.now();
        }
        finally
        {
            //update pessoa;
        }       
    }
    
    private static Cal_SA_UAU_Pessoa.PessoaRequest MapPessoaParaPessoaRequestUAU(Account pessoa)
    {
        Cal_SA_UAU_Pessoa.PessoaRequest request = new Cal_SA_UAU_Pessoa.PessoaRequest();
        
        /// Lista de pessoas
        List<Cal_SA_UAU_Pessoa.cls_pessoas> pessoasDto = new List<Cal_SA_UAU_Pessoa.cls_pessoas>();
        System.debug('Processando map do account:' + pessoa);
        
        /// Criando Map de pessoa
        System.debug('Map da pessoa:' + pessoa);
        Cal_SA_UAU_Pessoa.cls_pessoas pessoaDto = new Cal_SA_UAU_Pessoa.cls_pessoas();
        
        pessoaDto.descricao = pessoa.Name;
        
        pessoaDto.cpfcnpj = new Cal_SA_UAU_Pessoa.cls_cpfcnpj();
        
        system.debug('Verificando o recordType da pessoa a ser mapeada: ' + pessoa.RecordType.Name);
        if(pessoa.RecordType.Name == 'Pessoa Fisica')
        {	
            pessoaDto.fisjur = 1;//pessoa.RecordType; Verificacr valores com 
            pessoaDto.cpfcnpj.cpf = pessoa.Tw1_N_Documento__c;   
            PessoaDto.pessoafisica = MapPessoaFisica(pessoa);
        }
        else
        {
            pessoaDto.fisjur = 2;
            pessoaDto.cpfcnpj.cnpj = pessoa.Tw1_N_Documento__c;   
            pessoaDto.pessoajuridica = MapPessoaJuridica(pessoa);
        }
        
        pessoaDto.dtnasc = string.valueOf(pessoa.Tw1_Data_de_Nascimento__c);
        pessoaDto.nomefantasia = pessoa.Tw1_Nome_Fantasia__c;
        pessoaDto.inscmunicipal = pessoa.Tw1_Inscricao_Municipal__c;
        pessoaDto.inscestadual = pessoa.Tw1_Inscricao_Estadual__c;
        pessoaDto.email = pessoa.Tw1_E_mail__c;
        pessoaDto.homepage = '';
        pessoaDto.endereco = pessoa.ShippingStreet;
        pessoaDto.setor = '';
        pessoaDto.uf = pessoa.ShippingState;
        pessoaDto.cidade = pessoa.ShippingCity;
        pessoaDto.cep = pessoa.ShippingPostalCode;
        pessoaDto.referencia = '';
        pessoaDto.complemento = pessoa.TW1_Complemento_Endereco_Cobranca__c;
        
        pessoaDto.telefones = MapTelefones(pessoaRepository.GetContatosAdcionais(pessoa.Id));
        pessoaDto.enderecocobranca = MapEnderecoCobranca(pessoa);
        
        pessoaDto.pessoavenda = new Cal_SA_UAU_Pessoa.cls_pessoavenda();
        pessoaDto.pessoavenda.recebeboletocorreio = '';
        pessoaDto.pessoavenda.recebeboletoemail = '';
        
        pessoasDto.add(pessoaDto);
        
        request.pessoas = pessoasDto;
        return request;
    }
    
    private static List<Cal_SA_UAU_Pessoa.cls_telefones> MapTelefones(List<Tw1_Dados_de_Contato_adicionais__c> telefones)
    {
        system.debug('Iniciando mapeamento de contatos adcionais na lista: ' + telefones);
        List<Cal_SA_UAU_Pessoa.cls_telefones> telefonesDto = new List<Cal_SA_UAU_Pessoa.cls_telefones>();
        
        for(Tw1_Dados_de_Contato_adicionais__c telefone : telefones)
        {
            Cal_SA_UAU_Pessoa.cls_telefones telefoneDto = new Cal_SA_UAU_Pessoa.cls_telefones();
            telefoneDto.ddd = '000';
            telefoneDto.fone = telefone.Tw1_Contato__c;
            
            if(telefone.RecordType.Name == 'Telefone')
                telefoneDto.tipotelefone = '0';
            else if(telefone.RecordType.Name == 'Comercial')
                telefoneDto.tipotelefone = '1';
            else if(telefone.RecordType.Name == 'Celular')
                telefoneDto.tipotelefone = '2';
            else if(telefone.RecordType.Name == 'Fax')
                telefoneDto.tipotelefone = '4';
            
            system.debug('Incluindo ' + telefoneDto + ' na lista.');
            telefonesDto.add(telefoneDto);
        }        
        
        return telefonesDto;
    }
    
    private static Cal_SA_UAU_Pessoa.cls_pessoajuridica MapPessoaJuridica(Account pessoa)
    {
        Cal_SA_UAU_Pessoa.cls_pessoajuridica pessoaJuridica = new Cal_SA_UAU_Pessoa.cls_pessoajuridica();
        
        List<AccountContactRelation> contatos = contatoRepository.GetListaContatosPrincipaisDeUmaConta(pessoa.Id);
        system.debug('Lista de contatos relacionados: ' + contatos);
        
        /// Algorítimo complexo para limitar número de contato apenas em 2 itens.
        integer contador = 0;
        
        for(AccountContactRelation contato : contatos)
        {
            if(contato.Tw1_Principal__c && contador == 0)
                pessoaJuridica.contato1 = contato.Contact.Name;
            
            if(contato.Tw1_Principal__c && contador == 1)
                pessoaJuridica.contato2 = contato.Contact.Name;
        }
        
        return pessoaJuridica;
    }
    
    private static Cal_SA_UAU_Pessoa.cls_pessoafisica MapPessoaFisica(Account pessoa)
    {
        Cal_SA_UAU_Pessoa.cls_pessoafisica pessoaFisicaDto = new Cal_SA_UAU_Pessoa.cls_pessoafisica();
        
        pessoaFisicaDto.codigoempresa = 264;
        pessoaFisicaDto.numerorg = pessoa.Tw1_Identidade__c;
        
        if(pessoa.TW1_Profissao_UAU__c == '' || pessoa.TW1_Profissao_UAU__c == null)
            pessoaFisicaDto.profissao = 0;
        else
            pessoaFisicaDto.profissao = integer.valueOf(pessoa.TW1_Profissao_UAU__c);
        
        if(pessoa.Tw1_Sexo__c == 'Masculino')
            pessoaFisicaDto.sexo = '0';
        else if(pessoa.Tw1_Sexo__c == 'Feminino')
            pessoaFisicaDto.sexo = '1';
        else if(pessoa.Tw1_Estado_Civil__c == 'Separado Judicialmente')
            pessoaFisicaDto.estadocivil = '0';
        else if(pessoa.Tw1_Estado_Civil__c == 'Solteiro')
            pessoaFisicaDto.estadocivil = '1';
        else if(pessoa.Tw1_Estado_Civil__c == 'Casado')
            pessoaFisicaDto.estadocivil = '2';
        else if(pessoa.Tw1_Estado_Civil__c == 'Viuvo')
            pessoaFisicaDto.estadocivil = '4';
        else if(pessoa.Tw1_Estado_Civil__c == 'Divorciado')
            pessoaFisicaDto.estadocivil = '5';
        
        pessoaFisicaDto.naturalidade = pessoa.TW1_Naturalidade__c;
        //pessoaFisicaDto.nacionalidade = pessoa.Tw1_Nacionalidade__c;
        
        return pessoaFisicaDto;
    }
    
    private static Cal_SA_UAU_Pessoa.cls_enderecocobranca MapEnderecoCobranca(Account pessoa)
    {
        Cal_SA_UAU_Pessoa.cls_enderecocobranca enderecoDto = new Cal_SA_UAU_Pessoa.cls_enderecocobranca();
        enderecoDto.endereco = pessoa.BillingStreet;
        enderecoDto.uf = pessoa.BillingState;
        enderecoDto.cidade = pessoa.BillingCity;
        enderecoDto.cep = pessoa.BillingPostalCode;
        enderecoDto.referencia = '';
        enderecoDto.complemento = '';
        enderecoDto.codigoempresa = 264;
        return enderecoDto;
    }
    
    /// Fim Region de mapeamento de pessoa para o serviço UAU
    
    /// Método responsável por consultar e cadastrar os processos de uma conta no serviço ProJurid
    public void ImportarProcessoProJuridDaConta(string accountId)
    {
        //proJuridServiceAgent
        //Consultar pessoa
        system.debug('Consultando pessoa pelo id: ' + accountId);
        Account pessoa = pessoaRepository.GetAccountById(accountId);
        system.debug('Peessoa encontrada: ' + pessoa);
        
        if(pessoa == null)
            throw new Cal_Cls_Infra_Exception('Não foi encontrado o cliente com o ID ' + accountId + ' no CRM.');
        
        //Consulta processos
        system.debug('Consultando processos no ProJurid pelo CPF ou CNPJ:' + pessoa.Tw1_N_Documento__c);
        Cal_SA_ProJurid.ResponseConsultaProcessos response =  proJuridServiceAgent.GetProcessos(pessoa.Tw1_N_Documento__c);
        system.debug('Response do serviço do ProJurid: ' + response);
        
        //Realizar mapeamento de processos
        List<TW1_Projurid__c> listaProcessos = new List<TW1_Projurid__c>();
        
        /// Percorre lista para montar objetos a serem inseridos
        for(Cal_SA_ProJurid.Processos processoDto : response.Processos)
        {
            system.debug('Realizando o mapeamento do processo: ' + processoDto);
            TW1_Projurid__c processo = MapProcessos(pessoa.Id, processoDto);
            system.debug('Mapeamento realizado: ' + processo);
            
            /// Verifica se o processo existe, caso exista atualiza o objeto com o ID existente
            system.debug('Verifica se existe o processo com os seguintes parâmetros: ContaId = ' + processo.TW1_Conta__c + ' - Processo = ' + processo.TW1_Numero_Processo__c);
            TW1_Projurid__c processoConsulta = pessoaRepository.GetProcessoPorNumeroEConta(processo.TW1_Conta__c, processo.TW1_Numero_Processo__c);
            system.debug('Retorno da consulta: ' + processoConsulta);
            
            if(processoConsulta != null)
            {
                system.debug('Atribuindo ID existente para atualizar informação: ' + processoConsulta.Id);
                processo.Id = processoConsulta.Id;
            }
            
            listaProcessos.add(processo);
        }
        
        //Salvar
        system.debug('Persistindo informações no banco: ' + listaProcessos);
        if(listaProcessos.size() > 0)
            pessoaRepository.IncluirProcessos(listaProcessos);
        
        system.debug('importação de processos realizada com sucesso.');
    }
    
    // Realiza mapeamento de DTO para objeto ProJurid
    private TW1_Projurid__c MapProcessos(Id accountId, Cal_SA_ProJurid.Processos processoDto)
    {
        TW1_Projurid__c processo = new TW1_Projurid__c();
        
        processo.TW1_Conta__c = accountId;
        
        processo.TW1_CPF_CNPJ__c = processoDto.CpfCnpj;
        processo.TW1_Numero_Processo__c = processoDto.NumProcesso;
        processo.TW1_Data_inclusao__c = Cal_Cls_Infra_Utils.ParseDate(processoDto.DataEntrada);
        processo.TW1_Data_Processo__c =  Cal_Cls_Infra_Utils.ParseDate(processoDto.DataProcesso);
        processo.TW1_Data_modificacao__c =  Cal_Cls_Infra_Utils.ParseDate(processoDto.DataModificacao);
        processo.TW1_Parte_interessada__c = processoDto.NomeParteInteresse;
        processo.TW1_Posicao_parte_interessada__c = processoDto.PosicaoParteInteresse;
        processo.TW1_Parte_contraria__c = processoDto.NomeParteContraria;
        processo.TW1_Posicao_parte_contraria__c = processoDto.PosicaoParteContraria;
        
        if(processoDto.StatusDossie == 'E')            
            processo.TW1_Status__c = 'Fechado'; 
        
        if(processoDto.StatusDossie == 'A')            
            processo.TW1_Status__c = 'Aberto'; 
        
        //processo.TW1_Empresa__c = processoDto.Empresa;
        //processo.TW1_Bloco__c = processoDto.Bloco;
        //processo.TW1_Unidade__c = processoDto.Unidade;
        //processo.TW1_Empreendimento__c = processoDto.Empreendimento;
        
        processo.TW1_Acao__c = processoDto.NomeAcao;
        processo.TW1_Causa_pedir__c = processoDto.CausasDePedir;
        processo.TW1_Fase_processo__c = processoDto.FaseProcesso;
        processo.TW1_Escritorio__c = processoDto.Escritorio;
        
        return processo;
    }
    
    /// Inicio de CallBack atualização cadastral no UAU
    public void ProcessaCallBackAtualizacaoCadastralUAU(Cal_Servico_Serv_Pessoas.RequestCallBackAtualizacaoCadastral requestCallBack)
    {
        system.debug('Inciando processo de callback atualização cadastral');
        Log_Integracao__c log = logIntegracaoRepository.IncluirLogIntegracao('CallBack_AtualizacaoCadastral','Processo de callBack de atualização cadastral.','', '', 'Em processo');
        
        if(requestCallBack.code == 200)
            log.Status_da_integracao__c = 'Processada com sucesso';
        else
        {
            MontarAttach(requestCallBack.message, log.Id);
            log.Status_da_integracao__c = 'Processada com erro';
        }
        
        update log;
    }
    
    private void MontarAttach(string texto, string idLog)
    {
        Attachment attach = new Attachment();
        attach.contentType = 'text/plain; charset=UTF-8';
        attach.name = 'Log_Processamento_CallBack.txt';
        attach.parentId = idLog;
        attach.body =   Blob.valueOf(texto);
        insert attach;
    }
}