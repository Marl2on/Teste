public with sharing class Cal_Cls_Infra_Utils {
	/// Sleep thread
	public static void Sleep(Long milliSeconds)
	{
        Long timeDiff = 0;
        DateTime firstTime = System.now();
        do
        {
            timeDiff = System.now().getTime() - firstTime.getTime();
        }
        while(timeDiff <= milliSeconds);
	}
    
    public static boolean ExisteCampo(SObject objeto, string fieldToCheck)
    {
        system.debug('Objeto a ser serializado: ' + objeto);
        string textoObj = JSON.serialize(objeto);
        system.debug('Objeto a ser serializado com sucessso: ' + textoObj);
        system.debug('Verifica se contem o campo: ' + fieldToCheck);
        return textoObj.contains('"'+ fieldToCheck +'":');
    }
    
    public static Date ParseDate(String inDate) {
        Date	dateRes		= null;
        //	1 - Try locale specific mm/dd/yyyy or dd/mm/yyyy	
        try {
            String candDate		= inDate.substring(0,Math.min(10,inDate.length()));// grab date portion only m[m]/d[d]/yyyy , ignore time
            dateRes 	= Date.parse(candDate);
        }
        catch (Exception e) {}
    
        if (dateRes == null) {
        //	2 - Try yyyy-mm-dd			
            try {
                String candDate		= inDate.substring(0,10);			// grab date portion only, ignore time, if any
                dateRes				= Date.valueOf(candDate);
            }
            catch (Exception e) {} 
        }
        
        return dateRes;
    }
    
    /// Retorna URL do serviço do UAU
    public static string GetUrlApiUAU()
    {
        Cal_Servico_Repo_AggregateCustomSe customSettings = new Cal_Servico_Repo_AggregateCustomSe();
        string url = customSettings.GetUtlApiUAU();
        
        if(url != null)
            return url;
        
        throw new Cal_Cls_Infra_Exception('A URL do serviço do UAU não está configurada no CRM..');
    }
}