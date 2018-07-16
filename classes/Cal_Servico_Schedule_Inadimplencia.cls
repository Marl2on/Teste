public class Cal_Servico_Schedule_Inadimplencia implements Schedulable {
    public void execute(SchedulableContext paSchedulableContext) { 
        system.debug('Chmando método de carga de inadimplencia');
        Cal_Servico_Application_Inadimplencia.EnviarSolicitacaoDeProcessoDeInadimplencia();
    }    
}