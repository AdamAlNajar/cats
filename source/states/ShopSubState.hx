package states;

import utils.HUD;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.ui.FlxButton;
import flixel.text.FlxText;

class ShopSubState extends FlxSubState
{
    var pointsText:FlxText;

    var upgrades:Array<{ name:String, description:String, cost:Int, purchased:Bool, apply:Void->Void }>;


    override function create()
    {
        super.create();
        trace("Substate created!");

        FlxG.mouse.visible = true;

        setupUpgrades();


        drawBackground();
        drawTitle();
        drawPoints();
        drawUpgrades();
        drawExit();
    }

    function setupUpgrades()
    {
        upgrades = [
            {
                name: "Double Points",
                description: "Earn 2x points per cat!",
                cost: 5,
                purchased: false,
                apply: function() HUD.pointMultiplier += 2
            }
        ];
    }

    function drawBackground()
    {
        var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(0, 0, 0, 180));
        bg.scrollFactor.set();
        add(bg);

        var panel = new FlxSprite(40, 40).makeGraphic(FlxG.width - 80, FlxG.height - 80, FlxColor.fromRGB(30, 30, 30));
        panel.scrollFactor.set();
        add(panel);
    }

    function drawTitle()
    {
        var title = new FlxText(0, 50, FlxG.width, "Upgrades Time!");
        title.setFormat(null, 20, FlxColor.WHITE, "center");
        title.scrollFactor.set();
        add(title);
    }

    function drawPoints()
    {
        pointsText = new FlxText(0, 80, FlxG.width, getPointsText());
        pointsText.setFormat(null, 14, FlxColor.YELLOW, "center");
        pointsText.scrollFactor.set();
        add(pointsText);
    }

    function getPointsText():String {
        return "Cat Coins: " + HUD.points;
    }

    function drawUpgrades()
    {
        var startY = 100;
        var spacing = 80;
        var centerX = FlxG.width / 2 - 150;

        for (i in 0...upgrades.length)
        {
            var upgrade = upgrades[i];
            var yPos = startY + i * spacing;

            var nameText = new FlxText(centerX, yPos, 300, upgrade.name);
            nameText.setFormat(null, 14, FlxColor.WHITE);
            add(nameText);

            var descText = new FlxText(centerX, yPos + 18, 300, upgrade.description);
            descText.setFormat(null, 10, FlxColor.GRAY);
            add(descText);

            var costText = new FlxText(centerX, yPos + 36, 100, "Cost: " + upgrade.cost);
            costText.setFormat(null, 10, FlxColor.YELLOW);
            add(costText);

            // Wrap the upgrade in a closure
            var upgradeRef = upgrade;

            var button = new FlxButton(centerX + 120, yPos + 32, upgradeRef.purchased ? "Bought" : "Buy");
            button.onUp.callback = function() {
                tryPurchase(upgradeRef, button);
            };
            button.scrollFactor.set();
            button.label.setFormat(null, 10, FlxColor.WHITE, "center");
            button.active = !upgrade.purchased;
            add(button);
        }
    }

    function tryPurchase(upgrade:{ name:String, description:String, cost:Int, purchased:Bool, apply:Void->Void }, button:FlxButton)
    {
        if (upgrade.purchased) return;

        if (HUD.points >= upgrade.cost)
        {
            HUD.points -= upgrade.cost;
            upgrade.purchased = true;
            upgrade.apply();

            button.text = "Bought";
            button.active = false;

            pointsText.text = getPointsText();
        }
        else
        {
            pointsText.text = "Not enough coins!";
        }
    }


    function drawExit()
    {
        var exit = new FlxButton(FlxG.width / 2 - 30, FlxG.height - 50, "Exit", function() {
            close();
            FlxG.mouse.visible = false;
        });
        exit.color = FlxColor.RED;
        exit.label.setFormat(null, 12, FlxColor.WHITE, "center");
        add(exit);
    }

    override function update(elapsed:Float) {
        super.update(elapsed/2);
    }

}
