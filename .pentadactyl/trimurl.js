/*
Based on kmaglione's tinyurl script
*/
commands.addUserCommand ("trim",
    "Tr.im a url and copy it to the clipboard",
    function (args)
    {
        if (args[0] && args[0] != '' ) { url = args[0]; }
        else { url = buffer.URL; }
        util.httpGet ("http://tr.im/api/trim_simple?url=" +encodeURIComponent (url), function (req)
             {
             if (req.status == 200)
             {
             dactyl.clipboardWrite(req.responseText);
             liberator.echo ("Trim URL: " +req.responseText);}
             else
             liberator.echoerr("Error contacting tr.im!\n");
             }
        );
    });
