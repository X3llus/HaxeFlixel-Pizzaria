package;

import Assets.ToppingSprite;
import Topping.ToppingEnum;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxExtendedSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxRandom;

class Pizza extends FlxExtendedSprite
{
	/**
		toppings
		sauce
		cooked
	**/
	public var toppings:Array<ToppingEnum>;

	/** Reference to external container of this pizza's toppings */
	private var toppingSprites:FlxGroup;

	public var sauce:String;
	public var cooked:Bool;

	public function new(toppingGroup:FlxGroup)
	{
		super();
		loadGraphic(AssetPaths.round_dough__png);
		x = 200;
		y = 200;
		this.cooked = false;
		this.toppings = new Array<ToppingEnum>();
		enableMouseDrag();
		toppingSprites = toppingGroup;
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
		if (cooked)
			loadGraphic(AssetPaths.cooked_dough__png, false, 100, 100, false);
		else
			loadGraphic(AssetPaths.round_dough__png, false, 100, 100, false);

		var tempTopping:ToppingSprite;
		var padding = 5;
		for (topping in toppings)
		{
			tempTopping = new ToppingSprite(topping);
			// place topping randomly on top and within of the pizza
			tempTopping.x = FlxG.random.float(x + padding, x + width - tempTopping.width - padding);
			tempTopping.x = FlxG.random.float(y + padding, y + height - tempTopping.height - padding);
			toppingSprites.add(tempTopping);
		}

		if (toppings.length == 0)
		{
			toppingSprites.forEach(flxbasic -> flxbasic.kill(), true);
			toppingSprites.clear();
		}
	}
}
