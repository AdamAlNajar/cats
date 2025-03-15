package states;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;


class DialogSubState extends FlxSubState
{
    public var dialogLines:Array<String>;
    public var currentIndex:Int;
    public var dialogText:FlxText;
    public var blackBox:FlxSprite;
    public static var fontPath = "assets/fonts/SpaceMono-Regular.ttf";

    public var onFinish:Void->Void; // Callback for when the dialog finishes

    override function create() {
        super.create();

        currentIndex = 0;
        createDialogBox();
    }

    private function createDialogBox() {
        var boxWidth = Math.floor(FlxG.width * 1);  // 100% of screen width
        var boxHeight = Math.floor(FlxG.height * 0.3);  // 30% of screen height
        var boxX = (FlxG.width - boxWidth) / 2;
        var boxY = FlxG.height - boxHeight;

        // Reset blackBox if it's already created
        if (blackBox == null) {
            blackBox = new FlxSprite(boxX, boxY);
            blackBox.makeGraphic(boxWidth, boxHeight, FlxColor.BLACK);
            add(blackBox);
        } else {
            // Reset position of blackBox
            blackBox.x = boxX;
            blackBox.y = boxY;
        }

        // Reset dialogText if it's already created
        if (dialogText == null) {
            dialogText = new FlxText(boxX, boxY + (boxHeight - 17) / 2, boxWidth, dialogLines[currentIndex]);
            dialogText.setFormat(fontPath, 17, FlxColor.WHITE, CENTER);
            add(dialogText);
        } else {
            // Reset position and text of dialogText
            dialogText.text = dialogLines[currentIndex];
            dialogText.x = boxX + (boxWidth - dialogText.width) / 2;
            dialogText.y = boxY + (boxHeight - dialogText.height) / 2;
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.SPACE) {
            currentIndex++;
            if (currentIndex < dialogLines.length) {
                // Show the next line of dialog
                dialogText.text = dialogLines[currentIndex];
            } else {
                // Dialog is finished
                if (onFinish != null) {
                    onFinish(); // Trigger the onFinish callback
                }
                close(); // Close the substate
            }
        }
    }
}