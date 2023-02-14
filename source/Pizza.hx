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
	public var toppingSprites:FlxTypedGroup<FlxSprite>;

	public var sauce:String;
	public var cooked:Bool;

	public function new(toppingGroup:FlxTypedGroup<FlxSprite>)
	{
		super();
		loadGraphic(AssetPaths.round_dough__png);
		x = FlxG.width / 2 - width / 2;
		y = FlxG.height / 2 - height / 2;
		this.cooked = false;
		this.toppings = new Array<ToppingEnum>();
		enableMouseDrag();

		toppingSprites = toppingGroup;
		mouseStartDragCallback = (_, _, _) ->
		{
			toppingGroup.clear();
			if (cooked)
				loadGraphic(AssetPaths.pizzabox__png, false, 100, 100);
			else
				loadGraphic(AssetPaths.tray__png, false, 100, 100);
		}
		mouseStopDragCallback = (_, _, _) -> updateGraphic();
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

		toppingSprites.clear();

		var tempTopping:ToppingSprite;
		var padding = 10;
		for (topping in toppings)
		{
			tempTopping = new ToppingSprite(topping, cooked);
			// place cooked sauces in the center of the pizza
			if (cooked && (topping == ToppingEnum.dark_sauce || topping == ToppingEnum.light_sauce))
			{
				tempTopping.x = x + (width - tempTopping.width) / 2;
				tempTopping.y = y + (height - tempTopping.height) / 2;
			}
			else // place topping randomly on top and within of the pizza
			{
				tempTopping.x = FlxG.random.float(x + padding, x + width - tempTopping.width - padding);
				tempTopping.y = FlxG.random.float(y + padding, y + height - tempTopping.height - padding);
			}
			toppingSprites.add(tempTopping);
		}
	}
}
