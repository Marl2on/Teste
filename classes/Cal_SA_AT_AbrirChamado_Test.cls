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
private class Cal_SA_AT_AbrirChamado_Test {

	static Cal_SA_AT_AbrirChamado ATServiceAgent = new Cal_SA_AT_AbrirChamado();
	
    static testMethod void TesteAberturaDeChamadoComRequestNull() {
        // TO DO: implement unit test
        try
        {
        	ATServiceAgent.AbrirChamado(null);
        	system.assert(false);
        }
        catch(Cal_Cls_Infra_Exception ex)
        {
        	if(ex.getMessage() == 'Não foi informado o request para abrir o chamado.')
        		system.assert(true);
        	else
        		system.assert(false);
        }
        catch(Exception ex)
        {
        	system.assert(false);
        }
    }
    
    static testMethod void TesteAberturaDeChamadoComSucesso() {
        
        Test.setMock(HttpCalloutMock.class, new Cal_Cls_MockResponseGenerator());
          
        try
        {
        	System.debug('Inicianod teste para abrir chamado');
        	
        	Cal_SA_AT_AbrirChamado.AbrirChamadoRequest requestObj = new Cal_SA_AT_AbrirChamado.AbrirChamadoRequest();
			
			requestObj.IdChamadoOrigem = 'SRSRSRS';
    		requestObj.URLCallBack= '';
	    	requestObj.Id = 0;
	    	requestObj.CodigoObra = '1994';
	    	requestObj.Bloco = '1';
	    	requestObj.Unidade = '101';
	    	requestObj.Cpfsolicitante = '12312312390';
	    	requestObj.nomeSolicitante = 'JOÃO DA SILVA';
	    	requestObj.emailSolicitante = 'joca@teste.com';
	    	requestObj.tefoneSolicitante = '219989999';
	    	requestObj.detalhamentoSolicitacao = 'MANUTENÇÃO EM UNIDADE';
	    	requestObj.cpfUsuarioCadastrado = '12312312380';
	    	requestObj.ResponsavelManutencao = 'Eu';
	    	requestObj.DataHabiteSe  = Datetime.now();
	    	requestObj.DataHabiteSeAverbada = Datetime.now();    	
			
			System.debug('Montando objeto request: ' + requestObj);
        	Cal_SA_AT_AbrirChamado.AbrirChamadoResponse response = ATServiceAgent.AbrirChamado(requestObj);
        	system.debug('Response do AT: ' + response);
        	if(response.UriRetorno == 'http://Assitencia/1')
        		system.assert(true);
        	else
        		system.assert(false);
        }
        catch(Exception ex)
        {
        	System.debug('Erro: ' + ex.getMessage());
        	system.assert(false);
        }
    }
}