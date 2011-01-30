// PLUGIN_INFO//{{{
var PLUGIN_INFO =
<VimperatorPlugin>
    <name>{NAME}</name>
    <description>Is.gd from Vimperator - Based on TinyURL by hogelog</description>
    <author mail="carl@carlsverre.com" homepage="http://www.carlsverre.com/">Carl Sverre</author>
    <version>0.1</version>
    <minVersion>2.0pre</minVersion>
    <maxVersion>2.0pre</maxVersion>
    <detail><![CDATA[

== COMMANDS ==
isgd [URL]:
    echo and copy URL
	
== LIBRARY ==
plugins.isgd.getIsGd(url):
    return IsGdURL

    ]]></detail>
</VimperatorPlugin>;
//}}}

(function() {
    const IsGdAPI = 'http://is.gd/api.php?longurl=';

    commands.add(['isgd'], 'echo and copy Is.Gd URL',
        function(args) dactyl.clipboardWrite(tiny.getIsGd(args.length==0 ? buffer.URL : args.string), true),
        {
            argCount: '?',
        });

    var tiny = plugins.isgd = {
        getIsGd: function(url)
            util.httpGet(IsGdAPI+encodeURIComponent(url)).responseText,
    };
})();
// vim: fdm=marker sw=4 ts=4 et:
