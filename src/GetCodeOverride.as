 /* AUTHORS:
 *	 Darius Oleskevicius <doleskevicius@brightcove.com>
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the “Software”),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, alter, merge, publish, distribute,
 * sublicense, and/or sell copies of the Software, and to permit persons to
 * whom the Software is furnished to do so, subject to the following conditions:
 *   
 * 1. The permission granted herein does not extend to commercial use of
 * the Software by entities primarily engaged in providing online video and
 * related services.
 *  
 * 2. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT ANY WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, SUITABILITY, TITLE,
 * NONINFRINGEMENT, OR THAT THE SOFTWARE WILL BE ERROR FREE. IN NO EVENT
 * SHALL THE AUTHORS, CONTRIBUTORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY WHATSOEVER, WHETHER IN AN ACTION OF
 * CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE, INABILITY TO USE, OR OTHER DEALINGS IN THE SOFTWARE.
 *  
 * 3. NONE OF THE AUTHORS, CONTRIBUTORS, NOR BRIGHTCOVE SHALL BE RESPONSIBLE
 * IN ANY MANNER FOR USE OF THE SOFTWARE.  THE SOFTWARE IS PROVIDED FOR YOUR
 * CONVENIENCE AND ANY USE IS SOLELY AT YOUR OWN RISK.  NO MAINTENANCE AND/OR
 * SUPPORT OF ANY KIND IS PROVIDED FOR THE SOFTWARE.
 */

package {
	import com.brightcove.api.APIModules;
	import com.brightcove.api.CustomModule;
	import com.brightcove.api.events.MediaEvent;
	import com.brightcove.api.modules.ExperienceModule;
	import com.brightcove.api.modules.SocialModule;
	import com.brightcove.api.modules.VideoPlayerModule;
	
	import flash.display.LoaderInfo;
	import flash.net.SharedObject;

	public class GetCodeOverride extends CustomModule
	{
		/**
			Parameters viralPlayerID, viralPlayerWidth & viralPlayerHeight can be 
			hardcoded here, passed via plugin URL, embeded in player publishing code, 
			or passed via URL of the page.
			
			1) Plugin Parameters: http://mydomain.com/GetCodeOverride.swf?viralPlayerID=12314849203482&viralPlayerWidth=480&viralPlayerHeight=270
			2) Embed Code Parameters: 
				<param name="viralPlayerID" value="12314849203482" />
				<param name="viralPlayerWidth" value="480" />
				<param name="viralPlayerHeight" value="270" />
			3) Page URL: http://mydomain.com/section/category/page?viralPlayerID=12314849203482&viralPlayerWidth=480&viralPlayerHeight=270
		*/
		private static var VIRAL_PLAYER_ID:String;
		private static var VIRAL_PLAYER_WIDTH:String = "480";
		private static var VIRAL_PLAYER_HEIGHT:String = "270";
		
		// References to Modules
		private var _experienceModule:ExperienceModule;
		private var _videoPlayerModule:VideoPlayerModule;
		private var _socialModule:SocialModule;
		
		
		public function GetCodeOverride()
		{
			trace("@project GetCodeOverride");
			trace("@author Darius Oleskevicius doleskevicius@brightcove.com");
			trace("@lastModified 27.11.12 17:49 GMT");
			trace("@version 1.0.1");
		}
		
		override protected function initialize():void
		{
			_experienceModule = player.getModule(APIModules.EXPERIENCE) as ExperienceModule;
			_videoPlayerModule = player.getModule(APIModules.VIDEO_PLAYER) as VideoPlayerModule;
			_socialModule = player.getModule(APIModules.SOCIAL) as SocialModule;
			
			_videoPlayerModule.addEventListener(MediaEvent.BEGIN, onMediaBegin);
			_videoPlayerModule.addEventListener(MediaEvent.CHANGE, onMediaChange);
			
			if(_videoPlayerModule.getCurrentVideo())
			{
				overrideEmbedCode();
			}
		}
		
		private function onMediaBegin(pEvent:MediaEvent):void
		{
			    overrideEmbedCode();
		}
		
		private function onMediaChange(pEvent:MediaEvent):void
		{
			    overrideEmbedCode();
		} 
		
		private function overrideEmbedCode():void
		{
			GetCodeOverride.VIRAL_PLAYER_ID = getParamValue('viralPlayerID');
			
			if (!GetCodeOverride.VIRAL_PLAYER_ID) 
			{
				throw new Error("The default viral player ID hasn't been specified! This is required parameter for the plugin to function properly.");
				return;
			}
			
			if (getParamValue('viralPlayerWidth'))
			{
				GetCodeOverride.VIRAL_PLAYER_WIDTH = getParamValue('viralPlayerWidth');
			}
			
			if (getParamValue('viralPlayerHeight'))
			{
				GetCodeOverride.VIRAL_PLAYER_HEIGHT = getParamValue('viralPlayerHeight');
			}
			
			var videoDTO:Object = _videoPlayerModule.getCurrentVideo();
			/*
			  Construct embed code using iframe so that the player can be loaded 
		      from URL and it can act as smart player. We're not going to use getLink() 
			  method in Social Module which returns shortened link (bcove.me is not whitelisted 
			  domain in Windows 8 UI).
			*/
			var embedCode:String = '<iframe frameborder="0" width="' + VIRAL_PLAYER_WIDTH + '" height="' + VIRAL_PLAYER_HEIGHT + '" scrolling="no" '
			                        + 'src="http://link.brightcove.com/services/player/bcpid'
			                        + GetCodeOverride.VIRAL_PLAYER_ID + '/?bctid=' + videoDTO['id'] + '" ></iframe>';
			// override default embed code in 'Get Code' menu
			_socialModule.setEmbedCode(embedCode);
		}
		
		
		/**
		 * Look for the @param key in the URL of the page, the publishing code of the player, and 
		 * the URL for the SWF itself (in that order) and returns its value 
		 * [ Borrowed from  Brandon Aaskov's Google Analytics SWF project https://github.com/BrightcoveOS/Google-Analytics-SWF ]
		 */
		public function getParamValue(key:String):String
		{
			//1: check url params for the value
			var url:String = _experienceModule.getExperienceURL();
			if(url.indexOf("?") !== -1)
			{
				var urlParams:Array = url.split("?")[1].split("&");
				for(var i:uint = 0; i < urlParams.length; i++)
				{
					var keyValuePair:Array = urlParams[i].split("=");
					if(keyValuePair[0] == key) 
					{
						return keyValuePair[1];
					}
				}
			}
			
			//2: check player params for the value
			var playerParam:String = _experienceModule.getPlayerParameter(key);
			if(playerParam) 
			{
				return playerParam;
			}
			
			//3: check plugin params for the value
			var pluginParams:Object = LoaderInfo(this.root.loaderInfo).parameters;
			for(var param:String in pluginParams)
			{
				if(param == key) 
				{
					return pluginParams[param];
				}
			}
					
			return null;
		}
	}
}
