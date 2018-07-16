public class Cal_Servico_Application_Inadimplencia {
    
    private static Cal_Servico_Repo_AggregateInadiple inadimplenciaRepository = new Cal_Servico_Repo_AggregateInadiple();
    
    private static Cal_SA_UAU_Inadimplencia inadimplenciaServiceAgent = new Cal_SA_UAU_Inadimplencia();
    
    private static Cal_Servico_Repo_AggregatePessoa accountRepository = new Cal_Servico_Repo_AggregatePessoa();
    
    private static Cal_Servico_Repo_AggregateProduct productRepository = new Cal_Servico_Repo_AggregateProduct();
        
    /// Repositório de log no integração
    private static Cal_Servico_Repo_AggregateLogIntegracao logIntegracaoRepository = new Cal_Servico_Repo_AggregateLogIntegracao();
    
	public void atualizarInserirFaseInadimplencia(TW1_Inadimplencia__c oldSo, TW1_Inadimplencia__c so){
        System.debug('--- INÍCIO DO MÉTODO atualizarInserirFaseInadimplencia ---');
        
        if(Cal_Cls_Infra_Utils.ExisteCampo(so, 'TW1_Fase__c') && Cal_Cls_Infra_Utils.ExisteCampo(oldSo, 'TW1_Fase__c')){
                
            System.debug('--- O campo TW1_Fase__c dos parâmetros do método (so e oldSo) existem ---');
            
            if(!so.TW1_Fase__c.equals(oldSo.TW1_Fase__c)){
                
                System.debug('--- O status (TW1_Fase__c) do so e do oldSo são diferentes (a fase mudou) ---');
                
                System.debug('--- Chamando o método atualizaInadimplenciaFase do Cal_Servico_Application_Inadimplen_Fases com o oldSo ---');
                System.debug('oldSo:');
                System.debug(oldSo);
                Cal_Servico_Application_Inadimplen_Fases.atualizaInadimplenciaFase(oldSo);
                
                System.debug('--- Chamando o método insereInadimplenciaFase do Cal_Servico_Application_Inadimplen_Fases com o so ---');
                System.debug('so:');
                System.debug(so);
                Cal_Servico_Application_Inadimplen_Fases.insereInadimplenciaFase(so);
            }
        }
    }
    
    public void inserirFaseInadimplencia(TW1_Inadimplencia__c so){
        System.debug('--- INÍCIO DO MÉTODO inserirFaseInadimplencia (sem oldSo) ---');
        
        if(Cal_Cls_Infra_Utils.ExisteCampo(so, 'TW1_Fase__c') ){
                
            System.debug('--- O campo TW1_Fase__c do parâmetro do método (so) existe ---');
            
            System.debug('--- Chamando o método insereInadimplenciaFase do Cal_Servico_Application_Inadimplen_Fases com o so ---');
            System.debug('so:');
            System.debug(so);
            Cal_Servico_Application_Inadimplen_Fases.insereInadimplenciaFase(so);
        }
    }
    
    public void atualizarFaseInadimplencia(TW1_Inadimplencia__c oldSo){
        System.debug('--- INÍCIO DO MÉTODO atualizarFaseInadimplencia (sem so) ---');
        
        if(
            Cal_Cls_Infra_Utils.ExisteCampo(oldSo, 'TW1_Fase__c')
            && oldSo.TW1_Fase__c == Cal_Repo_LinhaTempoInadimplencia.getLastFaseValue()
          ){
              System.debug('--- Chamando o método atualizaInadimplenciaFase do Cal_Servico_Application_Inadimplen_Fases com o oldSo ---');
              System.debug('oldSo:');
              System.debug(oldSo);
              Cal_Servico_Application_Inadimplen_Fases.atualizaInadimplenciaFase(oldSo);
        }
    }
    
    public void PausarInadimplencia(Product2 unidade)
    {
        system.debug('Pausando uma inadimplência');
        string idInadiplencia = unidade.TW1_ID_Inadimplencia__c;
        system.debug('ID da inadimplencia informado para pausa: ' + idInadiplencia);
        
        TW1_Inadimplencia__c inadimplencia = inadimplenciaRepository.GetInadimplenciaByID(idInadiplencia);
        system.debug('Inadimplencia recuperada: ' + inadimplencia);
        
        if(inadimplencia != null)
        {      
        	inadimplencia.TW1_Etapa_pre_pausa__c = inadimplencia.TW1_Etapa__c;
        	system.debug('Etapa atual: ' + inadimplencia.TW1_Etapa__c);
        	inadimplencia.TW1_Etapa__c = 'Pausada';
        
        	system.debug('Salvando inadimplencia');
        	inadimplenciaRepository.Modify(inadimplencia);
            system.debug('Inadimplencia salva');
        }
    }
    
    public void ReiniciarInadimplencia(Product2 unidade)
    {
      system.debug('Pausando uma inadimplência');
        string idInadiplencia = unidade.TW1_ID_Inadimplencia__c;
        system.debug('ID da inadimplencia informado para pausa: ' + idInadiplencia);
        
         TW1_Inadimplencia__c inadimplencia = inadimplenciaRepository.GetInadimplenciaByID(idInadiplencia);
         system.debug('Inadimplencia recuperada: ' + inadimplencia);
           
        if(inadimplencia != null)
        {   
            inadimplencia.TW1_Etapa__c = inadimplencia.TW1_Etapa_pre_pausa__c;
            system.debug('Recuperando status: ' + inadimplencia.TW1_Etapa__c);
            inadimplencia.TW1_Etapa_pre_pausa__c = null;
            
            system.debug('Salvando inadimplencia');
            inadimplenciaRepository.Modify(inadimplencia);
            system.debug('Inadimplencia salva');
        }
    }
    
    /// Método para enviar a solicitação do processo de inadimplência no UAU.
    @future(callout = true)
    public static void EnviarSolicitacaoDeProcessoDeInadimplencia()
    {
        system.debug('Iniciando chamada ao serviço de verificar inadimplencia');
        inadimplenciaServiceAgent.SolicitarVerificacaoInadimplencia();
        system.debug('Processo iniciado - Aguardando callback');
    }
    
    public void ProcessarCallBackInadimplencia(List<Cal_Servico_Serv_Inadimplencia.RequestInadimplencia> request)
    {
        Log_Integracao__c log = logIntegracaoRepository.IncluirLogIntegracao('CallBack_Inadimplencia','Processo de callBack da inadimplencia.','-', 'Verifcicar anexos', 'TW1_CallBackConcluido');
      
        List<Cal_Servico_Serv_Inadimplencia.RequestInadimplencia> pacote = new List<Cal_Servico_Serv_Inadimplencia.RequestInadimplencia>();
        integer countPacote = 0;
        integer countTotalDePacotes = 0;
        
        system.debug('Fechando inadimplencias');
        FecharInadimplencias(JSON.serialize(request));
        
        for(Cal_Servico_Serv_Inadimplencia.RequestInadimplencia linha : request)
        {
        	if(countPacote > 50)
            {
                system.debug('Enviando pacote: ' + pacote);
            	countTotalDePacotes = countTotalDePacotes + 1;
                Cal_Servico_Application_Inadimplencia.ProcessarCallBackInadimplenciaPart(JSON.serialize(pacote), log.Id, countTotalDePacotes);
                countPacote = 0;
                pacote = new List<Cal_Servico_Serv_Inadimplencia.RequestInadimplencia>();
                system.debug('Contador de pacotes: ' + countTotalDePacotes);
            }
            else
            {	
                pacote.add(linha);    
                countPacote = countPacote + 1;
            }
        }
        
        system.debug('Mandando ultimo pacote: ' + pacote);
        Cal_Servico_Application_Inadimplencia.ProcessarCallBackInadimplenciaPart(JSON.serialize(pacote), log.Id, (countTotalDePacotes + 1));
               
        integer totalRegistrosProcessados = (50 * countTotalDePacotes) + pacote.size();
        system.debug('Total de registros processados: ' + totalRegistrosProcessados);
    }
    
    /// Método para processar callback do serviço de inadimplencia
    @future
    public static void ProcessarCallBackInadimplenciaPart(string jsonRequestPart, string idLog, integer pacote)
    {
        /// Realizando teste do Future para verificar se vai processar muitos registros.
        List<Cal_Servico_Serv_Inadimplencia.RequestInadimplencia> request =  (List<Cal_Servico_Serv_Inadimplencia.RequestInadimplencia> )JSON.deserialize(jsonRequestPart, List<Cal_Servico_Serv_Inadimplencia.RequestInadimplencia>.class);
        
        system.debug('Iniciando processo de callback com request: ' + request);
       
        string textoAnexoLogProcessamento = '';
        boolean ocorreuErro = false;
        
        /// Executar processo de callback
        List<TW1_Inadimplencia__c> listaInadimplencia = new List<TW1_Inadimplencia__c>();
        
        List<ProcessamentoInadimplenciaPorPessoaDto> listaInadimplenciasProcessadas = new List<ProcessamentoInadimplenciaPorPessoaDto>();
                
        for(Cal_Servico_Serv_Inadimplencia.RequestInadimplencia corrente : request)
        {
            try
            {
                system.debug('Incia processamento da pessoa: ' + corrente);
                ProcessamentoInadimplenciaPorPessoaDto processamentoPessoa = ProcessaInadimplenciaPorPessoa(corrente);
                listaInadimplenciasProcessadas.add(processamentoPessoa);
                
                for(ProcessamentoInadimplenciaPorPessoaVendaDto processoVenda : processamentoPessoa.listaInadimplencia)
                {
                    system.debug('Incluindo inadimplencia na lista para ser incluída ou atualizada: ' + processoVenda.inadimplencia);
                	listaInadimplencia.add(processoVenda.inadimplencia);    
                    
                    /// Crair tratativa de log de processamento com sucesso
                	textoAnexoLogProcessamento = textoAnexoLogProcessamento
                    + '\n' 
                    + 'Inadimplencia da conta ' +  processamentoPessoa.pessoa.Id + ' da unidade ' + processoVenda.unidade.Id + ' processada com sucesso.';
                }
                                       
            }
            catch(Exception e)
            {
                system.debug('Erro em processar inadimplencia: ' + e.getMessage());
				ocorreuErro = true;                            
                textoAnexoLogProcessamento = textoAnexoLogProcessamento 
                    + '\n' 
                    + 'Inadimplencia código pessoa ' +  corrente.CodigoPessoa + ' processada com erro. Detalhe: ' + e.getMessage();
            }                
        }       
        
        system.debug('Atualizando ou inserindo as inadimplencias: ' + listaInadimplencia);
        Upsert listaInadimplencia;
           
        List<TW1_Parcela_Inadimplencia__c> parcelasSeremIncluidas = new List<TW1_Parcela_Inadimplencia__c>();
        
        system.debug('Inciando processo de inclusão de parcelas');
        /// Prcoessar processos de inadimplencias realizado
        for(ProcessamentoInadimplenciaPorPessoaDto processo : listaInadimplenciasProcessadas)
        {
            /// Percorre lista de inadimplencia por pessoa
            for(ProcessamentoInadimplenciaPorPessoaVendaDto venda : processo.listaInadimplencia)
            {
                system.debug('Consultando para verificar se já existe uma inadimplencia para o mesmo cliente e unidade');
            	//TW1_Inadimplencia__c inadimplencia =  inadimplenciaRepository.GetInadimplenciaByAccountIdEProductId(processo.pessoa.Id, venda.unidade.Id);
                
                /// Percorre lista de inadimplencias incluídas para não realizar consultas novamente pelo SOQL já que temos um limite.
                for(TW1_Inadimplencia__c inadimplencia :  listaInadimplencia)
                {
                    if(inadimplencia.TW1_Cliente_Principal__c == processo.pessoa.Id && inadimplencia.TW1_Unidade__c == venda.unidade.id)
                    {
                        system.debug('Encontrou inadimplencia para ser inseridas relacionadas as parcelas da venda corrente: ' + inadimplencia);
                        
                        for(TW1_Parcela_Inadimplencia__c parcelaCorrente : venda.parcelas)
                        {
                            parcelaCorrente.TW1_Inadimplencia__c = inadimplencia.Id;
                            parcelasSeremIncluidas.add(parcelaCorrente);
                        }
                    }
                }
            }
        }
        
        system.debug('Incluindo parcelas: ' + parcelasSeremIncluidas);
        insert parcelasSeremIncluidas;
                  
        /// Montando anexo para gravar o registro de operações, isso foi feito por conta do limite do campo string no salesforce
        if(textoAnexoLogProcessamento != null || textoAnexoLogProcessamento != '')
        	MontarAttach(textoAnexoLogProcessamento, idLog, pacote);
        
        system.debug('Processo de callback finalizado');
    }
        
    private class ProcessamentoInadimplenciaPorPessoaDto
    {
        Account pessoa {get;set;}
        
        List<ProcessamentoInadimplenciaPorPessoaVendaDto> listaInadimplencia {get;set;}
    }
    
    private class ProcessamentoInadimplenciaPorPessoaVendaDto
    {
        Product2 unidade {get;set;}
       
        TW1_Inadimplencia__c inadimplencia {get;set;}
        
        List<TW1_Parcela_Inadimplencia__c> parcelas {get;set;}
    } 
    
    /// Realiza o processamento das inadimplencias de um determinado cliente
    private static ProcessamentoInadimplenciaPorPessoaDto ProcessaInadimplenciaPorPessoa(Cal_Servico_Serv_Inadimplencia.RequestInadimplencia request)
    {
        ProcessamentoInadimplenciaPorPessoaDto retornoProcesso = new ProcessamentoInadimplenciaPorPessoaDto();
        
        List<TW1_Inadimplencia__c> listaInadimplencias = new List<TW1_Inadimplencia__c>();
        
        /// Buscar Account
        system.debug('Buscando Account');
        Account pessoa = accountRepository.GetAccountByCodigoUau(request.CodigoPessoa);
        system.debug('Account encontrado: ' + pessoa);
        
        if(pessoa == null)
            throw new Cal_Cls_Infra_Exception('Não foi encontrado a pessoa com o código do UAU ' + request.CodigoPessoa);
        
        retornoProcesso.pessoa = pessoa;
		retornoProcesso.listaInadimplencia = new List<ProcessamentoInadimplenciaPorPessoaVendaDto>();
        
        for(Cal_Servico_Serv_Inadimplencia.Vendas venda : request.Vendas)
        {
            ProcessamentoInadimplenciaPorPessoaVendaDto processamentoVenda = new ProcessamentoInadimplenciaPorPessoaVendaDto();
            
        	/// Buscar unidade
	        system.debug('Buscando Unidade');
        	Product2 unidade = productRepository.GetUnidadePorEmpresaObraVenda(string.valueOf(venda.empresa), venda.obra, string.valueOf(venda.venda));
            unidade.TW1_Valor_Principal_Inadimplencia__c = venda.totalprincipal;
            unidade.TW1_Valor_Reajustado_Inadimplencia__c = venda.totalprincipalreaj;
            productRepository.Atualizar(unidade);
            
            processamentoVenda.unidade = unidade;
                
            system.debug('Crianddo uma inadimplencia');
            TW1_Inadimplencia__c inadimplencia =  new TW1_Inadimplencia__c();
            
            system.debug('Consultando para verificar se já existe uma inadimplencia para o mesmo cliente e unidade');
            TW1_Inadimplencia__c  inadimplenciaBd =  inadimplenciaRepository.GetInadimplenciaByAccountIdEProductIdAtivas(pessoa.Id, unidade.Id);
            
            if(inadimplenciaBd != null)
                inadimplencia = inadimplenciaBd;
            
            system.debug('Realizando mapeamento da nova inadimplencia');
            processamentoVenda.inadimplencia = MapInadimplencia(pessoa, unidade, venda, inadimplencia);
            
            system.debug('Incianco map de parcelas');
            processamentoVenda.parcelas  = MapParcelasInadimplencia(venda.parcelas);
            
            system.debug('Venda processada: ' + processamentoVenda);
            retornoProcesso.listaInadimplencia.add(processamentoVenda);
        }
        
        system.debug('Retorno do processo de inadimplencia da pessoa ' + request.CodigoPessoa + ': ' + retornoProcesso);
        return retornoProcesso;
    }
    
    private static TW1_Inadimplencia__c MapInadimplencia(Account conta, Product2 unidade, Cal_Servico_Serv_Inadimplencia.Vendas venda, TW1_Inadimplencia__c inadimplencia)
    {
      	inadimplencia.TW1_Cliente_Principal__c = conta.Id;
        inadimplencia.TW1_Unidade__c = unidade.Id;
        inadimplencia.TW1_Valor_Reajustado__c = venda.totalprincipalreaj;
		inadimplencia.TW1_Valor_Principal__c = venda.totalprincipal;
		inadimplencia.TW1_Numero_Parcelas__c = venda.numparcelas;
		inadimplencia.TW1_Tempo_Inadimplencia__c = venda.tempoinadimplencia;
		inadimplencia.TW1_Maior_Data_Vencimento__c = Date.valueOf(venda.maiordatavencimento);
        
        List<TW1_Parcela_Inadimplencia__c> parcelas = new List<TW1_Parcela_Inadimplencia__c>();
        
        system.debug('Verificando se a inadimplencia já existe, caso sim consulta as parcelas.');
        if(inadimplencia.Id != null)
        {	
            parcelas = inadimplenciaRepository.GetParcelasDeUmaInadimplencia(inadimplencia.Id);
        	system.debug('Lista de parcelas de uma inadimplencia a seren excluídas: ' + parcelas);
            delete parcelas;
        }
                
        system.debug('Inadimplencia a ser retornada apos map: ' + inadimplencia);
        return inadimplencia;
    }
    
    private static List<TW1_Parcela_Inadimplencia__c> MapParcelasInadimplencia(List<Cal_Servico_Serv_Inadimplencia.Parcelas> parcelas)
    {
        system.debug('Processando parcelas: ' + parcelas);
        List<TW1_Parcela_Inadimplencia__c> listaParcelasIncluir = new List<TW1_Parcela_Inadimplencia__c>();
        
        for(Cal_Servico_Serv_Inadimplencia.Parcelas parcela : parcelas)
        {
            system.debug('Processando parcelas: ' + parcela);
        	TW1_Parcela_Inadimplencia__c parcelaIncluir = new TW1_Parcela_Inadimplencia__c();
            parcelaIncluir.TW1_Numero_Parcela__c = string.valueOf(parcela.numeroparcela);
            parcelaIncluir.TW1_Numero_Geral_Parcela__c = string.valueOf(parcela.numeroparcelageral);
            parcelaIncluir.TW1_Parcela_Recebida__c = parcela.parcelarecebida;
            parcelaIncluir.TW1_Tipo_Parcela__c = parcela.tipoparcela;
            parcelaIncluir.TW1_Valor_Reajustado__c = parcela.valorreaj;
            parcelaIncluir.TW1_Valor__c = parcela.valor;
            parcelaIncluir.TW1_Data_Vencimento__c = Date.valueOf(parcela.datavencimento);
            parcelaIncluir.TW1_Data_recebimento__c = Date.valueOf(parcela.datarecebimento);
            parcelaIncluir.TW1_Data_Prevista_Deposito__c = Date.valueOf(parcela.dataprevistadeposito);
            parcelaIncluir.TW1_Deposito__c = parcela.deposito;
            parcelaIncluir.TW1_Conciliado__c = parcela.conciliado;
           
            system.debug('Inclcuindo parcela na lista: ' + parcelaIncluir);
            listaParcelasIncluir.add(parcelaIncluir);
        }
        
        return listaParcelasIncluir;
    }
    
    @future
    public static void FecharInadimplencias(string jsonRequest)
    {
        List<Cal_Servico_Serv_Inadimplencia.RequestInadimplencia> request =  (List<Cal_Servico_Serv_Inadimplencia.RequestInadimplencia> )JSON.deserialize(jsonRequest, List<Cal_Servico_Serv_Inadimplencia.RequestInadimplencia>.class);
        
        List<TW1_Inadimplencia__c> listaInadimplenciasAtivas = inadimplenciaRepository.GetInadimplenciasAtivas();
        system.debug('Lista de inadimplencias ativas: ' + listaInadimplenciasAtivas);
        List<TW1_Inadimplencia__c> listaAtualizar = new List<TW1_Inadimplencia__c>();
        
        for(TW1_Inadimplencia__c inadimplenciacorrente : listaInadimplenciasAtivas)
        {
            boolean encontrada = false;
            
            for(Cal_Servico_Serv_Inadimplencia.RequestInadimplencia linha : request)
            {
                for(Cal_Servico_Serv_Inadimplencia.Vendas vendaVerificar : linha.Vendas)
                {
                    if(inadimplenciacorrente.TW1_Codigo_Empreendimento_UAU__c == vendaVerificar.obra 
                       && inadimplenciacorrente.TW1_Codigo_Empresa_UAU__c == string.valueOf(vendaVerificar.empresa)
                       && inadimplenciacorrente.TW1_Numero_Venda__c == string.valueOf(vendaVerificar.venda))
                        encontrada = true;
                }
            }
            
            if(!encontrada)
            {
                system.debug('Fechando  a inadimplencia: ' + inadimplenciacorrente.id);
                inadimplenciacorrente.TW1_Fase__c = 'Concluída';
                inadimplenciacorrente.TW1_Etapa__c =  'Encerrada pelo UAU';
                listaAtualizar.add(inadimplenciacorrente);
            }
        }
        
        system.debug('Lista para fechar inadimplencia: ' + listaAtualizar);
        update listaAtualizar;
    }
    
    private static void MontarAttach(string texto, string idLog, integer pacote)
    {
        Attachment attach = new Attachment();
        attach.contentType = 'text/plain; charset=UTF-8';
        attach.name = 'Log_Processamento_CallBack'+ pacote +'.txt';
        attach.parentId = idLog;
        attach.body =   Blob.valueOf(texto);
        insert attach;
    }

    public void FecharAcoesNaMudancaDeFase(TW1_Inadimplencia__c oldSo, TW1_Inadimplencia__c so)
    {        
        system.debug('Verificando necessidade de fechar ações da fase anterior');
        
        system.debug('Comparando fases: Old = ' + oldSo.TW1_Fase__c + ' Atual = ' + so.TW1_Fase__c);
        if(oldSo.TW1_Fase__c != so.TW1_Fase__c)
        {
            List<TW1_Acoes__c> listaAcoesFechar =  inadimplenciaRepository.GetAcoesEmAbertoByInadimplenicaEFase(so.Id, oldSo.TW1_Fase__c);
            for(TW1_Acoes__c acao : listaAcoesFechar)
            {
				system.debug('Fechando ação: ' + acao);
                acao.TW1_Cancelado_Integracao__c = true;
                //acao.TW1_Status__c = 'TW1_Cancelada';
                //acao.TW1_Motivo_Cancelamento__c = 'Cancelada devido a mudança de Responsável pela Inadimplência';
            }
            
            system.debug('Autalizando lista: ' + listaAcoesFechar);
            update listaAcoesFechar;
        }        
    }
}