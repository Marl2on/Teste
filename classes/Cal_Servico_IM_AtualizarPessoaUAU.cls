public with sharing class Cal_Servico_IM_AtualizarPessoaUAU {
   
    @InvocableMethod(label='AtualizarDadosCadastraisPessoasUAU' description='Criar chamado no serviço de assitencia tecnica pela lista de chamados recebidos por parâmtro')
    public static void AtualizarDadosCadastraisPessoasUAU(List<Account> pessoas)
    {
        System.debug('Entrou no método de Atualização cadastral');
        for(Account pessoa : pessoas)
        	Cal_Servico_Application_Pessoa.AtualizarDadosCadastraisUAU(pessoa.Id);
    }
}