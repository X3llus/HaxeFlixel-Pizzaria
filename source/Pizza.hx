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
		cooked
	**/
	public var toppings:Array<ToppingEnum>;

	public var sauce:String;
	public var cooked:Bool;

	public function new()
	{
		super();
		var imgUrl = "assets/images/pizzas/round-dough.png";
		this.loadGraphic(imgUrl);
		x = 200;
		y = 200;
		this.cooked = false;
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
}
