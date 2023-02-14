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
        ticket = new FlxSprite(10 + xStart, 100);
        ticket.loadGraphic("assets/images/environment/notepad.jpg");
        ticket.scale.set(0.30, 0.30);
        ticket.updateHitbox();

        trace("Ticket number " + xStart);

        

        tHead = new flixel.text.FlxText(39 + xStart, 100, 0, "Current Order", 12);
        t1 = new flixel.text.FlxText(39 + xStart, 135, 0, "", 12);
        t2 = new flixel.text.FlxText(39 + xStart, 165, 0, "", 12);
        t3 = new flixel.text.FlxText(39 + xStart, 195, 0, "", 9);
        t4 = new flixel.text.FlxText(37 + xStart, 160, "", 7);

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