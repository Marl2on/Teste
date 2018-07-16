@RestResource(urlMapping='/WsVendas/*')
global with sharing class Cal_Servico_Serv_Vendas {
    
    @HttpGet
    global static string GetAccountByCPF() {
        Cal_Servico_Application_Vendas.ExecutarCargaDeVendas();
        return 'Sucesso...';
    } 
}