package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class PauseState extends FlxState {
	public var PauseText:FlxText;
	public var playState:PlayState;

	public function new(playState:PlayState) {
		this.playState = playState;
		super();
	}

	override function create() {
		super.create();

		PauseText = new FlxText(0, 0, FlxG.width, "PAUSED!", 32);
		PauseText.alignment = CENTER;
		PauseText.x = (FlxG.width - PauseText.width) / 2;
		PauseText.y = (FlxG.height - PauseText.height) / 2;
		add(PauseText);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE) {
			FlxG.switchState(playState);
		}
	}
}
