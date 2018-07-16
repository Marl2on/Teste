global class Cal_Servico_Schedule_CargaAtend implements Schedulable
{
    public void execute(SchedulableContext paSchedulableContext) 
    { 
        system.debug('Chmando método de carga de atendimentos');
        Cal_Servico_Application_Cases.ExecutarCargaDeAtendimentosDeIReBoletos();
   	}    
}