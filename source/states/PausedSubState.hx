package states;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;
import utils.DSCRPCManager.Discord;

class PausedSubState extends FlxSubState {
	public var PauseText:FlxText;

	override function create() {
		super.create();

		PauseText = new FlxText(0, 0, 0, "PAUSED!", 24);
		PauseText.alignment = "center";
		add(PauseText);

		updateTextPos();
	}

	function updateTextPos() {
		var camera = FlxG.camera; // Get the current camera

		PauseText.x = camera.scroll.x + (camera.width - PauseText.width) / 2;
		PauseText.y = camera.scroll.y + (camera.height - PauseText.height) / 2;
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE) {
			close();
			Discord.changePresence("No Details to show", "Currently in game");
		}
	}
}
