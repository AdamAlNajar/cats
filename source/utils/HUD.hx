package utils;


import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
using flixel.util.FlxSpriteUtil;

class HUD extends FlxTypedGroup<FlxSprite>
{
    public var pointsCounter:FlxText;
    public var cooldownText:FlxText; // Cooldown UI
    public static var points = 0;
    public static var fontPath = "assets/fonts/SpaceMono-Regular.ttf";
    public var timerText:FlxText;
    public static var pointMultiplier:Int = 1;

    public function new() {
        super();

        // Points counter
        pointsCounter = new FlxText(0, 0, 0, "Points: 0", 12, true);
        pointsCounter.font = fontPath;
        pointsCounter.color = FlxColor.BLACK;
        pointsCounter.borderStyle = FlxTextBorderStyle.OUTLINE;
        pointsCounter.borderColor = FlxColor.WHITE; // Outline color
        pointsCounter.borderSize = 2; // Thickness of the outline
        pointsCounter.scrollFactor.set(0, 0);
        add(pointsCounter);

        // Cooldown text
        cooldownText = new FlxText(0, 20, 0, "Ready to take a photo!", 12, true);
        cooldownText.font = fontPath;
        cooldownText.color = FlxColor.BLACK;
        cooldownText.borderStyle = FlxTextBorderStyle.OUTLINE;
        cooldownText.borderColor = FlxColor.WHITE; // Outline color
        cooldownText.borderSize = 2; // Thickness of the outline
        cooldownText.scrollFactor.set(0, 0);
        add(cooldownText);

        // Timer display
        timerText = new FlxText(0, 40, 0, "Time: 60", 12, true);
        timerText.font = fontPath;
        timerText.color = FlxColor.BLACK;
        timerText.borderStyle = FlxTextBorderStyle.OUTLINE;
        timerText.borderColor = FlxColor.WHITE;
        timerText.borderSize = 2;
        timerText.scrollFactor.set(0, 0);
        add(timerText);

    }

    public function UpdatePoints() {
        points += pointMultiplier;
        pointsCounter.text = 'Points: $points';
    }

    public function UpdateCooldown(cooldownTimer:Float, photoCooldown:Float):Void
    {
        if (cooldownTimer > 0)
        {
            cooldownText.text = "Cooldown: " + Math.ceil(cooldownTimer) + "s";
        }
        else
        {
            cooldownText.text = "Ready to take a photo!";
        }
    }

    public function updateTimer(timeLeft:Float):Void {
        timerText.text = "Time: " + Math.ceil(timeLeft);
    }

    public function getPoints():Int {
        return points;
    }
    
    
}