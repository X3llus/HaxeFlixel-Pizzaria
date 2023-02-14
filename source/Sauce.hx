package;

import Topping.ToppingEnum;
import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseEvent;

class Sauce extends FlxSprite
{
	public var value:ToppingEnum;
	public var addSauce:Bool = false;

	public function new(value:ToppingEnum, x:Float, y:Float)
	{
		super();
		this.value = value;
		this.x = x;
		this.y = y;
		this.loadGraphic("assets/images/ingredients/" + value + ".png");
		FlxMouseEvent.add(this, null, onMouseUp);
	}

	function onMouseUp(_)
	{
		addSauce = true;
	}
}
