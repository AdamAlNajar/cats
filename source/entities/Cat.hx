package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxRandom;
import flixel.util.FlxColor;
import flixel.math.*;

class Cat extends FlxSprite {
	// for now its a square, when the artist wakes up she will work on it.
	static inline var SPEED:Float = 300;

	var actionInterval:Int = 0;
	public var shouldUpdate:Bool = true;
	public var isTutorialCat:Bool = false; // Flag to identify the tutorial cat


	public function new(x:Float = 0, y:Float = 0, isTutorialCat:Bool = false, catType:String = "default") {
		super(x, y);


		var graphicPath:String = switch (catType) {
			case "Black": "assets/images/cat_black.png";
			default: "assets/images/cat.png";
		}

		loadGraphic(graphicPath, true, 24, 20);

		setFacingFlip(LEFT, true, false);
		setFacingFlip(RIGHT, false, false);

		setSize(24, 20);
		offset.set(4, 8);

		animation.add("d_idle", [0]);
		animation.add("lr_idle", [2]);
		animation.add("u_idle", [1]);

		drag.x = drag.y = 800;
		this.isTutorialCat = isTutorialCat;
		this.solid = true;
	}

	override function update(elapsed:Float) {
		if(shouldUpdate){
			super.update(elapsed);
			updateMovement();
		}


	}

	function updateMovement() {
		actionInterval++;
		if (actionInterval >= 100) {
			var i:Int = Std.random(100);

			if (i <= 25) {
				velocity.y = -SPEED; // Move up
				velocity.x = 0;
				facing = UP;
				animation.play("u_idle");
			} else if (i <= 50) {
				velocity.y = SPEED; // Move down
				velocity.x = 0;
				facing = DOWN;
				animation.play("d_idle");
			} else if (i <= 75) {
				velocity.x = -SPEED; // Move left
				velocity.y = 0;
				facing = LEFT;
				animation.play("lr_idle");
			} else {
				velocity.x = SPEED; // Move right
				velocity.y = 0;
				facing = RIGHT;
				animation.play("lr_idle");
			}

			actionInterval = 0; // Reset action interval
		}
	}
}
