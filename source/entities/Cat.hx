package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxRandom;
import flixel.util.FlxColor;

class Cat extends FlxSprite {
	// for now its a square, when the artist wakes up she will work on it.
	static inline var SPEED:Float = 300;

	var actionInterval:Int = 0;

	public function new(x:Float = 0, y:Float = 0) {
		super(x, y);
		makeGraphic(16, 16, FlxColor.BLACK);

		/* 
			setFacingFlip(LEFT, true, false);
			setFacingFlip(RIGHT, false, false); */

		drag.x = drag.y = 800;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		updateMovement();
	}

	function updateMovement() {
		actionInterval++;
		if (actionInterval >= 100) {
			var i:Int = Std.random(100);

			if (i <= 25) {
				velocity.y = -SPEED; // Move up
				velocity.x = 0;
			} else if (i <= 50) {
				velocity.y = SPEED; // Move down
				velocity.x = 0;
			} else if (i <= 75) {
				velocity.x = -SPEED; // Move left
				velocity.y = 0;
			} else {
				velocity.x = SPEED; // Move right
				velocity.y = 0;
			}

			actionInterval = 0; // Reset action interval
		}
	}
}
