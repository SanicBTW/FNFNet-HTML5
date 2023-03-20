package;

import flixel.FlxG;

class Config
{
	public static function initsave(reset:Bool = false)
	{
		if (!FlxG.save.data.played || reset)
		{
			FlxG.save.data.played = true;
			FlxG.save.data.framerate = 60;
			FlxG.save.data.pauseonunfocus = true;
			FlxG.save.data.fullscreen = false;
			FlxG.save.data.downscroll = false;
			FlxG.save.data.kadeinput = false;
			FlxG.save.data.pgbar = false;
			FlxG.save.data.instres = false;
			FlxG.save.data.instvolume = 100;
			FlxG.save.data.vocalsvolume = 100;
			FlxG.save.flush();
		}
		else
		{
			FlxG.autoPause = FlxG.save.data.pauseonunfocus;
			FlxG.drawFramerate = FlxG.save.data.framerate;
			FlxG.updateFramerate = FlxG.save.data.framerate;
		}
	}
}
