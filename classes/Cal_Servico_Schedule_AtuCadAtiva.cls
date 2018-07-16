/// Schedule que realiza a atualização cadastral ativa
global class Cal_Servico_Schedule_AtuCadAtiva implements Schedulable {
	public void execute(SchedulableContext paSchedulableContext) 
    { 
        system.debug('Executando carga de atualização cadastral ativa.');
        Cal_Servico_Application_Pessoa.JobValidaTempoAtualizacaoCadastral();
   	}    
}