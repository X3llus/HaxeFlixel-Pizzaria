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
		loadGraphic(AssetPaths.round_dough__png);
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
		updateGraphic();
	}

	/**
	 * Update Pizza graphic based on the current toppings
	 */
	public function updateGraphic()
	{
		if (toppings.length == 0)
		{
			loadGraphic(AssetPaths.round_dough__png);
			return;
		}
		var hasCheese = toppings.contains(ToppingEnum.yellow_cheese) || toppings.contains(ToppingEnum.white_cheese);
		var hasMushroom = toppings.contains(ToppingEnum.mushroom);
		var hasPepperoni = toppings.contains(ToppingEnum.pepperoni);
		var hasSauce = toppings.contains(ToppingEnum.light_sauce) || toppings.contains(ToppingEnum.dark_sauce);
		var hasOnlyCheese = hasCheese && !hasMushroom && !hasPepperoni;
		var hasOneTopping = (hasMushroom && !hasPepperoni) || (hasPepperoni && !hasMushroom); // XOr

		// ? The file name of the asset to display
		var assetPath = "assets/images/pizzas/";
		var pizza = "";
		if (cooked)
		{
			pizza += "cooked";
			assetPath += "cooked/";
		}
		else
		{
			pizza += "pizza";
			assetPath += "raw/";
		}

		// find correct path
		if (!hasSauce)
		{
			assetPath += "no-sauce/";
			if (!cooked)
			{
				if (hasMushroom && hasPepperoni)
					assetPath += "two-toppings/";
				else if (hasPepperoni)
					assetPath += "pepperoni/";
				else if (hasMushroom)
					assetPath += "mushroom/";
				else if (hasCheese)
					assetPath += "cheese-only/";
			}
			else
			{
				if (hasMushroom && hasPepperoni)
					assetPath += "two-toppings/";
				else if (hasOneTopping)
					assetPath += "one-topping/";
			}
		}
		else if (hasOnlyCheese && hasSauce)
			assetPath += "cheese-only/"
		else if (hasSauce && hasOneTopping)
		{
			assetPath += "one-topping/";
			if (!hasCheese)
				assetPath += "no-cheese/";
			else if (hasMushroom)
				assetPath += "mushroom/";
			else if (hasPepperoni)
				assetPath += "pepperoni/";
		}
		else if (hasPepperoni && hasMushroom)
		{
			assetPath += "two-toppings/";
			// so far only 1 variant for sauce colours for cooked pizza
			if (!cooked)
			{
				if (!hasCheese)
					assetPath += "no-cheese/";
				else if (toppings.contains(ToppingEnum.light_sauce))
					assetPath += "light-sauce/";
				else if (toppings.contains(ToppingEnum.dark_sauce))
					assetPath += "dark-sauce/";
			}
		}

		// find correct pizza image
		// so far only 1 variant for sauce colours for cooked pizza
		if (toppings.contains(ToppingEnum.light_sauce))
			pizza += "-ls";
		else if (toppings.contains(ToppingEnum.dark_sauce))
			pizza += "-ds";

		if (toppings.contains(ToppingEnum.yellow_cheese))
			pizza += "-yc";
		else if (toppings.contains(ToppingEnum.white_cheese))
			pizza += "-wc";

		if (toppings.contains(ToppingEnum.pepperoni))
			pizza += "-p";
		if (toppings.contains(ToppingEnum.mushroom))
			pizza += "-m";

		loadGraphic(assetPath + pizza + ".png", false, 100, 100);
	}
}
