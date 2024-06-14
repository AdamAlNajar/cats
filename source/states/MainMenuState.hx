package states;

import AssetPaths;
import Sys;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import states.OptionsState;

class MainMenuState extends FlxState {
	public static var playBTN:FlxButton;
	public static var optionsBTN:FlxButton;
	public static var quitBTN:FlxButton;

	public static var playTXT:FlxText;
	public static var optionsTXT:FlxText;
	public static var quitTXT:FlxText;

	public static var Game_Title:FlxText;

	static function PlayBTNCallback() {
		// Fades out
		FlxG.camera.fade(FlxColor.BLACK, 0.54, false, function() {
			FlxG.switchState(new PlayState());
		});
	}

	static function QuitBTNCallBack() {
		#if cpp
		Sys.exit(0);
		#elseif neko
		Sys.exit(0)
		#else
		trace("quit not supported on this platform");
		#end
	}

	static function OptionsBTNCallBack() {
		FlxG.switchState(new OptionsState());
	}

	override function create() {
		FlxG.camera.fade(FlxColor.BLACK, 0.54, true); // Fades IN
		super.create();

		Game_Title = new FlxText(0, 90, FlxG.width, "untitled gaem", 22); // Centered horizontally
		Game_Title.alignment = CENTER;
		add(Game_Title);

		playBTN = new FlxButton(0, 0, null, PlayBTNCallback); // Set text to null
		playBTN.scale.set(3, 3);
		playBTN.updateHitbox();
		playBTN.screenCenter();
		add(playBTN);

		// Create a custom FlxText object for the "Play!" text and center it within the button
		playTXT = new FlxText(0, 0, FlxG.width, "Play!");
		playTXT.setFormat(null, 24, 0x000000, "center"); // Adjust font size and color as needed
		playTXT.x = playBTN.x + (playBTN.width - playTXT.width) / 2; // Center horizontally within the button
		playTXT.y = playBTN.y + (playBTN.height - playTXT.height) / 2; // Center vertically within the button
		add(playTXT);

		optionsBTN = new FlxButton(0, 0, null, OptionsBTNCallBack); // Set text to null
		optionsBTN.scale.set(3, 3);
		optionsBTN.updateHitbox();
		optionsBTN.screenCenter(X);
		optionsBTN.y = playBTN.y + playBTN.height + 10; // Adjusted y-coordinate
		add(optionsBTN);

		// Create a custom FlxText object for the "Options" text and center it within the button
		optionsTXT = new FlxText(0, 0, FlxG.width, "Options");
		optionsTXT.setFormat(null, 24, 0x000000, "center"); // Adjust font size and color as needed
		optionsTXT.x = optionsBTN.x + (optionsBTN.width - optionsTXT.width) / 2; // Center horizontally within the button
		optionsTXT.y = optionsBTN.y + (optionsBTN.height - optionsTXT.height) / 2; // Center vertically within the button
		add(optionsTXT);

		quitBTN = new FlxButton(0, 0, null, QuitBTNCallBack); // Set text to null
		quitBTN.scale.set(3, 3);
		quitBTN.updateHitbox();
		quitBTN.screenCenter(X);
		quitBTN.y = optionsBTN.y + optionsBTN.height + 10; // Adjusted y-coordinate
		add(quitBTN);

		// Create a custom FlxText object for the "Options" text and center it within the button
		quitTXT = new FlxText(0, 0, FlxG.width, "Quit");
		quitTXT.setFormat(null, 24, 0x000000, "center"); // Adjust font size and color as needed
		quitTXT.x = quitBTN.x + (quitBTN.width - quitTXT.width) / 2; // Center horizontally within the button
		quitTXT.y = quitBTN.y + (quitBTN.height - quitTXT.height) / 2; // Center vertically within the button
		add(quitTXT);
	}
}
