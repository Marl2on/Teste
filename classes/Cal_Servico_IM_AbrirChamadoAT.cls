/// IM = Invocable Method
public with sharing class Cal_Servico_IM_AbrirChamadoAT {
    
    private static Cal_Servico_Application_Cases caseApplication = new Cal_Servico_Application_Cases();
    
    @InvocableMethod(label='CriarChamadoAssitenciaTecnicaPelaListaDeCasos' description='Criar chamado no serviço de assitencia tecnica pela lista de chamados recebidos por parâmtro')
    public static void CriarChamadoAssitenciaTecnicaPelaListaDeCasos(List<Case> casos)
    {
        //System.debug('Entrou no método de criação de caso de Assitência tecnica');
        for(case caso : casos)
        {
            caseApplication.CriarChamadoATTrigger(caso);
        }
    }
}