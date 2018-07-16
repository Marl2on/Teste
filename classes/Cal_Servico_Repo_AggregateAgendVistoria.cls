public class Cal_Servico_Repo_AggregateAgendVistoria {
    
    public List< AggregateResult> GetTotalAgendamentosPorEmpreendimentoEDia(string idEmpreendimento, date dataCorrente)
    {
        List<AggregateResult> retorno = [select TW1_Hora__c, COUNT(id) 
                                         from TW1_Agendamento__c
                                         Where TW1_Empreendimento__c = :idEmpreendimento
                                         AND TW1_Data_do_Agendamento__c = :dataCorrente
                                         AND (TW1_Status__c  = 'Novo' OR TW1_Status__c ='Agendado')
                                         Group by TW1_Hora__c];
        
        return retorno;        
    }  
}