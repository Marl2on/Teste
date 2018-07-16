public with sharing class Cal_Servico_IM_ReiniciarInadiplencia {
	private static Cal_Servico_Application_Inadimplencia inadimplenciaAppalication = new Cal_Servico_Application_Inadimplencia();
   
    @InvocableMethod(label='ReiniciarInadimplencia' description='Reinicar uma inadimplência de um caso')
    public static void ReiniciarInadiplencia(List<Product2> unidades)
    {
    	for(Product2 unidade : unidades)
        	inadimplenciaAppalication.ReiniciarInadimplencia(unidade);
    }
}