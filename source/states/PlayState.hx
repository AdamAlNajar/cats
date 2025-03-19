package states;


import flixel.sound.FlxSound;
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

	//Game Variables
	private var gameTime:Float = 60; // 60 seconds timer
	private var gameOver:Bool = false;

	//Sound Effects
	var camShutterSound:FlxSound;
	var gameOverSound:FlxSound;

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

		FlxG.mouse.visible = false; // hide cursor

		// SFX Init
		camShutterSound = FlxG.sound.load("assets/sounds/shutter.wav", 0.4);
		gameOverSound = FlxG.sound.load("assets/sounds/end.wav", 0.4);

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
					"Miaow! Welcome to the world of cat photography!",
					"Your goal is simple: take as many cat pictures as you can before time runs out.",
					"Walk up to a cat and press the Space key to take a photo. Each cat is worth 1 point!",
					"Use the arrow keys or WASD to move around and find more cats.",
					"Pro tip: Cats might be hiding in different spots—explore carefully!",
					"The clock starts ticking once you finish this tutorial. Make every second count!",
					"Miaow! Now go out there and capture some purr-fect moments!",
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

		// Start Ticking if tutorial cat has been talked to
		if (!gameOver && tutorialCat == null) {
			gameTime -= elapsed;
			hud.updateTimer(gameTime); // Update HUD timer display
			hud.pointsCounter.text = "Start!";
	
			if (gameTime <= 0) {
				endGame();
			}
		}

		if(tutorialCat == null && hud.getPoints() != 0){
			var new_points = hud.getPoints();
			hud.pointsCounter.text = 'Points: $new_points';
		}

		// Tell the player what to do. 
		// Also dont allow the clock to tick if he did not talk to tutorial cat yet
		if(tutorialCat != null){
			hud.pointsCounter.text = "Walk up to the cat";
		}


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
	function endGame() {
		gameOver = true;
		gameOverSound.play();
		FlxG.camera.fade(FlxColor.BLACK, 1, false, function() {
			var endScreen = new GameOverState(hud.getPoints());
			FlxG.switchState(endScreen);
		});
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

	private function takePhoto():Void {
		// Flash effect
		flash.alpha = 1;
		FlxTween.tween(flash, {alpha: 0}, 0.2);
		camShutterSound.play();

		var catsInPhoto:Int = 0;

		// Check for collision with a cat before awarding points
		for (cat in normalCats) {
			if (FlxG.overlap(player, cat)) {
				catsInPhoto++;
			}
		}

		// Award points only if at least one cat is in the photo and the player is colliding
		if (catsInPhoto > 0) {
			hud.UpdatePoints(); // Update HUD with new points
		} else {
			var warning:DialogSubState = new DialogSubState();
			openSubState(warning);
			warning.camera = hudCam;
			persistentDraw = true;

			warning.dialogLines = [
				"Please get close with a cat and then take a picture"
			];
		}

		// Start the cooldown
		canTakePhoto = false;
		cooldownTimer = photoCooldown;
	}
		
}