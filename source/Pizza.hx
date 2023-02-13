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
		var hasOneTopping = (hasMushroom && !hasPepperoni) || (hasPepperoni && !hasMushroom); //XOr

		// ? The file name of the asset to display
		var asset = "assets/images/pizzas/";
		var pizza = "";
		if (cooked)
			{
				pizza+="cooked";
				asset += "cooked/";}
		else
			{
				pizza+="pizza";asset += "raw/";}

		if(hasOnlyCheese && hasSauce)
			asset+="cheese-only/"
		else if(hasSauce &&hasOneTopping)
			{
				asset+="one-topping/";
				if(!hasCheese)
					asset+="no-cheese/";
				else if(hasMushroom)
					asset+="mushroom/";
				else if(hasPepperoni)
					asset+="pepperoni/";
			}
			else if(hasPepperoni && hasMushroom)
			{
				asset+="two-toppings/";
			// so far only 1 variant for sauce colours for cooked pizza
				if(!cooked){
			if (!hasCheese)
				asset += "no-cheese/";
			else if (toppings.contains(ToppingEnum.light_sauce))
				asset+="light-sauce/";
			else if (toppings.contains(ToppingEnum.dark_sauce))
				asset+="dark-sauce/";
		}
			}


		// so far only 1 variant for sauce colours for cooked pizza
			if(!cooked){
		if (toppings.contains(ToppingEnum.light_sauce))
			pizza += "-ls";
		else if (toppings.contains(ToppingEnum.dark_sauce))
			pizza += "-ds";
	}

		if (toppings.contains(ToppingEnum.yellow_cheese))
			pizza += "-yc";
		else if (toppings.contains(ToppingEnum.white_cheese))
			pizza += "-wc";

		if (toppings.contains(ToppingEnum.pepperoni))
			pizza += "-p";
		if (toppings.contains(ToppingEnum.mushroom))
			pizza += "-m";


		loadGraphic(asset+pizza+".png", false, 100, 100);
	}
}
