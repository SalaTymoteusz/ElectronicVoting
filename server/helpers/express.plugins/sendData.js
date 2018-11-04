module.exports= (req,res,next)=>{

    res.sendData = function(obj) {
        //if error set status
    
        if(obj.error ){
            res.status(obj.code);
        }
        if (req.accepts('json') || req.accepts('text/html')) {
            res.header('Content-Type', 'application/json');
            res.send(obj);

        // TODO: response with xml
        // } else if (req.accepts('application/xml')) {
        //     res.header('Content-Type', 'text/xml');
        //     var xml = easyxml.render(obj);
        //     res.send(xml);
        } else {
            res.send(406);
        }
    };

    next();
}