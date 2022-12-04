public class ShowPDFController {
    
    public String PDF {get;set;}
    public String fileName {get;set;}
    
    
    public void makeRequest(){
        fileName = System.currentPagereference().getParameters().get('fileName');
        PDF = FileRequestPDF.getPDF(fileName);
    }

}