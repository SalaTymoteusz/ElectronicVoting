var xmlify = require('xmlify');
let isError = function(e){
    return e && e.stack && e.message && typeof e.stack === 'string' 
           && typeof e.message === 'string';
}

module.exports= (req,res,next)=>{
    let sendData =(obj)=>{
        if (req.accepts('json') || req.accepts('text/html')) {
            res.header('Content-Type', 'application/json');
           res.send(obj);

        // TODO: response with xml
        // } else if (req.accepts('application/xml')) {
        //     res.header('Content-Type', 'text/xml');
        //     var xml = easyxml.render(obj);
        //     res.send(xml);
        } else if (req.accepts('xml')){
            res.send(xmlify(obj));
        }else {
           res.send(406);
        }
    }
    res.sendSuccess = function(data,code=200) {
        res.status(code);
        sendData(data);
    };
    res.sendError = function({message,code=500}) {
        res.status(code);
        sendData({
            code:code,
            error:message
        });
    };

    next();
}