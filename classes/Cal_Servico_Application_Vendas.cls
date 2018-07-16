public class Cal_Servico_Application_Vendas {
    
    private static Cal_SA_UAU_Venda vendaServiceAgent = new Cal_SA_UAU_Venda();
    
    private static Cal_Servico_Repo_AggregatePessoa pessoaRepository = new Cal_Servico_Repo_AggregatePessoa();
    
    private static Cal_Servico_Repo_AggregateProduct unidadeRepository = new Cal_Servico_Repo_AggregateProduct();
    
    private static Cal_Servico_Repo_AggregateParcelas parcelasRepository = new Cal_Servico_Repo_AggregateParcelas();
    
    /// Repositório de log no integração
    private static Cal_Servico_Repo_AggregateLogIntegracao logIntegracaoRepository = new Cal_Servico_Repo_AggregateLogIntegracao();
    
    /// Método para executar carga de vendas
    @Future(callout=true)
    public static void ExecutarCargaDeVendas()
    {
        /// TODO: O nome das integrações merecem um refactory para não ficar fixo no código.
        system.debug('Inciando carga de vendas');
        system.debug('Consultando última execução com sucesso');
        DateTime ultimaExecucaoComSucesso = logIntegracaoRepository.DataUltimoProcessoComSucesso('Consultar vendas');
        
        /// Montando request
        system.debug('Montando request de consulta a vendas por período. Data de início: ' + ultimaExecucaoComSucesso.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\''));
        Cal_SA_UAU_Venda.VendasRequest request = MontarRequestConsultaVendasPorData(ultimaExecucaoComSucesso);
        Cal_SA_UAU_Venda.RetornoConsultaVenda retorno;
        
        system.debug('Executando chamada Cal_SA_UAU_Venda.GetVendas(request) - Request: ' + request);
        
        retorno	= vendaServiceAgent.GetVendas(request);
        
        if(retorno.ResponseVenda != null)
        {
            system.debug('Retorno do método GetVendas: ' + retorno);
            Log_Integracao__c logIntegracao = retorno.logIntegracao;
            Cal_SA_UAU_Venda.ResponseVenda response = retorno.ResponseVenda;
            
            system.debug('Log de integracao:' + logIntegracao);             		
            
            for(Cal_SA_UAU_Venda.Vendas venda : response.Vendas)
            {
                system.debug('Processando venda de número: ' + venda.Numero);
                logIntegracao.Descricao__c = logIntegracao.Descricao__c + '\n' + '\n' +'Processando venda de número: ' + venda.Numero;
                logIntegracaoRepository.Atualiza(logIntegracao);
                
                // Criando um  SavePoint para iniciar a transação da venda
                system.debug('Inciando contexto de SavePoint');
                Savepoint sp = Database.setSavepoint();
                
                try
                {		
                    system.debug('Realizando processamento de account');
                    Account contaPrincipal = new Account();
                    contaPrincipal = ProcessaAccount(response, venda);
                    system.debug('Verificando a conta principal preenchida: ' + contaPrincipal);
                    
                    system.debug('Realizando map da unidade');
                    Product2 unidadeVenda = new Product2();
                    unidadeVenda = ProcessaVendaNaUnidade(venda, contaPrincipal);
                    
                    system.debug('Realizando o map dos proprietarios de uma unidade');
                    List<TW1_Proprietarios_Unidade__c> proprietariosUnidade = MapProprietariosUnidade(response, venda, unidadeVenda);
                    insert proprietariosUnidade;
                    
                    system.debug('Realizando o map das parcelas de uma venda');
                    ProcessarParcelasVenda(venda, unidadeVenda);
                    
                    logIntegracao.Descricao__c = logIntegracao.Descricao__c + '/n' + 'Venda de número: ' + venda.Numero + ' processada com sucesso.';
                    logIntegracaoRepository.Atualiza(logIntegracao);                
                }
                catch(Exception e)
                {                
                    /// Caso ocorra erro, realiza o RollBack no CRM
                    system.debug('Ocorreu o erro: ' + e.getMessage());
                    system.debug('Realizando RollBack');
                    Database.RollBack(sp);
                    
                    logIntegracao.Descricao__c = logIntegracao.Descricao__c + '\n' + 'Venda de número: ' + venda.Numero + ' processada com erro: ' + e.getMessage();
                    logIntegracao.Status_da_integracao__c = 'Processada com erro';
                    logIntegracaoRepository.Atualiza(logIntegracao);
                } 
            }         
            
            if(logIntegracao.Status_da_integracao__c  == 'Em processo')
            {
                logIntegracao.Status_da_integracao__c = 'Processada com sucesso';
                logIntegracaoRepository.Atualiza(logIntegracao);
            }
            
            system.debug('Processo finalizado');   
        }
        
    }
    
    /// Método para montar o request de consulta das vendas cadastradas por data. Data de incício é a ultima data de
    /// execução com sucesso.
    private static Cal_SA_UAU_Venda.VendasRequest MontarRequestConsultaVendasPorData(DateTime dataInicio)
    {
        Cal_SA_UAU_Venda.VendasRequest request = new  Cal_SA_UAU_Venda.VendasRequest();
        request.listavendas = new List<Cal_SA_UAU_Venda.DadosVendaRequest>();
        
        /// TODO: Buscar todas as vendas ativas e colocar na lista acima.
        
        request.datainicial = dataInicio.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        request.datafinal = DateTime.now().format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        return request;
    }
    
    /// Mapeando de account
    private static Account ProcessaAccount(Cal_SA_UAU_Venda.ResponseVenda response, Cal_SA_UAU_Venda.Vendas venda)
    {
        List<Account> listaContaCriar = new List<Account>();
        List<Account> listaContaAtualizar = new List<Account>();
        
        Account contaPrincipal;
        
        for(Cal_SA_UAU_Venda.Clientes client : venda.Clientes)
        {
            system.debug('Consulta conta pelo CPF para verificar existência: ' + client.CpfCnpjDoCliente);
            Account contaDb = pessoaRepository.GetAccountByCPF(client.CpfCnpjDoCliente);
            system.debug('Retorno de conta: ' + contaDb);
            
            Account conta = null;
            
            if(contaDb == null)
                conta = new Account();
            else
                conta = contaDb;
            
            Cal_SA_UAU_Venda.Pessoas pessoaSendoTratada = null;
            RecordType tipoPessoa;
            
            system.debug('Buscando pessoa na lista de pessoas retornadas pelo CPF ou CNPJ: ' + client.CpfCnpjDoCliente);
            for(Cal_SA_UAU_Venda.Pessoas pessoa : response.Pessoas)
            {
                if(pessoa.pessoaFisica != null)
                    if(pessoa.cpfCnpj.cpf == client.CpfCnpjDoCliente)
                {	
                    tipoPessoa = pessoaRepository.GetRecordTypePessoaFisica();
                    pessoaSendoTratada = pessoa;
                    conta.Tw1_N_Documento__c = pessoa.cpfCnpj.cpf;
                    system.debug('Realizando o Map de Pessoa física');
                    conta = MapPessoaFisicaToAccount(pessoaSendoTratada.pessoaFisica, conta);
                    system.debug('Map realizado: ' + conta);
                }
                else
                    if(pessoa.cpfCnpj.cnpj == client.CpfCnpjDoCliente)
                {
                    tipoPessoa = pessoaRepository.GetRecordTypePessoaJuridica();
                    pessoaSendoTratada = pessoa;
                    conta.Tw1_N_Documento__c = pessoa.cpfCnpj.cnpj;
                }	
            }
            
            system.debug('Verifica se a pessoa foi encontrada na lista retornada pelo response: ' + pessoaSendoTratada);
            if(pessoaSendoTratada == null)
                throw new Cal_Cls_Infra_Exception('O cliente não foi encontrado na lista de pessoas: ' + response.Pessoas + ' - CPF / CNPJ consultado: ' + client.CpfCnpjDoCliente);
            
            /// Realizar Map
            conta.RecordTypeId = tipoPessoa.Id;
            system.debug('Realizando map de conta');
            conta = MapPessoaDtoToAccount(pessoaSendoTratada, conta);        
            system.debug('Map realizado: ' + conta);
            
            system.debug('Realizando map de endereco de cobrança');
            conta = MapEnderecoCobrancaToAccount(pessoaSendoTratada.enderecoCobranca, conta);
            system.debug('Map de endereço de cobrança realizado com sucesso: ' + conta);
            
            conta.Tw1_Codigo_Cliente_UAU__c = string.valueOf(client.codigocliente);
            
            system.debug('Conta mapeada: ' + conta);
            
            MapTelefonesDto telefonesConta = MapTelefonesToDadosContatoAdcionais(pessoaSendoTratada.telefones, conta);
            conta = telefonesConta.conta;
            UpSert conta;
            
            system.debug('Realizando map de telefones');
            MapTelefonesDto telefonesAdcionais = MapTelefonesToDadosContatoAdcionais(pessoaSendoTratada.telefones, conta);
            system.debug('Lista de contatos adicionais a serem incluídos: ' + telefonesAdcionais.listaContatosAdcionais);
            insert telefonesAdcionais.listaContatosAdcionais;
            system.debug('Map de telefones realizado com sucesso:' + telefonesAdcionais.listaContatosAdcionais);           
            
            if(contaDb == null)
                listaContaCriar.add(conta);
            else
                listaContaAtualizar.add(conta);
            
            if(client.Principal)
                contaPrincipal = conta;
        }
        
        system.debug('Processo de account para venda: ' + venda + ' realizado com sucesso.');
        
        if(contaPrincipal != null)
            return contaPrincipal;    
        else
            throw new Cal_Cls_Infra_Exception('Não foi encontrado uma conta principal para efetuar a venda.');
    }
    
    private static Account MapPessoaDtoToAccount(Cal_SA_UAU_Venda.Pessoas pessoa, Account contaMap)
    {
        contaMap.Name = pessoa.descricao;
        contaMap.Tw1_Data_de_Nascimento__c = Cal_Cls_Infra_Utils.ParseDate(pessoa.dtnasc);
        contaMap.Tw1_Nome_Fantasia__c = pessoa.nomefantasia;
        contaMap.Tw1_Inscricao_Municipal__c = pessoa.inscmunicipal;
        contaMap.Tw1_Inscricao_Estadual__c = pessoa.inscestadual;
        contaMap.Tw1_E_mail__c = pessoa.email;
        contaMap.ShippingStreet = pessoa.endereco;
        contaMap.ShippingState = pessoa.uf;
        contaMap.ShippingCity = pessoa.cidade;
        contaMap.ShippingPostalCode = pessoa.cep;
        contaMap.TW1_Complemento_Endereco_Cobranca__c = pessoa.complemento;
        contaMap.TW1_Profissao_UAU__c = '0';
        
        return contaMap;
    }
    
    private static Account MapPessoaFisicaToAccount(Cal_SA_UAU_Venda.pessoaFisica pessoaFisica, Account contaMap)
    {
        contaMap.Tw1_Identidade__c = pessoaFisica.numerorg;
        contaMap.TW1_Profissao_UAU__c = string.valueOf(pessoaFisica.profissao);
        
        if(pessoaFisica.sexo == '0')
            contaMap.Tw1_Sexo__c = 'Masculino';
        else if(pessoaFisica.sexo == '1')
            contaMap.Tw1_Sexo__c = 'Feminino';
        
        if(pessoaFisica.estadocivil == '0')
            contaMap.Tw1_Estado_Civil__c = 'Separado Judicialmente';
        
        else if(pessoaFisica.estadocivil == '1')
            contaMap.Tw1_Estado_Civil__c = 'Solteiro';
        
        else if(pessoaFisica.estadocivil == '2')
            contaMap.Tw1_Estado_Civil__c = 'Casado';
        
        else if(pessoaFisica.estadocivil == '4')
            contaMap.Tw1_Estado_Civil__c = 'Viuvo';
        
        else if(pessoaFisica.estadocivil == '5')
            contaMap.Tw1_Estado_Civil__c = 'Divorciado';
        
        //contaMap.TW1_Naturalidade__c = pessoaFisica.naturalidade;
        contaMap.TW1_Nacionalidade_st__c = pessoaFisica.nacionalidade;
        return contaMap;
    }
    
    private class MapTelefonesDto
    {
        Account conta {get;set;}
        List<Tw1_Dados_de_Contato_adicionais__c> listaContatosAdcionais {get;set;}
    }
    
    private static MapTelefonesDto MapTelefonesToDadosContatoAdcionais(List<Cal_SA_UAU_Venda.Telefones> telefones, Account conta)
    {
        MapTelefonesDto retorno = new MapTelefonesDto();
        
        List<Tw1_Dados_de_Contato_adicionais__c> listaContatosAdcionais = new List<Tw1_Dados_de_Contato_adicionais__c>();
        
        system.debug('Buscando lista de contatos já existentes');
        List<Tw1_Dados_de_Contato_adicionais__c> listaContatoJaExistente = pessoaRepository.GetContatoAdcioinaisByAccountID(conta.Id);
        system.debug('Lista de contatos já existentes: ' + listaContatoJaExistente);
        delete listaContatoJaExistente;
        system.debug('Lista de contatos já existentes excluído');
        
        for(Cal_SA_UAU_Venda.Telefones telefone : telefones)
        {
            Tw1_Dados_de_Contato_adicionais__c contato = new Tw1_Dados_de_Contato_adicionais__c();
            contato.Tw1_Account__c = conta.Id;
            contato.Tw1_Contato__c = '(' + telefone.ddd + ')'  + telefone.fone;
            contato.RecordTypeId = pessoaRepository.GetTipoContatoAdcionalByTipoTelefoneUAU(telefone.tipoTelefone).Id;
            listaContatosAdcionais.add(contato);
            
            if(telefone.tipoTelefone == '2')
                conta.Tw1_Celular__c  =  contato.Tw1_Contato__c;
            else if(telefone.tipoTelefone == '1')
                conta.Tw1_Telefone_Comercial__c  =  contato.Tw1_Contato__c;
            else if(telefone.tipoTelefone == '0')
                conta.Phone  =  contato.Tw1_Contato__c;
        }
        
        if(listaContatosAdcionais.size() > 0 && (conta.Phone == '' || conta.Phone == null))
            conta.Phone = listaContatosAdcionais[0].Tw1_Contato__c;
        
        retorno.conta = conta;
        retorno.listaContatosAdcionais = listaContatosAdcionais;
        return retorno;
    }
    
    private static Account MapEnderecoCobrancaToAccount(Cal_SA_UAU_Venda.EnderecoCobranca enderecoCobranca, Account contaMap)
    {
        if(enderecoCobranca != null)
        {
            contaMap.BillingStreet = enderecoCobranca.endereco;
            contaMap.BillingState = enderecoCobranca.uf;
            contaMap.BillingCity = enderecoCobranca.cidade;
            contaMap.BillingPostalCode = enderecoCobranca.cep;
        }
        
        return contaMap;
    }
    
    /// Mapeamento de unidade
    private static Product2 ProcessaVendaNaUnidade(Cal_SA_UAU_Venda.Vendas venda, Account conta)
    {
        system.debug('Inicia processo de marcar undiade como vendida: ' + venda.Itens);
        if(venda.Itens == null || venda.Itens.Size()<1)
            throw new Cal_Cls_Infra_Exception('Não foi encontrado nenhum item para venda: ' + venda);
        
        system.debug('Consultando unidade com Empresa: ' + string.valueOf(venda.empresa) + ' Obra: '+ venda.Itens[0].CodigoProduto + ' Número personalização: ' + string.valueOf(venda.Itens[0].CodigoPersonalizacao));
        Product2 unidade = unidadeRepository.GetUnidadePorEmpresaObraPersonalisacao(string.valueOf(venda.empresa), string.valueOf(venda.Itens[0].CodigoProduto), string.valueOf(venda.Itens[0].CodigoPersonalizacao));
        system.debug('Unidade encontrada: ' + unidade);
        
        if(unidade == null)
            throw new Cal_Cls_Infra_Exception('Não foi encontrado a unidade para implantar a venda: ' + venda +  'Empresa: ' + venda.empresa + ' Obra: '+venda.Itens[0].CodigoProduto + 'Número personalização: ' + venda.Itens[0].CodigoPersonalizacao);
        
        unidade.TW1_Numero_Venda__c = string.valueOf(venda.Numero);
        unidade.TW1_Data_da_Venda__c = Cal_Cls_Infra_Utils.ParseDate(venda.datadavenda);
        unidade.TW1_Conta__c = conta.Id;
        
        if(venda.Itens[0].Securitizada)
            unidade.Tw1_Securitizado__c = 'Sim';
        else
            unidade.Tw1_Securitizado__c = 'Não';
        
        system.debug('Mapeando status da undiade, status recebido: ' + venda.statusvenda);
        unidade.Tw1_Status__c ='Vendido';
        
        if(venda.statusvenda == '0')
            unidade.TW1_Status_Venda__c = 'Normal';
        if(venda.statusvenda == '1')
        {    
            unidade.TW1_Status_Venda__c = 'Cancelada';
            unidade.Tw1_Status__c ='Disponível';
        }
        if(venda.statusvenda == '2')
            unidade.TW1_Status_Venda__c = 'Alterada';
        if(venda.statusvenda == '3')
        {    
            unidade.TW1_Status_Venda__c = 'Quitada';
            unidade.Tw1_Status__c ='Quitado';
        }
        if(venda.statusvenda == '4')
            unidade.TW1_Status_Venda__c = 'Em Acerto';
        
        system.debug('Status da undiade mapeado, status definido: ' +  unidade.TW1_Status_Venda__c);
        
        system.debug('Unidade processada: ' + unidade);
        unidadeRepository.Atualizar(unidade);
        system.debug('Unidade inserida com sucesso.');
        
        return unidade;
    }
    
    /// Mapeamento de proprietários de uma unidade
    private static List<TW1_Proprietarios_Unidade__c> MapProprietariosUnidade(Cal_SA_UAU_Venda.ResponseVenda response, Cal_SA_UAU_Venda.Vendas venda, Product2 unidade)
    {        
        List<TW1_Proprietarios_Unidade__c> lista = new List<TW1_Proprietarios_Unidade__c>();
        
        for(Cal_SA_UAU_Venda.Clientes client : venda.Clientes)
        {
            TW1_Proprietarios_Unidade__c proprietarioUnidade = new TW1_Proprietarios_Unidade__c();
            
            system.debug('Consulta conta pelo CPF para verificar existência: ' + client.CpfCnpjDoCliente);
            Account contaDb = pessoaRepository.GetAccountByCPF(client.CpfCnpjDoCliente);
            
            system.debug('Relacionamento conta: ' + contaDb.Id);
            proprietarioUnidade.TW1_Conta__c = contaDb.Id;
            system.debug('Relacionando unidade: ' + unidade.Id);
            proprietarioUnidade.TW1_Unidade__c = unidade.Id;
            
            if(client.emitirboleto)
                proprietarioUnidade.TW1_Emitir_Boleto__c = 'Sim';
            else
                proprietarioUnidade.TW1_Emitir_Boleto__c = 'Não';
            
            proprietarioUnidade.TW1_Percentual_do_Titular__c = client.percentualdotitular;
            
            if(client.tipodecliente == '0')
                proprietarioUnidade.TW1_Tipo__c = 'Titular';     
            else if(client.tipodecliente == '1')
                proprietarioUnidade.TW1_Tipo__c = 'Não titular';     
            else if(client.tipodecliente == '2')
                proprietarioUnidade.TW1_Tipo__c = 'Avalista';     
            
            proprietarioUnidade.TW1_Principal__c = client.principal;
            
            system.debug('Incluindo proprietário: ' + proprietarioUnidade);
            
            lista.add(proprietarioUnidade);
        }
        
        return lista;
    }
    
    /// Mapeamento das parcelas
    private static void ProcessarParcelasVenda(Cal_SA_UAU_Venda.Vendas venda, Product2 unidade)
    {
        system.debug('Inicio de processo de parcelas da venda: ' + venda.Parcelas);
        List<TW1_Parcelas__c> parcelas = new List<TW1_Parcelas__c>();
        
        List<TW1_Parcelas__c> parcelasDaUnidade = parcelasRepository.GetParcelasDeUmaUnidade(unidade.Id);
        system.debug('Lista de parcelas já existêntes que serão excluídas: ' + parcelasDaUnidade);
        parcelasRepository.DeleteLista(parcelasDaUnidade);
        system.debug('Parcelas excluídas');
        
        system.debug('Total de parcelas a serem processadas: ' + venda.Parcelas.size());
        for(Cal_SA_UAU_Venda.Parcelas parcelaDto : venda.Parcelas)
        {
            system.debug('Iniciando map da parcela: ' + parcelaDto);
            TW1_Parcelas__c parcela = new TW1_Parcelas__c();
            
            // realizar maps
            /// Map dominio TW1_amortizacao__c
            if(parcelaDto.amortizacao == '0')
                parcela.TW1_amortizacao__c  = 'Gradiente';
            else if(parcelaDto.amortizacao == '1')
                parcela.TW1_amortizacao__c  = 'Price';
            else if(parcelaDto.amortizacao == '2')
                parcela.TW1_amortizacao__c  = 'SAC';
            else if(parcelaDto.amortizacao == '3')
                parcela.TW1_amortizacao__c  = 'Simples';
            
            /// Map dominio TW1_beginendprice__c
            if(parcelaDto.beginendprice == '0')
                parcela.TW1_beginendprice__c = 'Begin';
            else if(parcelaDto.beginendprice == '1')
                parcela.TW1_beginendprice__c = 'End';
            
            parcela.TW1_capacrescimo__c = parcelaDto.capacrescimo;
            parcela.TW1_capcorrecao__c = parcelaDto.capcorrecao;
            parcela.TW1_capcorrecaoatraso__c = parcelaDto.capcorrecaoatraso;
            parcela.TW1_capdesconto__c = parcelaDto.capdesconto;
            parcela.TW1_capdescontoantecipacao__c = parcelaDto.capdescontoantecipacao;
            parcela.TW1_capdescontocondicional__c = parcelaDto.capdescontocondicional;
            parcela.TW1_capdescontocusta__c = parcelaDto.capdescontocusta;
            parcela.TW1_capjuros__c = parcelaDto.capjuros;
            parcela.TW1_capjurosatraso__c = parcelaDto.capjurosatraso;
            parcela.TW1_capmulta__c = parcelaDto.capmulta;
            parcela.TW1_capprincipal__c = parcelaDto.capprincipal;
            parcela.TW1_caprepasse__c = parcelaDto.caprepasse;
            parcela.TW1_captaxaboleto__c = parcelaDto.captaxaboleto;
            
            parcela.TW1_cobrarcorrecaocusta__c = MapCobrarNaoCobrar(parcelaDto.cobrarcorrecaocusta);
            parcela.TW1_cobrarimpostocusta__c = MapCobrarNaoCobrar(parcelaDto.cobrarimpostocusta);
            parcela.TW1_cobrarjurosatrasocusta__c = MapCobrarNaoCobrar(parcelaDto.cobrarjurosatrasocusta);
            parcela.TW1_cobrarjurosprimeiroperiodo__c = MapCobrarNaoCobrar(parcelaDto.cobrarjurosprimeiroperiodo);
            parcela.TW1_cobrarjurosprorata__c = MapCobrarNaoCobrar(parcelaDto.cobrarjurosprorata);
            parcela.TW1_cobrarjurosprorataprimeiromes__c = MapCobrarNaoCobrar(parcelaDto.cobrarjurosprorataprimeiromes);
            parcela.TW1_cobrarmultacusta__c = MapCobrarNaoCobrar(parcelaDto.cobrarmultacusta);
            parcela.TW1_cobrartaxaadministracaocusta__c = MapCobrarNaoCobrar(parcelaDto.cobrartaxaadministracaocusta);
            
            parcela.TW1_datacalculoreajuste__c = Cal_Cls_Infra_Utils.ParseDate(parcelaDto.datacalculoreajuste);
            parcela.TW1_datainicioperiodoaluguel__c = Cal_Cls_Infra_Utils.ParseDate(parcelaDto.datainicioperiodoaluguel);
            parcela.TW1_datainicioprimeirojuros__c = Cal_Cls_Infra_Utils.ParseDate(parcelaDto.datainicioprimeirojuros);
            parcela.TW1_datainicioreajuste__c = Cal_Cls_Infra_Utils.ParseDate(parcelaDto.datainicioreajuste);
            parcela.TW1_datainiciosegundojuros__c = Cal_Cls_Infra_Utils.ParseDate(parcelaDto.datainiciosegundojuros);
            parcela.TW1_dataprimeiraparcelagrupo__c = Cal_Cls_Infra_Utils.ParseDate(parcelaDto.dataprimeiraparcelagrupo);
            parcela.TW1_dataprorrogacao__c = Cal_Cls_Infra_Utils.ParseDate(parcelaDto.dataprorrogacao);
            parcela.TW1_datarecebimento__c = Cal_Cls_Infra_Utils.ParseDate(parcelaDto.datarecebimento);
            parcela.TW1_datavencimento__c = Cal_Cls_Infra_Utils.ParseDate(parcelaDto.datavencimento);
            parcela.Tw1_diascarenciacorrecaoatraso__c = parcelaDto.diascarenciacorrecaoatraso;
            parcela.Tw1_diascarenciamultajurosatraso__c = parcelaDto.diascarenciamultajurosatraso;
            parcela.Tw1_frequenciavencimento__c = parcelaDto.frequenciavencimento;
            parcela.Tw1_grupoplanoindexador__c = string.valueOf(parcelaDto.grupoplanoindexador);
            parcela.Tw1_indicereajuste__c = parcelaDto.indicereajuste;
            parcela.Tw1_numeroparcela__c = string.valueOf(parcelaDto.numeroparcela);
            parcela.TW1_numeroparcelageral__c = string.valueOf(parcelaDto.numeroparcelageral);
            parcela.Tw1_observacaocusta__c = parcelaDto.observacaocusta;
            
            /// Map dominio Tw1_origemcusta__c
            if(parcelaDto.origemcusta == '0')
                parcela.Tw1_origemcusta__c = 'Obra';
            else if(parcelaDto.origemcusta == '1')
                parcela.Tw1_origemcusta__c = 'Administração';
            
            parcela.Tw1_origemparcela__c = string.valueOf(parcelaDto.origemparcela);
            parcela.Tw1_padraocobranca__c = string.valueOf(parcelaDto.padraocobranca);
            
            /// Map dominio TW1_parcelarecebida__c
            if(parcelaDto.parcelarecebida)
                parcela.TW1_parcelarecebida__c = 'Sim';
            else
                parcela.TW1_parcelarecebida__c = 'Não';
            
            /// Map dominio Tw1_repassarvalorlocadorcusta__c
            if(parcelaDto.repassarvalorlocadorcusta == '0')
                parcela.Tw1_repassarvalorlocadorcusta__c = 'Não Repassar';
            else if(parcelaDto.repassarvalorlocadorcusta == '1')
                parcela.Tw1_repassarvalorlocadorcusta__c = 'Repassar';
            
            parcela.Tw1_taxaprimeirojuros__c = parcelaDto.taxaprimeirojuros;
            parcela.Tw1_taxasegundojuros__c = parcelaDto.taxasegundojuros;
            parcela.TW1_tipodacusta__c = string.valueOf(parcelaDto.tipodacusta);
            parcela.Tw1_tipoparcela__c = parcelaDto.tipoparcela;
            
            /// Map dominio Tw1_repassarvalorlocadorcusta__c
            if(parcelaDto.tiposeguro == '0')
                parcela.Tw1_tiposeguro__c = 'MIP';
            else if(parcelaDto.tiposeguro == '1')
                parcela.Tw1_tiposeguro__c = 'DFI';
            
            parcela.Tw1_totalparcelasdogrupo__c = string.valueOf(parcelaDto.totalparcelasdogrupo);
            parcela.Tw1_totalparcelasdogrupoinformado__c = string.valueOf(parcelaDto.totalparcelasdogrupoinformado);
            parcela.Tw1_usuariocedeudesconto__c = parcelaDto.usuariocedeudesconto;
            parcela.Tw1_usuariorecebeu__c = parcelaDto.usuariorecebeu;
            parcela.TW1_valoracrescimo__c = parcelaDto.valoracrescimo;
            parcela.Tw1_valoracrescimoconfirmado__c = parcelaDto.valoracrescimoconfirmado;
            parcela.Tw1_valorcorrecao__c = parcelaDto.valorcorrecao;
            parcela.Tw1_valorcorrecaoatraso__c = parcelaDto.valorcorrecaoatraso;
            parcela.Tw1_valorcorrecaoatrasoconfirmado__c = parcelaDto.valorcorrecaoatrasoconfirmado;
            parcela.TW1_valorcorrecaoconfirmado__c = parcelaDto.valorcorrecaoconfirmado;
            parcela.Tw1_valorcorrecaoembutida__c = parcelaDto.valorcorrecaoembutida;
            parcela.Tw1_valordesconto__c = parcelaDto.valordesconto;
            parcela.Tw1_valordescontoadiantamento__c = parcelaDto.valordescontoadiantamento;
            parcela.Tw1_valordescontoadiantamentoconfirmado__c = parcelaDto.valordescontoadiantamentoconfirmado;
            parcela.TW1_valordescontocondicional__c = parcelaDto.valordescontocondicional;
            parcela.TW1_valordescontocondicionalconfirmado__c = parcelaDto.valordescontocondicionalconfirmado;
            parcela.Tw1_valordescontoconfirmado__c = parcelaDto.valordescontoconfirmado;
            parcela.Tw1_valorjurosatraso__c = parcelaDto.valorjurosatraso;
            parcela.Tw1_valorjurosatrasoconfirmado__c = parcelaDto.valorjurosatrasoconfirmado;
            parcela.Tw1_valorjuroscontrato__c = parcelaDto.valorjuroscontrato;
            parcela.Tw1_valorjuroscontratoconfirmado__c = parcelaDto.valorjuroscontratoconfirmado;
            parcela.Tw1_valorjuroscontratoembutido__c = parcelaDto.valorjuroscontratoembutido;
            parcela.TW1_valorjuroscontratoembutidoconfirmado__c = parcelaDto.valorjuroscontratoembutidoconfirmado;
            parcela.Tw1_valormulta__c = parcelaDto.valormulta;
            parcela.Tw1_valormultaconfirmado__c = parcelaDto.valormultaconfirmado;
            parcela.Tw1_valorprincipal__c = parcelaDto.valorprincipal;
            parcela.TW1_valorprincipalconfirmado__c = parcelaDto.valorprincipalconfirmado;
            parcela.Tw1_valorresiduo__c = parcelaDto.valorresiduo;
            
            parcela.TW1_Unidade__c = unidade.Id;
            
            parcelas.add(parcela);
        }
        
        system.debug('Inserindo parcelas: ' + parcelas);
        insert parcelas;
    }
    
    private static string MapCobrarNaoCobrar(string uauString)
    {       
        if(uauString == '0')
            return 'Não cobrar';
        else if(uauString == '1')
            return 'Cobrar';
        
        return '';
    }
}