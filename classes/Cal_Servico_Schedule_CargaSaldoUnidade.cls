global class Cal_Servico_Schedule_CargaSaldoUnidade implements Schedulable{
 
    public void execute(SchedulableContext paSchedulableContext) { 
        system.debug('Chmando método de carga');
		Cal_Servico_Application_CargaUnidades.ExecutaCargaSaldosAbertosEmUnidades();
   	}    
}