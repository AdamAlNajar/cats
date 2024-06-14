package states;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PausedState extends FlxSubState {
	public function new() {
		super(0x52000000);
	}

	override public function create() {
		super.create();
		var pauseText = new FlxText(0, 0, 0, "PAUSED!", 32);
		pauseText.screenCenter(XY);
		add(pauseText);

		FlxG.sound.music.pause();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (FlxG.keys.justPressed.TAB) {
			FlxG.sound.music.play();
			closeSubState();
		}
	}
}
