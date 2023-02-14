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
		var tempTopping:ToppingSprite;
		tempTopping = new ToppingSprite(topping, cooked);

		// place ingredient sprite over the pizza
		var xPos:Int = Std.int(((this.width - tempTopping.width) / 2));
		var yPos:Int = Std.int(((this.height - tempTopping.height) / 2));

		stamp(tempTopping, xPos, yPos);

		// Add the ingredient to the toppingSprites group
		toppingSprites.add(tempTopping);
	}
}
