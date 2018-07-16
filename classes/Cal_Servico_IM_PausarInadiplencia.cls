public with sharing class Cal_Servico_IM_PausarInadiplencia {
	
    private static Cal_Servico_Application_Inadimplencia inadimplenciaAppalication = new Cal_Servico_Application_Inadimplencia();
    
    @InvocableMethod(label='PausarInadimplencia' description='Pausar a inadiplência de um caso')
    public static void PausarInadimplencia(List<Product2> unidades)
    {
    	for(Product2 unidade : unidades)
        	inadimplenciaAppalication.PausarInadimplencia(unidade);
    }
}