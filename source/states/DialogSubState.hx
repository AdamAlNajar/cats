package states;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;


class DialogSubState extends FlxSubState {

    public var dialogLines:Array<String>;
    public var currentIndex:Int;

    public var dialogText:FlxText;
    public var blackBox:FlxSprite;
    public static var fontPath = "assets/fonts/SpaceMono-Regular.ttf";
    
    override function create() {
        super.create();

        currentIndex = 0;

        createDialogBox();

        trace(blackBox);// debug
        
    }

    // This method creates the dialog box and text, to be called each time dialog is triggered
    private function createDialogBox() {
        var boxWidth = Math.floor(FlxG.width * 0.8);  // 80% of screen width
        var boxHeight = Math.floor(FlxG.height * 0.2);  // 20% of screen height
        var boxX = (FlxG.width - boxWidth) / 2;
        var boxY = 245;
        trace(boxX);// debug
        trace(boxY);// debug
        trace(boxWidth);// debug
        trace(boxHeight);// debug

        // Reset blackBox if it's already created
        if (blackBox == null) {
            blackBox = new FlxSprite(boxX, boxY);
            blackBox.makeGraphic(boxWidth, boxHeight, FlxColor.BLACK);
            add(blackBox);
            trace(boxX); // debug
            trace(boxY);// debug
            trace(boxWidth);// debug
            trace(boxHeight);// debug
        } else {
            // Reset position of blackBox
            blackBox.x = boxX;
            blackBox.y = boxY;
            trace(boxX);// debug
            trace(boxY);// debug
            trace(boxWidth);// debug
            trace(boxHeight);// debug
        }

        // Reset dialogText if it's already created
        if (dialogText == null) {
            dialogText = new FlxText(boxX, boxY + (boxHeight - 17) / 2, boxWidth, dialogLines[currentIndex]);
            dialogText.setFormat(fontPath, 17, FlxColor.WHITE, CENTER);
            add(dialogText);
        } else {
            // Reset position and text of dialogText
            dialogText.text = dialogLines[currentIndex]; // Reset the text for the new dialog line
            // Calculate the correct centered position
            // Center horizontally by subtracting half of the dialogText's width from the blackBox's X position
            dialogText.x = boxX + (boxWidth - dialogText.width) / 2;
            
            // Center vertically by subtracting half of the dialogText's height from the blackBox's Y position
            dialogText.y = boxY + (boxHeight - dialogText.height) / 2;
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if(FlxG.keys.justPressed.SPACE){
            currentIndex++;
            if(currentIndex < dialogLines.length){
                dialogText.text = dialogLines[currentIndex];
                // if there is still dialog to dialog, continue
            }
            else{
                // otherwise, begin closing preperations
                dialogLines = [];
                dialogText = null;
                blackBox = null;
                trace(dialogLines); // debug
                trace(blackBox); // debug
                close();
            }
        }
    }
}