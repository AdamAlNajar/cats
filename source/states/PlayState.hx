package states;

import entities.Cat;
import entities.Player;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import utils.DSCRPCManager;

class PlayState extends FlxState {
	var player:Player;
	var cats = new FlxTypedGroup<Cat>(20);

	var map:FlxOgmo3Loader;
	var BG:FlxTilemap;
	var decor:FlxTilemap;
	var collide:FlxTilemap;
	var collide_small:FlxTilemap;

	

	override public function create() {
		FlxG.camera.fade(FlxColor.BLACK, 0.54, true); // Fades IN
		FlxG.autoPause = false;
		FlxG.camera.zoom = 1.5;
		Discord.changePresence("No Details to show", "Currently In Game");

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
		player.immovable = false;

		add(cats);
	}

	public function placeEntites(entity:EntityData) {
		if (entity.name == "player") {
			trace('found player');
			player.setPosition(entity.x, entity.y);
			trace(entity.name, player.x, entity.y);
		}

		if (entity.name == "cat") {
			var cat = new Cat(entity.x, entity.y);
			cats.add(cat);
		}
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		FlxG.collide(player, collide_small);
		FlxG.collide(player, collide);

		FlxG.collide(cats, collide);
		FlxG.collide(cats, collide_small);

		// By Galo from haxe disc
		FlxG.collide(player, cats, (player, cat) -> 
		{
			player.immovable = true;

			if (FlxG.keys.justPressed.E)
			{
				openSubState(new DialogSubState());
			}
		});



		if (FlxG.keys.justPressed.ESCAPE) {
			var pauseState = new PausedSubState();
			Discord.changePresence("Details to Show : Paused", "Currently In Game But Paused");
			pauseState.persistentDraw = false;
			openSubState(pauseState);
		}
	}

	public function catplayercoll(player:Player, cats:Cat) {
		player.immovable = true;
		cats.immovable = true;
	}
}
