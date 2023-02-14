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
	public var toppingSprites:FlxTypedGroup<ToppingSprite>;

	public var sauce:String;
	public var cooked:Bool;

	public function new(toppingGroup:FlxTypedGroup<ToppingSprite>)
	{
		super();
		loadGraphic(AssetPaths.round_dough__png);
		this.x = 250;
		this.y = 250;
		this.cooked = false;
		this.toppings = new Array<ToppingEnum>();
		enableMouseClicks(false);
		enableMouseDrag();
		toppingSprites = toppingGroup;
		// mouseStartDragCallback = (_, _, _) ->
		// {
		// 	toppingGroup.clear();
		// 	if (cooked)
		// 		loadGraphic(AssetPaths.pizzabox__png, false, 100, 100);
		// 	else
		// 		loadGraphic(AssetPaths.tray__png, false, 100, 100);
		// }
		// mouseStopDragCallback = (_, _, _) -> updateGraphic();
	}

	/**
		Resets the pizza
	**/
	public function resetPizza()
	{
		var graphicFix = new FlxSprite();
		graphicFix.loadGraphic(AssetPaths.round_dough_reset__png);
		stamp(graphicFix);
		this.x = 250;
		this.y = 250;
		this.cooked = false;
		for (i in 0...toppings.length)
			toppings.shift();
	}

	/**
		topping:String - any of the toppings in the game
	**/
	public function addTopping(topping:ToppingEnum)
	{
		toppings.push(topping);
		toppingSprites.add(new ToppingSprite(topping));
		trace(toppings);
		updateGraphic(topping);
	}

	/**
	 * Update Pizza graphic based on the current toppings
	 */
	public function updateGraphic(topping:ToppingEnum, cooked:Bool = false)
	{
		// if (cooked)
		// 	loadGraphic(AssetPaths.cooked_dough__png);
		// else
		// 	loadGraphic(AssetPaths.round_dough__png);

		var tempTopping:ToppingSprite;
		tempTopping = new ToppingSprite(topping, cooked);

		// var padding = 10;
		// // place cooked sauces in the center of the pizza
		// if (cooked && (topping == ToppingEnum.dark_sauce || topping == ToppingEnum.light_sauce))
		// {
		// 	tempTopping.x = x + (width - tempTopping.width) / 2;
		// 	tempTopping.y = y + (height - tempTopping.height) / 2;
		// }
		// else // place topping randomly on top and within of the pizza
		// {
		// 	tempTopping.x = FlxG.random.float(x + padding, x + width - tempTopping.width - padding);
		// 	tempTopping.y = FlxG.random.float(y + padding, y + height - tempTopping.height - padding);
		// }
		// place ingredient sprite over the pizza
		var xPos:Int = Std.int(((this.width - tempTopping.width) / 2));
		var yPos:Int = Std.int(((this.height - tempTopping.height) / 2));

		stamp(tempTopping, xPos, yPos);

		// Add the ingredient to the toppingSprites group
		toppingSprites.add(tempTopping);
	}
}
