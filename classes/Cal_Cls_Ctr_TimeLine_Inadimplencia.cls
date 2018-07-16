public class Cal_Cls_Ctr_TimeLine_Inadimplencia {

	public List<String> fasesClasses = new List<String>();
    public List<String> fasesLabels = new List<String>();
    public List<String> fasesIcons = new List<String>();
    public List<String> fasesTimes = new List<String>();
    
    public List<String> getFasesClasses(){
        return this.fasesClasses;
    }
    
    public List<String> getFasesLabels(){
        return this.fasesLabels;
    }
    
    public List<String> getFasesIcons(){
        return this.fasesIcons;
    }
    
    public List<String> getFasesTimes(){
        return this.fasesTimes;
    }
    
    public Cal_Cls_Ctr_TimeLine_Inadimplencia(){}
    
    public Cal_Cls_Ctr_TimeLine_Inadimplencia(ApexPages.StandardController controller){
        System.debug('--- INÍCIO DO CONSTRUTOR DA CLASSE Cal_Cls_Ctr_TimeLine_Inadimplencia ---');
    	TW1_Inadimplencia__c currentInadimplencia = (TW1_Inadimplencia__c) controller.getRecord();
        
        List<String> passedFases = Cal_Repo_LinhaTempoInadimplencia.getPassedFases(currentInadimplencia);
        
        String fase = (String) currentInadimplencia.TW1_Fase__c;
        
        List<String> allFases = Cal_Repo_LinhaTempoInadimplencia.getAllFasesValues();
        for(String itemFase : allFases){
            if(fase == itemFase && itemFase != Cal_Repo_LinhaTempoInadimplencia.getLastFaseValue()){
                this.fasesClasses.add('info');
            }else{
                Boolean itemIsPassedFase = false;
                for(String itemPassedFase : passedFases){
                    if(itemPassedFase == itemFase){
                        this.fasesClasses.add('success');
                        itemIsPassedFase = true;
                        break;
                    }
                }
                if(itemIsPassedFase == false){
                    this.fasesClasses.add('default');
                }
            }
            
            this.fasesTimes.add(Cal_Repo_LinhaTempoInadimplencia.getInadimplenciaFaseTime(currentInadimplencia, itemFase));
        }
        
        this.fasesLabels = Cal_Repo_LinhaTempoInadimplencia.getAllFasesLabels();
        this.fasesIcons = Cal_Repo_LinhaTempoInadimplencia.getAllFasesIcons();
    }
}