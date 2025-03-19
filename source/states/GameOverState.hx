package states;

import flixel.util.FlxColor;
import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import utils.Leaderboard;
import states.MainMenuState.playerName;

class GameOverState extends FlxState {
	var finalScore:Int;
	var leaderboardText:Array<FlxText>;

	public static var fontPath = "assets/fonts/SpaceMono-Regular.ttf"; // Font path

	public function new(score:Int) {
		super();
		this.finalScore = score;
	}

	override public function create() {
		super.create();

		FlxG.mouse.visible = true; // hide cursor


		// Title Text
		var title = new FlxText(0, 50, FlxG.width, "Game Over!", 32, true);
		title.alignment = "center";
		title.font = fontPath;
		add(title);

		// Score Display
		var scoreText = new FlxText(0, 100, FlxG.width, "Your Score: " + finalScore, 24, true);
		scoreText.alignment = "center";
		scoreText.font = fontPath;
		add(scoreText);

		// Note 1
		var note = new FlxText(0, 150, FlxG.width, "btw, theres a leaderboard.. wa:+917502710802", 11, true);
		note.alignment = "center";
		note.font = fontPath;
		add(note);

		// Submit Score to Leaderboard
		Leaderboard.submitScore(playerName, finalScore);

		// Restart Button (without text, text will be custom created)
		var restartButton = new FlxButton(0, 0, null, function() {
			FlxG.switchState(new PlayState());
		});

		// Scale button to make it larger
		restartButton.scale.set(3, 3);
		restartButton.updateHitbox(); // Update hitbox after scaling

		// Manually set the position to ensure it's visible
		restartButton.x = FlxG.width / 2 - restartButton.width / 2; // Center horizontally
		restartButton.y = 200; // Position vertically

		add(restartButton);

		// Create custom FlxText for Restart Button
		var restartText = new FlxText(0, 0, FlxG.width, "Restart");
		restartText.setFormat(fontPath, 12, 0xFFFFFF, "center"); // Use custom font
		restartText.color = FlxColor.BLACK;
		restartText.x = restartButton.x + (restartButton.width - restartText.width) / 2; // Center horizontally
		restartText.y = restartButton.y + (restartButton.height - restartText.height) / 2; // Center vertically
		add(restartText);

		// Exit Button (without text, text will be custom created)
		var exitButton = new FlxButton(0, 0, null, function() {
			FlxG.switchState(new MainMenuState()); // Switch to Main Menu
		});

		// Scale button to make it larger
		exitButton.scale.set(3, 3);
		exitButton.updateHitbox(); // Update hitbox after scaling

		// Manually set the position to ensure it's visible
		exitButton.x = FlxG.width / 2 - exitButton.width / 2; // Center horizontally
		exitButton.y = 250; // Position vertically

		add(exitButton);

		// Create custom FlxText for Exit Button
		var exitText = new FlxText(0, 0, FlxG.width, "Back To Main Menu");
		exitText.setFormat(fontPath, 12, 0xFFFFFF, "center"); // Use custom font
		exitText.color = FlxColor.BLACK;
		exitText.x = exitButton.x + (exitButton.width - exitText.width) / 2; // Center horizontally
		exitText.y = exitButton.y + (exitButton.height - exitText.height) / 2; // Center vertically
		add(exitText);
	}
}
