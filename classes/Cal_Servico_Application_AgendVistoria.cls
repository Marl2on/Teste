public with sharing class Cal_Servico_Application_AgendVistoria {
    
    Cal_Servico_Repo_AggregateAgendVistoria agendamentoRepository = new Cal_Servico_Repo_AggregateAgendVistoria();
    
    public List<Cal_Servico_Ctr_AgendVistoria.AgendamentoDto> GetListaAgendamentosPorEmpreendimentoEDia(string idEmpreendimento, Date dataCorrente)
    {
        system.debug('Iniciando consulta de agendamentos para o dia ' + dataCorrente + ' no empreendimento ' + idEmpreendimento);
        
        if(idEmpreendimento == '' || dataCorrente == null)
            throw new Cal_Cls_Infra_Exception('Selecione um empreendimento e uma data para realizar a consulta aos agendamentos.');
        
        List<AggregateResult> consulta = agendamentoRepository.GetTotalAgendamentosPorEmpreendimentoEDia(idEmpreendimento,dataCorrente);
        system.debug('Retorno da consulta: ' + consulta);
        
        system.debug('Iniciando mapeamento para Dto');
        return MapListaAggregateResultAgendamentosParaListaAgenddamentoDto(consulta);
    }
    
    /// Realiza o mapeamento de AggregateResult agendamento para Dto
    public List<Cal_Servico_Ctr_AgendVistoria.AgendamentoDto> MapListaAggregateResultAgendamentosParaListaAgenddamentoDto(List<AggregateResult> source)
    {
        List<Cal_Servico_Ctr_AgendVistoria.AgendamentoDto> retorno = new List<Cal_Servico_Ctr_AgendVistoria.AgendamentoDto>();
        
        for(AggregateResult linha : source)
        {
            system.debug('Processando linha: ' + linha);
            Cal_Servico_Ctr_AgendVistoria.AgendamentoDto dto = new Cal_Servico_Ctr_AgendVistoria.AgendamentoDto();
            dto.Horario = (string)linha.get('TW1_Hora__c');
            dto.Quantidade = (integer)linha.get('expr0');
            retorno.add(dto);
        }
        
        system.debug('Fim do processamento');
        return retorno;        
    }
    
    public TW1_Agendamento__c SalvarAgendamento(Case caso, TW1_Agendamento__c agendamento)
    {        
        if(Agendamento.TW1_Hora__c == null || agendamento.TW1_Hora__c == '' )
            throw new Cal_Cls_Infra_Exception('Selecione um horário.');
        
        agendamento.TW1_Caso__c = caso.Id;
        agendamento.TW1_Empreendimento__c = caso.TW1_ID_Empreendimento__c;
        agendamento.TW1_Unidade__c = caso.TW1_Unidade__c;
        agendamento.TW1_Conta__c = caso.AccountId;
        agendamento.TW1_Contato__c = caso.ContactId;
        agendamento.TW1_Status__c = 'Agendado';
        upsert agendamento;
        return agendamento;
    }    
}