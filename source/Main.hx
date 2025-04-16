import flixel.FlxG;
import flixel.FlxGame;
import flixel.util.FlxSave;
import openfl.display.Sprite;
import states.MainMenuState;
import utils.DSCRPCManager;

class Main extends Sprite {
	public function new() {
		super();
		addChild(new FlxGame(0, 0, MainMenuState, 60, 60, true));
		Discord.load();

		var save = new FlxSave();
		save.bind("cats!");
		if (save.data.volume != null) {
			FlxG.sound.volume = save.data.volume;
		}
		save.close();
	}
}
