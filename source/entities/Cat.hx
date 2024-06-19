package entities;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Cat extends FlxSprite {
	public function new(x:Float = 0, y:Float = 0) {
		super(x, y);
		makeGraphic(16, 16, FlxColor.BLACK);

		setFacingFlip(LEFT, true, false);
		setFacingFlip(RIGHT, false, false);

		drag.x = drag.y = 800;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
	}
}
