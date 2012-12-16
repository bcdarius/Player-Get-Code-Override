<h1>About</h1>
This project provides a Flash plugin for overriding the embed code in the ‘Get Code’ player menu. The plugin will automatically replace the default HTML embed code with an iframe, so that the embedded player is a smart player that will work in both HTML5 and Flash environments
<h1>Deployment</h1>
1. Download the latest GetCodeOverride.swf from <a href="https://github.com/Brightcodes/BC-Player-GetCodeOverride/downloads">here</a>
2. Upload the SWF file to a server and make a note of the URL e.g. http://example.com/swf/GetCodeOverride.swf (make sure the swf is publicly accessible without any authentication or restriction);
3. Place a <a href="http://support.brightcove.com/en/docs/cross-domain-security-flash">crossdomain.xml file</a> on the server's web root directory where SWF file resides to allow the Brightcove player to communicate to the SWF.
4. Add “?viralPlayerID=[default viral player ID]&viralPlayerWidth=[default viral player width]&viralPlayerHeight=[default viral player height]” to URL by replacing [default viral player ID]  value with the <a href="http://support.brightcove.com/en/docs/setting-default-viral-player">default viral player</a> ID for your account,
   [default viral player width] with viral player's width and [default viral player height] with viral player's height
   e.g.  http://example.com/swf/GetCodeOverride.swf?viralPlayerID=15482486786464&viralPlayerWidth=480&viralPlayerHeight=270. Alternatively you can add this parameter  to the <a href="http://support.brightcove.com/en/docs/player-configuration-parameters">player publishing code</a> as below:

    <pre>&lt;param name=”viralPlayerID” value=”[default viral player ID]” /&gt;
         &lt;param name=”viralPlayerWidth” value=”[default viral player width]” /&gt;
	 &lt;param name=”viralPlayerHeight” value=”[default viral player height]” /&gt;</pre>
	
   These parameters can be added via page URL where player published is e.g. http://mydomain.com/section/category/page?viralPlayerID=12314849203482&viralPlayerWidth=480&viralPlayerHeight=270
   
5. Log in to your Brightcove account and navigate to the Publishing Module
6. Double-click on the player and go to “Plug-ins” tab and enter previously noted URL for GetCodeOverride.swf (Make sure that the URL matches the SWF's location and have viralPlayerID parameter with viral player ID value in the URL).
7. Finally save changes

 Alternatively the plugin can be added as <a href="http://support.brightcove.com/en/docs/adding-custom-component-player-template">a Module to the BEML template</a>.
