package;

#if desktop
import Discord.DiscordClient;
import sys.io.File;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	public static var notPlaying:Bool;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = ['fnfnet', 'freeplay', 'options'];

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (!FlxG.sound.music.playing)
		{
			var now = Date.now();
			trace(now.getHours());
			if (now.getHours() >= 18)
			{
				FlxG.sound.playMusic(Paths.music('freakyNight'));
			}
			else
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);
		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		#if fnfnet
		var tex = Paths.getSparrowAtlas('main_menu_assets');
		#else
		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');
		#end
		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			if (optionShit[i] == "fnfnet")
			{
				menuItem.y -= 192;
				#if updatecheck
				if (TitleState.outdated)
					menuItem.alpha = 0.5;
				#end
			}
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
		}

		#if charselection
		var cst = Paths.getSparrowAtlas('chaselect');

		var menuItem:FlxSprite = new FlxSprite(-200, 180);
		menuItem.frames = cst;
		menuItem.animation.addByPrefix('idle', "chaselect white", 24);
		menuItem.animation.addByPrefix('selected', "chaselect basic", 24);
		menuItem.animation.play('idle');
		menuItem.ID = optionShit.length;
		menuItem.screenCenter(X);
		menuItem.x -= 335;
		menuItems.add(menuItem);
		menuItem.scrollFactor.set();
		menuItem.antialiasing = true;
		// menuItem.setGraphicSize(Std.int(menuItem.width / 0.5), Std.int(menuItem.height / 0.5));
		#end

		FlxG.camera.follow(camFollow, null, 0.06);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (online.ChatState.beentoChat)
		{
			online.ChatState.beentoChat = false;
			FlxG.mouse.visible = false;
			if (FlxG.save.data.pauseonunfocus != null)
				FlxG.autoPause = FlxG.save.data.pauseonunfocus;
			else
				FlxG.autoPause = true;
		}
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}
			#if charselection
			if (FlxG.keys.justPressed.LEFT)
			{
				changeItem(0, true);
			}
			if (FlxG.keys.justPressed.RIGHT)
			{
				changeItem(1);
			}
			#end
			if (FlxG.keys.justPressed.SIX)
				FlxG.openURL("https://www.youtube.com/watch?v=38FnpnflHEg");
			if (FlxG.keys.justPressed.THREE)
				FlxG.sound.play(Paths.sound('ok'));
			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
					#else
					FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
					#end
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];
								#if charselection
								if (spr.ID == optionShit.length)
								{
									LoadingState.loadAndSwitchState(new CharacterSelection());
								}
								#end
								switch (daChoice)
								{
									case 'story mode':
										notPlaying = false;
										FlxG.switchState(new StoryMenuState());
										trace("Story Menu Selected");
									case 'freeplay':
										FlxG.switchState(new FreeplayState());

										trace("Freeplay Menu Selected");
									#if fnfnet
									case 'fnfnet':
										#if updatecheck
										if (!TitleState.outdated)
											FlxG.switchState(new online.FNFNetMenu());
										else
											FlxG.resetState();
										#else
										FlxG.switchState(new online.FNFNetMenu());
										#end
									#end

									case 'options':
										FlxG.switchState(new OptionsMenu());
								}
							});
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			if (spr.ID != optionShit.length)
				spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0, left = false)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));
		curSelected += huh;

		if (left)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
				#if fnfnet
				if (optionShit[curSelected] == "fnfnet")
					spr.y -= 15;
				else
					menuItems.members[0].y = -132;
				#end
			}

			spr.updateHitbox();
		});
	}
}
