package states;

import entities.Player;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;

class PlayState extends FlxState {
	var player:Player;
	var player_centerX:Float;
	var player_centerY:Float;

	var map:FlxOgmo3Loader;
	var BG:FlxTilemap;
	var decor:FlxTilemap;
	var collide:FlxTilemap;

	override public function create() {
		FlxG.camera.fade(FlxColor.BLACK, 0.54, true); // Fades IN
		FlxG.autoPause = false;
		FlxG.camera.zoom = 1.5;

		super.create();

		map = new FlxOgmo3Loader("assets/data/str_c.ogmo", "assets/data/str_c.json");

		BG = map.loadTilemap("assets/images/tilesets/str_c.png", "BG");
		BG.follow();
		add(BG);
		trace(BG);

		decor = map.loadTilemap("assets/images/tilesets/str_c.png", "decor");
		decor.follow();
		add(decor);

		collide = map.loadTilemap("assets/images/tilesets/str_c.png", "collide");

		player = new Player();
		map.loadEntities(placeEntites, "ent");
		add(player);

		FlxG.camera.follow(player, TOPDOWN, 1);

		player_centerX = (FlxG.width - player.width) / 2;
		player_centerY = (FlxG.height - player.height) / 2;

		player.x = player_centerX;
		player.y = player_centerY;

		player.facing = DOWN;
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		FlxG.collide(player, collide);

		if (FlxG.keys.justPressed.ESCAPE) {
			var pauseState = new PausedSubState();
			pauseState.persistentDraw = false;
			openSubState(pauseState);
		}
	}

	public function placeEntites(entity:EntityData) {
		if (entity.name == "player") {
			player.x = entity.x;
			player.y = entity.y;
		}
	}
}
