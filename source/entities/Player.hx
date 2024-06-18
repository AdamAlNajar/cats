package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Player extends FlxSprite {
	static inline var speed:Float = 100;

	public function new(x:Float = 0, y:Float = 0) {
		super(x, y);
		loadGraphic("assets/images/player.png", true, 16, 24);

		setFacingFlip(LEFT, true, false);
		setFacingFlip(RIGHT, false, false);

		setSize(16, 16);
		offset.set(4, 8);

		animation.add("d_idle", [4]);
		animation.add("lr_idle", [8]);
		animation.add("u_idle", [0]);
		animation.add("d_walk", [4, 5, 6, 7], 6);
		animation.add("lr_walk", [8, 9, 10, 11], 6);
		animation.add("u_walk", [0, 1, 2, 3], 6);

		drag.x = drag.y = 800;
	}

	function updateMovement() {
		var up:Bool = false;
		var down:Bool = false;
		var left:Bool = false;
		var right:Bool = false;

		up = FlxG.keys.anyPressed([UP, W]);
		left = FlxG.keys.anyPressed([LEFT, A]);
		down = FlxG.keys.anyPressed([DOWN, S]);
		right = FlxG.keys.anyPressed([RIGHT, D]);

		if (up && down)
			up = down = false;
		if (left && right)
			left = right = false;

		if (up || down || left || right) {
			var newAngle:Float = 0;
			if (up) {
				newAngle = -90;
				if (left)
					newAngle -= 45;
				else if (right)
					newAngle += 45;
				facing = UP;
			} else if (down) {
				newAngle = 90;
				if (left)
					newAngle += 45;
				else if (right)
					newAngle -= 45;
				facing = DOWN;
			} else if (left) {
				newAngle = 180;
				facing = LEFT;
			} else if (right) {
				newAngle = 0;
				facing = RIGHT;
			}

			// determine our velocity based on angle and speed
			velocity.setPolarDegrees(speed, newAngle);
		}

		var action = "idle";
		// check if the player is moving, and not walking into walls
		if ((velocity.x != 0 || velocity.y != 0) && touching == NONE) {
			action = "walk";
		}

		switch (facing) {
			case LEFT, RIGHT:
				animation.play("lr_" + action);
			case DOWN:
				animation.play("d_" + action);
			case UP:
				animation.play("u_" + action);
			case _:
		}
	}

	override function update(elapsed:Float) {
		updateMovement();
		super.update(elapsed);
	}
}
