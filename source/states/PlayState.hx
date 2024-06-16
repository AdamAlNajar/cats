package states;

import entities.Player;
import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxColor;

class PlayState extends FlxState {
	public var player:Player;

	var player_centerX:Float;
	var player_centerY:Float;

	override public function create() {
		FlxG.camera.fade(FlxColor.BLACK, 0.54, true); // Fades IN
		FlxG.autoPause = false;

		super.create();

		// Create the player sprite
		player = new Player(0, 0);
		add(player);

		player_centerX = (FlxG.width - player.width) / 2;
		player_centerY = (FlxG.height - player.height) / 2;

		player.x = player_centerX;
		player.y = player_centerY;

		player.facing = DOWN;
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE) {
			var pauseState:PauseState = new PauseState(this);
			FlxG.switchState(pauseState);
		}
	}
}
