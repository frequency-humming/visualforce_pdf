public class FileRequestPDF {
    
    private static List<String> reportNames = new List<String>();
    
    public static String sendPDF(Blob file,String fileName){
        
        String name = fileName.replaceAll('[^a-zA-Z0-9\\s+]','');
        String pdfName = name.replaceAll('\\s+','');
        String path = '/docs/'+pdfName+'.pdf';      
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('PUT');
        request.setEndpoint('callout:Aws'+path);
        request.setHeader('Content-Type','application/pdf');
        request.setBodyAsBlob(file);
        HttpResponse response = http.send(request);
        if(response.getStatusCode() != 200){
            System.debug('Status code : '+response.getStatusCode()+' '+response.getStatus());
            return response.getBody();
        } else {
          	return String.valueOf(response.getStatusCode());
        }
    }
    
    public static List<String> getListPDF(String userName){
        String path = '?list-type=2';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('callout:Aws'+path);
        HttpResponse response = http.send(request);
        if(response.getStatusCode() != 200){
            System.debug('Status code : '+response.getStatusCode()+' '+response.getStatus());
            reportNames.add(response.getStatus());
            return reportNames;
        } else {
            Dom.Document doc = response.getBodyDocument();
            DOM.XmlNode rootNode=doc.getRootElement();
            parseXML(rootNode,userName);
          	return reportNames;
        }
    }
    private static void parseXML(DOM.XMLNode rootNode,String name){
        if (rootNode.getNodeType() == DOM.XMLNodeType.ELEMENT){
        	if(rootNode.getName() == 'Key'){
            	if(rootNode.getText().contains(name)){
                    reportNames.add(rootNode.getText().substringAfter('/'));
                	system.debug('content for key : '+rootNode.getText().substringAfter('/'));      
                }
            }
        }
        for (Dom.XMLNode child: rootNode.getChildElements()) {
        	parseXML(child,name);
        }        
    }

}