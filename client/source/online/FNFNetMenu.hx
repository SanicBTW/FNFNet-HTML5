package online;

#if desktop
import Discord.DiscordClient;
import sys.io.File;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxInputText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import io.colyseus.Client;
import io.colyseus.Room;

class FNFNetMenu extends MusicBeatState
{
	var coly:Client;
	var error:String = "";
	var logo:FlxSprite;
	var hand:FlxSprite;
	var curSelected:Int = 0;
	var jfc:FlxInputText;
	var jbt:FlxButton;
	var assets:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = ['matchmaking', 'join from code', 'back', 'login'];

	public function new(error:String = "")
	{
		this.error = error;
		trace("chungus");
		super();
	}

	override function create()
	{
		#if sys
		DiscordClient.changePresence("In the FNFNet menu", null);
		#end
		FlxG.mouse.visible = true;
		logo = new FlxSprite().loadGraphic(Paths.image('fnfnet'));
		logo.screenCenter(XY);
		logo.antialiasing = true;
		logo.y = -160;
		logo.setGraphicSize(Std.int(logo.width / 1.6), Std.int(logo.height / 1.6));

		jfc = new FlxInputText(50, 100, 150, "", 16);
		jbt = new FlxButton(jfc.x + 150, jfc.y, "Join", function()
		{
			FlxG.switchState(new ConnectingState('battle', 'code', jfc.text));
		});
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;

		assets = new FlxTypedGroup<FlxSprite>();

		var tex = Paths.getSparrowAtlas('battleassets');

		hand = new FlxSprite(158, 438);
		hand.frames = Paths.getSparrowAtlas('battleassets');
		hand.animation.addByPrefix('hand', 'hand', 24, true);
		hand.animation.play('hand');

		for (i in 0...2)
		{
			var menuItem:FlxSprite = new FlxSprite(305 + (i * 360), 425);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i], 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			// menuItem.screenCenter(X);
			assets.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
		}
		for (i in 0...2)
		{
			var menuItem:FlxSprite = new FlxSprite(305 + (i * 360), 550);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i + 2], 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			// menuItem.screenCenter(X);
			assets.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
		}

		add(menuBG);
		add(assets);
		add(logo);
		add(hand);
		var errortxt = new Alphabet(0, FlxG.height * 0.90, error, true);
		errortxt.screenCenter(X);
		add(errortxt);
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.LEFT)
			changeSelection(-1);
		if (FlxG.keys.justPressed.RIGHT)
			changeSelection(1);
		if (FlxG.keys.justPressed.UP)
			changeSelection(-2);
		if (FlxG.keys.justPressed.DOWN)
			changeSelection(2);
		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(new MainMenuState());
		if (FlxG.keys.justPressed.F2)
			FlxG.switchState(new SingleplayerMods());

		if (controls.ACCEPT)
		{
			switch (curSelected)
			{
				case 0:
					FlxG.switchState(new ConnectingState('battle', 'host'));
				case 1:
					add(jfc);
					add(jbt);
				case 2:
					FlxG.switchState(new ConnectingState('battle', 'join'));
				case 3:
					FlxG.switchState(new ChatState());
			}

			assets.forEach(function(spr:FlxSprite)
			{
				if (spr.ID != curSelected)
				{
					FlxTween.tween(spr, {width: 0, height: 0}, 1.5, {ease: FlxEase.quintInOut});
				}
			});
		}
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;
		hand.flipX = false;
		if (curSelected < 0)
		{
			curSelected = 0;
		}
		if (curSelected > 3)
		{
			curSelected = 3;
		}
		hand.y = 438;
		switch (curSelected)
		{
			case 0:
				hand.x = 167;
			case 1:
				hand.flipX = true;
				hand.x = 1006;
			case 2:
				hand.x = 167;
				hand.y = 550;
			case 3:
				hand.flipX = true;
				hand.x = 1006;
				hand.y = 550;
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}
