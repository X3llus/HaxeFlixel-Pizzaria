package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxExtendedSprite;
import flixel.math.FlxRandom;

class Pizza extends FlxExtendedSprite
{
	/**
		toppings
		sauce
		bake level
	**/
	public var toppings:Array<String>;

	public var sauce:String;
	public var bake:String;

	// public var rand:FlxRandom;

	public function new()
	{
		super();
		var imgUrl = "assets/images/round-dough.png";
		this.loadGraphic(imgUrl);
		x = 200;
		y = 200;
		this.toppings = new Array<String>();
		enableMouseDrag();
	}

	/**
		topping:String - any of the toppings in the game
	**/
	public function addTopping(topping:String)
	{
		toppings.push(topping);
		trace(toppings);
	}

	/**
		Loads the appropraitely sized pizza.
		size:String - small, medium, large
	**/
	// function loadPizzaGraphic(size:String)
	// {
	// 	var imgUrl = "assets/images/pizza" + size + ".png";
	// 	this.loadGraphic(imgUrl);
	// }
	/**
		Loads the "on pizza" graphic for the given ingredient.
		ingredient:String - must be one of the ingredients in the game
	**/
	// function addIngredientGraphic(ingredient:String)
	// {
	// 	var sprite = new FlxSprite();
	// 	rand = new FlxRandom();
	// 	sprite.loadGraphic("assets/images/" + ingredient.toLowerCase() + "3.png");
	// 	sprite.x = this.x;
	// 	sprite.y = this.y;
	// 	sprite.angle = rand.float(1, 360);
	// 	FlxG.state.add(sprite);
	// }
}
