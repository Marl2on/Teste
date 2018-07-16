public class Cal_Servico_Schedule_QuitacaoInidade implements Schedulable {
	
    public void execute(SchedulableContext paSchedulableContext) { 
        system.debug('Chmando método de carga');
		Cal_Servico_Application_CargaUnidades.ExecutaCargaUnidadesQuitadas();
   	}    
    
}