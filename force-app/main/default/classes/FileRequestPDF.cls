public class FileRequestPDF {
    
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

}