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
    
    override function create() {
        super.create();

        currentIndex = 0;

        var boxWidth = 600;
        var boxHeight = 150;
        var boxX = (FlxG.width - boxWidth) / 2; // Center the box
        var boxY = (FlxG.height - boxHeight) / 2;
        
        // Black Box for Dialog
        blackBox = new FlxSprite(boxX, boxY);
        blackBox.makeGraphic(boxWidth, boxHeight, FlxColor.BLACK);
        add(blackBox);
        
        // Center the text within the black box
        dialogText = new FlxText(boxX, boxY + (boxHeight - 17) / 2, boxWidth, dialogLines[currentIndex]);
        dialogText.setFormat(null, 17, FlxColor.WHITE, CENTER);
        add(dialogText);
        
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if(FlxG.keys.justPressed.SPACE){
            currentIndex++;
            dialogText.text = dialogLines[currentIndex];
            trace(currentIndex);
            if(currentIndex > dialogLines.length -1){
                dialogLines = [];
                trace(dialogLines); // debug
                close();
            }
        }
    }
}