package states;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;

class PausedSubState extends FlxSubState {
	public var PauseText:FlxText;

	override function create() {
		super.create();

		PauseText = new FlxText(0, 0, FlxG.width, "PAUSED!", 24);
		PauseText.alignment = CENTER;
		PauseText.x = (FlxG.width - PauseText.width) / 2;
		PauseText.y = (FlxG.height - PauseText.height) / 2;
		add(PauseText);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE) {
			close();
			trace('closed substate : pause');
		}
	}
}
