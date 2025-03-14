package utils;

import flixel.FlxCamera;
import haxe.Int64;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
using flixel.util.FlxSpriteUtil;

class HUD extends FlxTypedGroup<FlxSprite>
{
	public var pointsCounter:FlxText;
    var points = 0;

    public function new() {
        super();
        pointsCounter = new FlxText(0,0,0,"POINTS", 12);
        pointsCounter.color = FlxColor.BLACK;
        pointsCounter.scrollFactor.set(0,0);
        add(pointsCounter);
    }

    public function UpdatePoints() {
        points++;
        pointsCounter.text = 'Points : $points';
    }
}