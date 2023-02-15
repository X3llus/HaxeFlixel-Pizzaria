package;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class Ticket {
    public var ticket:FlxSprite;
    public var tHead:FlxText;
    public var t1:FlxText;
    public var t2:FlxText;
    public var t3:FlxText;
    public var t4:FlxText;

    public function new(xStart:Int) {
        ticket = new FlxSprite(10 + xStart, 10);
        ticket.loadGraphic("assets/images/environment/notepad.jpg");
        ticket.scale.set(0.4, 0.4);
        ticket.updateHitbox();

        trace("Ticket number " + xStart);

        tHead = new flixel.text.FlxText(45 + xStart, 10, 0, "Current Order", 12);
        t1 = new flixel.text.FlxText(45 + xStart, 55, 0, "", 12);
        t2 = new flixel.text.FlxText(45 + xStart, 75, 0, "", 12);
        t3 = new flixel.text.FlxText(45 + xStart, 105, 0, "", 12);
        t4 = new flixel.text.FlxText(45 + xStart, 70, "", 12);

        tHead.color = FlxColor.BLACK;
        t1.color = FlxColor.BLACK;
        t2.color = FlxColor.BLACK;
        t3.color = FlxColor.BLACK;
        t4.color = FlxColor.BLACK;
        
        tHead.visible = true;
        t1.visible = true;
        t2.visible = true;
        t3.visible = true;
        t4.visible = false;
    }
}