package;

import Topping.ToppingEnum;
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
	public var toppings:Array<ToppingEnum>;

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
		this.toppings = new Array<ToppingEnum>();
		enableMouseDrag();
	}

	/**
		topping:String - any of the toppings in the game
	**/
	public function addTopping(topping:ToppingEnum)
	{
		toppings.push(topping);
		trace(toppings);
		updateToppings();
	}

	/**
	 * Update Pizza graphic based on the current toppings
	 */
	function updateToppings()
	{
		// ? The file name of the asset to display
		var asset = "assets/images/";
		if (toppings.contains(ToppingEnum.cooked))
			asset += "cooked/cooked";
		else if (toppings.contains(ToppingEnum.raw))
			asset += "raw/raw";
		// so far only 1 variab=nt for sauce colours for cooked pizza
		if (toppings.contains(ToppingEnum.light_sauce) && !toppings.contains(ToppingEnum.cooked))
			asset += "-ls";
		else if (toppings.contains(ToppingEnum.dark_sauce))
			asset += "-ds";
		if (toppings.contains(ToppingEnum.yellow_cheese))
			asset += "-yc";
		else if (toppings.contains(ToppingEnum.white_cheese))
			asset += "-wc";
		if (toppings.contains(ToppingEnum.mushroom))
			asset += "-m";
		if (toppings.contains(ToppingEnum.pepperoni))
			asset += "-p";
		asset += ".png";
		loadGraphic(asset, false, 100, 100);
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
