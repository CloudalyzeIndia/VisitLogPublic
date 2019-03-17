@isTest
global class CLZ_CalloutMockGenerator implements HttpCalloutMock {
    protected Integer code;
    protected string body;
    public CLZ_CalloutMockGenerator (Integer code,string body){
        this.code = code;
        this.body = body;
    }
    
    global HTTPResponse respond(HTTPRequest req) {
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        res.setBody(body);
        res.setStatusCode(code);
        return res;
    }
}