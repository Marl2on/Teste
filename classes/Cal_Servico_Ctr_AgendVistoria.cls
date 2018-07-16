public with sharing class Cal_Servico_Ctr_AgendVistoria
{
    private Cal_Servico_Application_Cases casoApplication = new  Cal_Servico_Application_Cases();
    private Cal_Servico_Application_AgendVistoria agendamentoApplication = new  Cal_Servico_Application_AgendVistoria();
    
    public Case Caso
    {
        get;set;
    }
    
    public TW1_Agendamento__c Agendamento
    {
        get;set;
    }
    
    public List<AgendamentoDto> AgendamentosDiaCorrente
    {
        get;set;
    }
    
    //DTO para gerar relatório de agendamentos por horário
    public class AgendamentoDto
    {
        public string Horario
        {
            get;set;
        }
        public Integer Quantidade
        {
            get;set;
        }
    }
    
    public Cal_Servico_Ctr_AgendVistoria()
    {
        system.debug('Criando instancia da controler agendamento de vistoria');
        system.debug('Parâmetros recebidos: ' +  ApexPages.currentPage().getParameters());
        
        string idCaso = ApexPages.currentPage().getParameters().get('idcaso');
        
        string idAgendamento = ApexPages.currentPage().getParameters().get('idAgendamento');
        
        if(idAgendamento == null || idAgendamento == '')
            Agendamento = new TW1_Agendamento__c();            
        
        CarregarDadosCaso(idCaso);      
    }
    
    private void CarregarDadosCaso(string idCaso)
    {
        system.debug('Carregando dados do caso com ID: '+ idCaso);
        Caso = casoApplication.GetCasoByID(idCaso);
        
        if(Caso.TW1_Data_inicio_para_agendar_vistoria__c > Date.today())
            setDataAgendamento(Caso.TW1_Data_inicio_para_agendar_vistoria__c);
        else
            setDataAgendamento( Date.today());
        
        CarregarAgendamentosDoDia();       
    }
    
    public PageReference CarregarAgendamentosDoDia()
    {
        system.debug('Carregando lista de agendamentos do dia');
        system.debug(Agendamento.TW1_Data_do_Agendamento__c);
        
        if(Agendamento.TW1_Data_do_Agendamento__c == null)
            return null;
        
        AgendamentosDiaCorrente = agendamentoApplication.GetListaAgendamentosPorEmpreendimentoEDia(Caso.TW1_ID_Empreendimento__c, Agendamento.TW1_Data_do_Agendamento__c);
        return null;
    }
    
    public List<SelectOption> getOptHorarios()
    {
        system.debug('Retornando getOptHorarios');
        List<SelectOption> options = new  List<SelectOption>();
        
        Date dataLiberacaoVistoria =  Caso.TW1_Data_inicio_para_agendar_vistoria__c;
        
        /// Caso a data de previsão de agendamento seja maior que a data atual, então usa a data atual como dia 
        /// de corte
        if(dataLiberacaoVistoria < Date.today())
            dataLiberacaoVistoria = Date.today();
        
        DateTime dataBase = DateTime.newInstance(agendamento.TW1_Data_do_Agendamento__c.year(),  agendamento.TW1_Data_do_Agendamento__c.month() , agendamento.TW1_Data_do_Agendamento__c.day(),0,0,0);
        DateTime dataCorte = DateTime.newInstance(dataLiberacaoVistoria.year(),  dataLiberacaoVistoria.month() , dataLiberacaoVistoria.day(), DateTime.now().hour(), DateTime.now().minute(), DateTime.now().second());
        
        options.add(new  SelectOption('', 'Selecione um horário'));
        
        if(dataCorte < DateTime.parse(dataBase.format('dd/MM/yyyy') + ' 08:00'))
            options.add(new  SelectOption('08:00', '08:00'));
        if(dataCorte < DateTime.parse(dataBase.format('dd/MM/yyyy') + ' 08:30'))
            options.add(new  SelectOption('08:30', '08:30'));
        if(dataCorte < DateTime.parse(dataBase.format('dd/MM/yyyy') + ' 09:00'))
            options.add(new  SelectOption('09:00', '09:00'));
        if(dataCorte < DateTime.parse(dataBase.format('dd/MM/yyyy') + ' 09:30'))
            options.add(new  SelectOption('09:30', '09:30'));
        if(dataCorte < DateTime.parse(dataBase.format('dd/MM/yyyy') + ' 10:00'))
            options.add(new  SelectOption('10:00', '10:00'));
        if(dataCorte < DateTime.parse(dataBase.format('dd/MM/yyyy') + ' 10:30'))
            options.add(new  SelectOption('10:30', '10:30'));
        if(dataCorte < DateTime.parse(dataBase.format('dd/MM/yyyy') + ' 11:00'))
            options.add(new  SelectOption('11:00', '11:00'));
        if(dataCorte < DateTime.parse(dataBase.format('dd/MM/yyyy') + ' 11:30'))
            options.add(new  SelectOption('11:30', '11:30'));
        if(dataCorte < DateTime.parse(dataBase.format('dd/MM/yyyy') + ' 12:00'))
            options.add(new  SelectOption('12:00', '12:00'));
        if(dataCorte < DateTime.parse(dataBase.format('dd/MM/yyyy') + ' 12:30'))
            options.add(new  SelectOption('12:30', '12:30'));
        if(dataCorte < DateTime.parse(dataBase.format('dd/MM/yyyy') + ' 13:00'))
            options.add(new  SelectOption('13:00', '13:00'));
        if(dataCorte < DateTime.parse(dataBase.format('dd/MM/yyyy') + ' 13:30'))
            options.add(new  SelectOption('13:30', '13:30'));
        if(dataCorte < DateTime.parse(dataBase.format('dd/MM/yyyy') + ' 14:00'))
            options.add(new  SelectOption('14:00', '14:00'));
        if(dataCorte < DateTime.parse(dataBase.format('dd/MM/yyyy') + ' 14:30'))
            options.add(new  SelectOption('14:30', '14:30'));
        if(dataCorte < DateTime.parse(dataBase.format('dd/MM/yyyy') + ' 15:00'))
            options.add(new  SelectOption('15:00', '15:00'));
        if(dataCorte < DateTime.parse(dataBase.format('dd/MM/yyyy') + ' 15:30'))
            options.add(new  SelectOption('15:30', '15:30'));
        if(dataCorte < DateTime.parse(dataBase.format('dd/MM/yyyy') + ' 16:00'))
            options.add(new  SelectOption('16:00', '16:00'));
        if(dataCorte < DateTime.parse(dataBase.format('dd/MM/yyyy') + ' 16:30'))
            options.add(new  SelectOption('16:30', '16:30'));
        if(dataCorte < DateTime.parse(dataBase.format('dd/MM/yyyy') + ' 17:00'))
            options.add(new  SelectOption('17:00', '17:00'));
        if(dataCorte < DateTime.parse(dataBase.format('dd/MM/yyyy') + ' 17:30'))
            options.add(new  SelectOption('17:30', '17:30'));
        if(dataCorte < DateTime.parse(dataBase.format('dd/MM/yyyy') + ' 18:00'))
            options.add(new  SelectOption('18:00', '18:00'));
        
        system.debug('Lista de getOptHorarios gerada para retorno: ' + options);
        
        if(options.size() > 1)        
            return options;
        else
            return null;
    }
    
    public List<SelectOption> getOptStatus()
    {
        system.debug('Montando lista de getOptStatus');
        List<SelectOption> options = new  List<SelectOption>();
        options.add(new  SelectOption('Novo', 'Novo'));
        options.add(new  SelectOption('Agendado', 'Agendado'));
        options.add(new  SelectOption('Concluído com sucesso', 'Concluído com sucesso'));
        options.add(new  SelectOption('Cancelado pelo Cliente', 'Cancelado pelo Cliente'));
        options.add(new  SelectOption('Cancelado pela Engenharia', 'Cancelado pela Engenharia'));
        options.add(new  SelectOption('Cliente não compareceu', 'Cliente não compareceu'));
        
        system.debug('Lista de getOptStatus gerada para retorno: ' + options);
        return options;
    }
    
    public string getHorarios()
    {
        //If multiselect is false, countries must be of type String
        return Agendamento.TW1_Hora__c;
    }
    
    public void setHorarios(string horarios)
    {
        //If multiselect is false, countries must be of type String
        Agendamento.TW1_Hora__c = horarios;
    }
    
    public string getComentario()
    {
        //If multiselect is false, countries must be of type String
        return Agendamento.TW1_Comentarios__c;
    }
    
    public void setComentario(string comentario)
    {
        //If multiselect is false, countries must be of type String
        Agendamento.TW1_Comentarios__c = comentario;
    }
    
    public Date getDataAgendamento()
    {
        //If multiselect is false, countries must be of type String
        return Agendamento.TW1_Data_do_Agendamento__c;
    }
    
    public void setDataAgendamento(date data)
    {
        //If multiselect is false, countries must be of type String
        Agendamento.TW1_Data_do_Agendamento__c = data;
    }
    
    public PageReference SalvarAgendamento()
    {       
        system.debug('Salvando agendametno: ' + Agendamento);
        
        try
        {
            Agendamento = agendamentoApplication.SalvarAgendamento(Caso, Agendamento);            
            PageReference pr = new PageReference('/' + Caso.Id); // google is blocked here
            pr.setRedirect(true);
            return pr;            
        }
        catch(Cal_Cls_Infra_Exception ea)
        {
            system.debug('Error em salvar agendamento: '  + ea.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ea.getMessage()));
            return null;
        }
        catch(Exception e)
        {
            system.debug('Error em salvar agendamento: '  + e.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Existe um agendamento em aberto neste Caso. Só pode haver um agendamento aberto por Caso. Favor tratar o agendamento aberto antes de abrir um novo.'));
            return null;
        }           
    }
    
    public PageReference RedirectCancel() {
        PageReference pr = new PageReference('/' + Caso.Id); // google is blocked here
        pr.setRedirect(true);
        return pr;            
    }
}