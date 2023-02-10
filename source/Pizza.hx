package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxExtendedSprite;

class Pizza extends FlxExtendedSprite
{
	/**
		toppings
		sauce
		bake level
		size
	**/
	public var toppings:Array<String>;

	public var sauce:String;
	public var bake:String;
	public var size:String;

	/**
		size:String - small, medium, large
	**/
	public function new(size:String)
	{
		super();
		this.size = size;
		loadPizzaGraphic(size);
		x = 200;
		y = 200;
		this.toppings = new Array<String>();
	}

	/**
		topping:String - any of the toppings in the game
	**/
	public function addTopping(topping:String)
	{
		// No duplicate toppings
		if (!toppings.contains(topping))
		{
			toppings.push(topping);
			var sprite = new FlxSprite();
			sprite.loadGraphic("assets/images/pepperoni3.png");
			FlxG.state.add(sprite);
		}
		trace(topping);
	}

	function loadPizzaGraphic(size:String)
	{
		var imgUrl = "assets/images/pizza" + size + ".png";
		this.loadGraphic(imgUrl);
	}
}
