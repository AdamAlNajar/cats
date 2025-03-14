package states;

import flixel.FlxObject;
import Sys;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import states.OptionsState;
import utils.DSCRPCManager;
import flixel.input.mouse.FlxMouseEvent;

class MainMenuState extends FlxState {
	public static var playBTN:FlxButton;
	public static var optionsBTN:FlxButton;
	public static var quitBTN:FlxButton;

	public static var playTXT:FlxText;
	public static var optionsTXT:FlxText;
	public static var quitTXT:FlxText;

	public static var Game_Title:FlxText;
	public static var fontPath = "assets/fonts/SpaceMono-Regular.ttf";

	static function PlayBTNCallback() {
		// Fades out
		FlxG.camera.fade(FlxColor.BLACK, 0.54, false, function() {
			FlxG.switchState(new PlayState());
		});
		FlxG.sound.load("assets/sounds/click.wav");
	}

	static function QuitBTNCallBack() {
		#if cpp
		Sys.exit(0);
		#elseif neko
		Sys.exit(0);
		#else
		trace("quit not supported on this platform");
		#end
	}

	static function OptionsBTNCallBack() {
		FlxG.switchState(new OptionsState());
		FlxG.sound.load("assets/sounds/click.wav");
	}

	override function create() {
		FlxG.camera.fade(FlxColor.BLACK, 0.54, true); // Fades IN
		Discord.changePresence("No Details to show", "Currently In The Main Menu");
		super.create();

		Game_Title = new FlxText(0, 90, FlxG.width, "cats!", 22); // Centered horizontally
		Game_Title.alignment = CENTER;
		Game_Title.setFormat(fontPath,24);
		add(Game_Title);

		playBTN = new FlxButton(0, 0, null, PlayBTNCallback); // Set text to null
		playBTN.scale.set(3, 3);
		playBTN.updateHitbox();
		playBTN.screenCenter();
		playBTN.alpha = 0;
		add(playBTN);

		// Create a custom FlxText object for the "Play!" text and center it within the button
		playTXT = new FlxText(0, 0, FlxG.width, "Play!");
		playTXT.setFormat(fontPath, 24, 0xFFFFFF, "center"); // Adjust font size and color as needed
		playTXT.x = playBTN.x + (playBTN.width - playTXT.width) / 2; // Center horizontally within the button
		playTXT.y = playBTN.y + (playBTN.height - playTXT.height) / 2; // Center vertically within the button
		add(playTXT);

		FlxMouseEvent.add(playTXT,null,null,onMouseOver,onMouseOut);

		optionsBTN = new FlxButton(0, 0, null, OptionsBTNCallBack); // Set text to null
		optionsBTN.scale.set(3, 3);
		optionsBTN.updateHitbox();
		optionsBTN.screenCenter(X);
		optionsBTN.y = playBTN.y + playBTN.height + 10; // Adjusted y-coordinate
		optionsBTN.alpha = 0;
		add(optionsBTN);

		// Create a custom FlxText object for the "Options" text and center it within the button
		optionsTXT = new FlxText(0, 0, FlxG.width, "Options");
		optionsTXT.setFormat(fontPath, 24, 0xFFFFFF, "center"); // Adjust font size and color as needed
		optionsTXT.x = optionsBTN.x + (optionsBTN.width - optionsTXT.width) / 2; // Center horizontally within the button
		optionsTXT.y = optionsBTN.y + (optionsBTN.height - optionsTXT.height) / 2; // Center vertically within the button
		add(optionsTXT);

		quitBTN = new FlxButton(0, 0, null, QuitBTNCallBack); // Set text to null
		quitBTN.scale.set(3, 3);
		quitBTN.updateHitbox();
		quitBTN.screenCenter(X);
		quitBTN.y = optionsBTN.y + optionsBTN.height + 10; // Adjusted y-coordinate
		quitBTN.alpha = 0;
		add(quitBTN);

		// Create a custom FlxText object for the "Options" text and center it within the button
		quitTXT = new FlxText(0, 0, FlxG.width, "Quit");
		quitTXT.setFormat(fontPath, 24, 0xFFFFFF, "center"); // Adjust font size and color as needed
		quitTXT.x = quitBTN.x + (quitBTN.width - quitTXT.width) / 2; // Center horizontally within the button
		quitTXT.y = quitBTN.y + (quitBTN.height - quitTXT.height) / 2; // Center vertically within the button
		add(quitTXT);

	}

	private function onMouseOver(text:FlxText){
		text.setFormat(fontPath, 24, 0xC9C8C8, "center");
	}

	private function onMouseOut(text:FlxText) {
		text.setFormat(fontPath, 24, 0xFFFFFF, "center");
	}
}
