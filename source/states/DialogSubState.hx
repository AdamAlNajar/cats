package states;

import sys.io.FileInput;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;

class DialogSubState extends FlxSubState {

    private var dialogText:FlxText;
    private var dialogLines:Array<String>;
    private var currentIndex:Int;
    
    override function create() {
        super.create();

        dialogText = new FlxText(50, 50, FlxG.width - 100, "TEST");
        add(dialogText);

        dialogLines = [];
        currentIndex = 0;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
    }
}