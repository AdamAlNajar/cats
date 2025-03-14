package states;

import flixel.FlxCamera;
import entities.Cat;
import entities.Player;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import states.DialogSubState;
import utils.DSCRPCManager;
import utils.HUD;

class PlayState extends FlxState {
	var player:Player;
	var cat:Cat;
	var cats = new FlxTypedGroup<Cat>(20);
	var hud:HUD;
	var hudCam:FlxCamera;

	var map1:FlxOgmo3Loader;
	var BG1:FlxTilemap;
	var decor1:FlxTilemap;
	var collide1:FlxTilemap;
	var collide_small1:FlxTilemap;

	override public function create() {
		FlxG.camera.fade(FlxColor.BLACK, 0.54, true); // Fades IN
		FlxG.autoPause = false;
		FlxG.camera.zoom = 1.5;
		Discord.changePresence("No Details to show", "Currently In Game");
		
		// new camera for hud cuz if i kept it on same camera it will only work if zoom is 1 exactly
		hud = new HUD();
		hudCam = new FlxCamera();
		hudCam.bgColor.alpha = 0;
		FlxG.cameras.add(hudCam,false);
		hud.camera = hudCam;

		super.create();

		map1 = new FlxOgmo3Loader("assets/data/str_c.ogmo", "assets/data/str_c.json");

		BG1 = map1.loadTilemap("assets/images/tilesets/str_c.png", "BG");
		BG1.follow();
		add(BG1);
		trace(BG1);

		decor1 = map1.loadTilemap("assets/images/tilesets/str_c.png", "decor");
		decor1.follow();
		add(decor1);

		collide1 = map1.loadTilemap("assets/images/collision.png", "collide");

		collide_small1 = map1.loadTilemap("assets/images/small_collision.png", "collide_small");

		player = new Player();
		map1.loadEntities(placeEntites, "ent");
		add(player);

		FlxG.camera.follow(player, TOPDOWN, 1);


		player.facing = UP;
		player.immovable = false;

		add(cats);
		add(hud);
		trace("added hud sucessfully" + hud);
	}

	public function placeEntites(entity:EntityData) {
		if (entity.name == "player") {
			trace('found player');
			player.setPosition(entity.x, entity.y);
			trace(entity.name, player.x, entity.y);
		}

		if (entity.name == "cat") {
			cat = new Cat(entity.x, entity.y);
			cat.immovable = false;
			cats.add(cat);
		}
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		//trace(player.immovable);

		FlxG.collide(player, collide_small1);
		FlxG.collide(player, collide1);

		FlxG.collide(cats, collide1);
		FlxG.collide(cats, collide_small1);

		player.immovable = false;
		// By Galo from haxe disc
		FlxG.collide(player, cats, (player, cat) -> 
		{
			var dialogSubState = new DialogSubState();
			openSubState(dialogSubState);
			trace("dialog substate with cat opened");
			persistentDraw = true;
			dialogSubState.dialogLines = new Array<String>();
			dialogSubState.dialogLines.push("hello");
			dialogSubState.dialogLines.push("miauuuu");
			hud.UpdatePoints();
		});

		trace("HUD Position - PointsCounter: " + hud.pointsCounter.x + ", " + hud.pointsCounter.y);



		if (FlxG.keys.justPressed.ESCAPE) {
			var pauseState = new PausedSubState();
			Discord.changePresence("Details to Show : Paused", "Currently In Game But Paused");
			persistentDraw = false;
			openSubState(pauseState);
		}
	}
}
