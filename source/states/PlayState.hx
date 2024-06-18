package states;

import entities.Player;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;

class PlayState extends FlxState {
	var player:Player;

	var map:FlxOgmo3Loader;
	var BG:FlxTilemap;
	var decor:FlxTilemap;
	var collide:FlxTilemap;
	var collide_small:FlxTilemap;

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

		collide = map.loadTilemap("assets/images/collision.png", "collide");

		collide_small = map.loadTilemap("assets/images/small_collision.png", "collide_small");

		player = new Player();
		map.loadEntities(placeEntites, "ent");
		add(player);

		FlxG.camera.follow(player, TOPDOWN, 1);

		persistentDraw = false;

		player.facing = UP;
	}

	public function placeEntites(entity:EntityData) {
		if (entity.name == "player") {
			trace('found player');
			player.setPosition(entity.x, entity.y);
			trace(entity.name, player.x, entity.y);
		}
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		FlxG.collide(player, collide);
		FlxG.collide(player, collide_small);

		if (FlxG.keys.justPressed.ESCAPE) {
			var pauseState = new PausedSubState();
			pauseState.persistentDraw = false;
			openSubState(pauseState);
		}
	}
}
