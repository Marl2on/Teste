/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData=true)
private class Cal_SA_UAU_Venda_Test {

    private static Cal_SA_UAU_Venda vendaServiceAgent = new Cal_SA_UAU_Venda();
    
    private static testMethod void TesteBuscaVenda()
    {
        Test.startTest();
        
    	Test.setMock(HttpCalloutMock.class, new Cal_Cls_MockResponseGenerator());
        
        try
        {
            Cal_SA_UAU_Venda.VendasRequest request = new Cal_SA_UAU_Venda.VendasRequest();
            
            request.datainicial = '2017-12-01T15:29:51.487Z';
            request.datafinal = '2017-12-01T15:29:51.487Z';
            
            request.listavendas = new List<Cal_SA_UAU_Venda.DadosVendaRequest>();
            Cal_SA_UAU_Venda.DadosVendaRequest vendaAtributo = new Cal_SA_UAU_Venda.DadosVendaRequest();
            vendaAtributo.empresa = 34;
            vendaAtributo.numvenda = 347;
            vendaAtributo.obra = 'R3460';
            request.listavendas.add(vendaAtributo);
            
        	System.debug('inciando classe de service agente de venda');
        	vendaServiceAgent.GetVendas(new Cal_SA_UAU_Venda.VendasRequest());
        }
        catch(Exception ex)
        {
        	System.debug('Erroe: ' + ex);
        	system.assert(false);
        }      
        
        Test.stopTest();
    }
}