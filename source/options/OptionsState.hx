package options;

import flixel.FlxObject;
import states.MainMenuState;
import backend.StageData;
import flixel.addons.transition.FlxTransitionableState;
import mobile.substates.MobileControlSelectSubState;
#if (target.threaded)
import sys.thread.Thread;
import sys.thread.Mutex;
#end

class OptionsState extends MusicBeatState
{
	var options:Array<String> = ['Note Colors', 'Controls', 'Adjust Delay and Combo', 'Graphics', 'Visuals and UI', 'Gameplay', 'Mobile Options', 'Mobile Controls', 'Krikoso Engine'];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;
	public static var onPlayState:Bool = false;
	#if (target.threaded) var mutex:Mutex = new Mutex(); #end

	function openSelectedSubstate(label:String) {
		persistentUpdate = false;
		FlxG.camera.follow(camFollow, null, 99999999);
		camFollow.setPosition(0, 0);
		FlxG.camera.follow(camFollow, null, 9);
		if (label != "Adjust Delay and Combo") removeTouchPad();
		switch(label) {
			case 'Note Colors':
				openSubState(new options.NotesSubState());
			case 'Controls':
				openSubState(new options.ControlsSubState());
			case 'Graphics':
				openSubState(new options.GraphicsSettingsSubState());
			case 'Visuals and UI':
				openSubState(new options.VisualsUISubState());
			case 'Gameplay':
				openSubState(new options.GameplaySettingsSubState());
			case 'Adjust Delay and Combo':
				MusicBeatState.switchState(new options.NoteOffsetState());
			case 'Mobile Options':
				openSubState(new mobile.options.MobileOptionsSubState());
			case 'Mobile Controls':
				openSubState(new MobileControlSelectSubState());
			case 'Krikoso Engine':
				openSubState(new options.KrikosoOptionsSubState());
		}
	}

	var selectorLeft:Alphabet;

	var camFollow:FlxObject;

	override function create() {
		#if DISCORD_ALLOWED
		DiscordClient.changePresence("Options Menu", null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.color = 0xFFea71fd;
		bg.scrollFactor.set(0,0);
		bg.updateHitbox();

		bg.screenCenter();
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(65, 10, options[i], true);
			optionText.screenCenter(Y);
			optionText.y += (75 * i);
			optionText.scrollFactor.set(0,1);
			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(5, 10, '>', true);
		selectorLeft.scrollFactor.set(0,1);
		add(selectorLeft);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		changeSelection();
		ClientPrefs.saveSettings();

		addTouchPad("UP_DOWN", "A_B_C");

		super.create();
		FlxG.camera.follow(camFollow, null, 9);
		
	}

	override function closeSubState() {
		super.closeSubState();
		#if DISCORD_ALLOWED
		DiscordClient.changePresence("Options Menu", null);
		#end
		ClientPrefs.saveSettings();
		ClientPrefs.loadPrefs();
		controls.isInSubstate = false;
        removeTouchPad();
		addTouchPad("UP_DOWN", "A_B_C");
		persistentUpdate = true;
	}

    var exiting:Bool = false;
	override function update(elapsed:Float) {
		super.update(elapsed);

		if (!exiting) {
		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
                        exiting = true;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			if(onPlayState)
			{
				StageData.loadDirectory(PlayState.SONG);
				LoadingState.loadAndSwitchState(new PlayState());
				FlxG.sound.music.volume = 0;
			}
			else MusicBeatState.switchState(new MainMenuState());
		}
		else if (controls.ACCEPT) openSelectedSubstate(options[curSelected]);
	}
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				camFollow.setPosition(item.x, item.y);
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	override function destroy()
	{
		ClientPrefs.loadPrefs();
		super.destroy();
	}
}
