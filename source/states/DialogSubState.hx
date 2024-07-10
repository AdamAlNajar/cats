package states;

import haxe.Json;
import haxe.Resource;
import sys.io.FileInput;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;

class DialogueLoader {
    public static function loadDialogue(filename:String):Dynamic {
        var jsonString:String = Resource.getString(filename);
        return Json.parse(jsonString);
    }
}

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

        persistentDraw = false;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
    }
}