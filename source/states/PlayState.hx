package states;

import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
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

	// Player & Entities
	private var player:Player;
	private var tutorialCat:Cat;
	private var normalCats = new FlxTypedGroup<Cat>(20);

	// HUD & UI Elements
	private var hud:HUD;
	private var hudCam:FlxCamera;
	private var flash:FlxSprite;
	private var tutorialCompleted:Bool = false;

	// Map 1 Variables
	private var map1:FlxOgmo3Loader;
	private var BG1:FlxTilemap;
	private var decor1:FlxTilemap;
	private var collide1:FlxTilemap;
	private var collide_small1:FlxTilemap;

	// Photo snapping Variables
	private var canTakePhoto:Bool = true;
	private var photoCooldown:Float = 2.0;
	private var cooldownTimer:Float = 0;

	override public function create() {
		FlxG.camera.fade(FlxColor.BLACK, 0.54, true); // Fades IN
		FlxG.autoPause = false;
		FlxG.camera.zoom = 1.5;
		Discord.changePresence("No Details to show", "Currently In Game");
		
		// HUD Camera initialization
		hud = new HUD();
		hudCam = new FlxCamera();
		hudCam.bgColor.alpha = 0;
		FlxG.cameras.add(hudCam,false);
		hud.camera = hudCam;

		super.create();

		// Map 1 initialization
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

		// Player initialization
		player = new Player();
		map1.loadEntities(placeEntites, "ent");
		add(player);

		FlxG.camera.follow(player, TOPDOWN, 1);

		player.facing = UP;
		player.immovable = false;

		add(normalCats);
		add(hud);

		// Camera flash Initialization
		flash = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
        flash.alpha = 0;
        add(flash);
	}

	public function placeEntites(entity:EntityData) {
		if (entity.name == "player") {
			trace('found player');
			player.setPosition(entity.x, entity.y);
			trace(entity.name, player.x, entity.y);
		}
	
		if (entity.name == "cat") {
			var isTutorialCat:Bool = entity.values.isTutorialCat;
			var cat = new Cat(entity.x, entity.y, isTutorialCat);
			cat.immovable = false;
	
			if (isTutorialCat)
			{
				tutorialCat = cat; // Save a reference to the tutorial cat
			}
			else
			{
				cat.visible = false; // Hide non-tutorial cats initially
			}
	
			normalCats.add(cat); // Add the cat to the normalCats group
		}
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		//trace(player.immovable);

		FlxG.collide(player, collide_small1);
		FlxG.collide(player, collide1);

		FlxG.collide(normalCats, collide1);
		FlxG.collide(normalCats, collide_small1);

		player.immovable = false;
		// By Galo from haxe disc
		// Cat collision Handler
		// Cat collision Handler
		FlxG.collide(player, normalCats, (player, cat) -> 
		{
			var currentCat:Cat = cast(cat, Cat);
	
			// Only proceed if this is the tutorial cat and the tutorial hasn't been completed
			if (currentCat.isTutorialCat && !tutorialCompleted)
			{
				// Handle cat facing direction based on player's facing direction
				if (this.player.facing == RIGHT) {
					currentCat.facing = LEFT;
				}
				if (this.player.facing == LEFT) {
					currentCat.facing = RIGHT;
				}
				if (this.player.facing == UP) {
					currentCat.facing = DOWN;
				}
				if (this.player.facing == DOWN) {
					currentCat.facing = UP;
				}
	
				// Open the dialog substate
				var dialogSubState = new DialogSubState();
				openSubState(dialogSubState);
				dialogSubState.camera = hudCam;
				persistentDraw = true;
	
				// Initialize the dialog lines array
				dialogSubState.dialogLines = [
					"Miaow! Welcome to the world of cats!",
					"Snap photos of us when we're on the screen. Each cat in the photo earns you points!",
					"Use the arrow keys or WASD to move around. Easy, right?",
					"Press Space to click a picture",
					"Pro tip : Look for cats in various spots",
					"Miaow! Go out there and capture some purr-fect moments!",
					"FIN"
				];
	
				// Set the onFinish callback
				dialogSubState.onFinish = function() {
					if (tutorialCat != null) {
						normalCats.remove(tutorialCat);
						tutorialCat.destroy();
						tutorialCat = null;
					} 			
				};

				activateNormalCats();
			}
		});


		if (FlxG.keys.justPressed.ESCAPE) {
			var pauseState = new PausedSubState();
			Discord.changePresence("Details to Show : Paused", "Currently In Game But Paused");
			persistentDraw = false;
			openSubState(pauseState);
		}

		// Update the cooldown timer
		if (!canTakePhoto)
		{
			cooldownTimer -= elapsed;
			if (cooldownTimer <= 0)
			{
				canTakePhoto = true; // Allow taking photos again
				cooldownTimer = 0; // Reset the timer
			} 
		}

		// Update the HUD cooldown text
		hud.UpdateCooldown(cooldownTimer, photoCooldown);
		
		// Check for photo capture input
		if (FlxG.keys.justPressed.SPACE && canTakePhoto)
		{
			takePhoto();
		}
	}

	private function activateNormalCats():Void {
		if (normalCats.members != null) {
			var catsToActivate = normalCats.members.copy();
			for (cat in catsToActivate) {
				if (!cat.isTutorialCat) {
					cat.visible = true;
				}
			}
		}
		
	}

	private function takePhoto():Void
	{
		// Flash effect
		flash.alpha = 1;
		FlxTween.tween(flash, { alpha: 0 }, 0.2);

		// Calculate score
		var catsInPhoto:Int = 0;
		for (cat in normalCats)
		{
			// Check if the cat is within the camera's view
			if (isCatInView(cat))
			{
				catsInPhoto++;
			}
		}

		// Add points based on the number of cats in the photo
		if (catsInPhoto > 0)
		{
			hud.UpdatePoints(); // Update HUD with new points
		}
		else
		{
			trace("No cats in the photo. Try again!");
			// make it so that this is a hud element
		}

		// Start the cooldown
		canTakePhoto = false;
		cooldownTimer = photoCooldown;
	}

	private function isCatInView(cat:Cat):Bool
	{
		// Get the camera's viewport bounds
		var cameraX:Float = FlxG.camera.scroll.x;
		var cameraY:Float = FlxG.camera.scroll.y;
		var cameraWidth:Float = FlxG.camera.width;
		var cameraHeight:Float = FlxG.camera.height;
	
		// Get the cat's position and size
		var catX:Float = cat.x;
		var catY:Float = cat.y;
		var catWidth:Float = cat.width;
		var catHeight:Float = cat.height;
	
		// Check if the cat is within the camera's view
		return (catX + catWidth > cameraX && catX < cameraX + cameraWidth && // Horizontal check
				catY + catHeight > cameraY && catY < cameraY + cameraHeight); // Vertical check
	}
}