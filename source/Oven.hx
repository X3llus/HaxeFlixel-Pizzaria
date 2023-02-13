package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

class Oven extends FlxSprite
{
	public var ovenEmpty:Bool;
	public var pizza:Pizza;

	public function new(x:Float, y:Float)
	{
		super();
		this.x = x;
		this.y = y;
		this.scale.x = 2;
		this.scale.y = 2;
		this.updateHitbox();
		this.ovenEmpty = true;
		this.loadGraphic("assets/images/environment/oven.png");
		FlxG.state.add(this);
	}

	public function cookPizza(pizza:Pizza)
	{
		this.pizza = pizza;
		// Update oven graphic so it is closed
		this.loadGraphic("assets/images/environment/oven-closed.png");
		// Cook the pizza after x seconds
		var timer = new FlxTimer();
		timer.start(5.0, updatePizza, 1);
	}

	/**
		Update the pizza cooked parameter to true,
		reset the oven graphic to default, and
		make the pizza visible again.
	**/
	function updatePizza(_)
	{
		pizza.cooked = true;
		this.loadGraphic("assets/images/environment/oven.png");
		trace("pizza cooked");
		pizza.visible = true; // Make the pizza visible again
		// update the pizza's graphic now that the cooked status has changed
		pizza.updateGraphic();
	}
}
