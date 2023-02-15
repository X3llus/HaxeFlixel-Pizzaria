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

	public var sauce:String;
	public var cooked:Bool;

	public function new()
	{
		super();
		loadGraphic(AssetPaths.round_dough_large__png);
		this.scale.set(0.2, 0.2);
		this.updateHitbox();
		this.x = FlxG.width / 2 - width / 2;
		this.y = FlxG.height / 2 - height / 2;

		this.cooked = false;
		this.toppings = new Array<ToppingEnum>();
		enableMouseDrag();
	}

	/**
		Resets the pizza
	**/
	public function resetPizza()
	{
		var graphicFix = new FlxSprite();
		graphicFix.loadGraphic(AssetPaths.round_dough_large_reset__png);
		stamp(graphicFix);
		this.x = FlxG.width / 2 - width / 2;
		this.y = FlxG.height / 2 - height / 2;
		this.cooked = false;
		for (i in 0...toppings.length)
			toppings.shift();
	}

	/**
		topping:ToppingEnum - any of the toppings in the game
	**/
	public function addTopping(topping:ToppingEnum)
	{
		toppings.push(topping);
		trace(toppings);
		updateGraphic(topping);
	}

	/**
	 * Stamps the corresponding topping graphic onto the pizza
	 */
	public function updateGraphic(topping:ToppingEnum, cooked:Bool = false)
	{
		var tempTopping:ToppingSprite;
		tempTopping = new ToppingSprite(topping, cooked);
		stamp(tempTopping);
	}
}
