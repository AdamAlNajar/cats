package states;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;


class DialogSubState extends FlxSubState {

    public var dialogText:FlxText;
    public var dialogLines:Array<String>;
    public var currentIndex:Int;
    public var blackBox:FlxSprite;
    
    override function create() {
        super.create();

        dialogLines = [];
        currentIndex = 0;

        var boxWidth:Int = 600;
        var boxHeight:Int = 150;
        var boxX:Int = (FlxG.width - boxWidth);
        var boxY:Int = FlxG.height - boxHeight - 20; // 20 pixels from the bottom

        // Black Box for Dialog
        blackBox = new FlxSprite(boxX,boxY);
        blackBox.makeGraphic(boxWidth,boxHeight,FlxColor.BLACK);
        add(blackBox);

        // Center the text within the black box
        dialogText = new FlxText(boxX + 10, boxY + 10, boxWidth - 20, "Test");
        dialogText.setFormat(null, 17, FlxColor.WHITE, CENTER);
        add(dialogText);
        
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        /**To Do for next light year
            Make it so that players can switch indexes forward
        **/
    }
}