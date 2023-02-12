package;

import Topping.ToppingEnum;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxExtendedSprite;
import flixel.addons.plugin.FlxMouseControl;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;

class PlayState extends FlxState
{
	var toppings:FlxTypedGroup<Topping>;
	var pizza:Pizza;

	public var draggedTopping:Topping;

	override public function create()
	{
		// Adds the FlxMouseControl plugin - absolutely required
		FlxG.plugins.list.push(new FlxMouseControl());

		// Create a group of toppings
		toppings = new FlxTypedGroup<Topping>();
		createTopping(pepperoni, 0, 600);
		createTopping(mushroom, 100, 600);
		createTopping(yellow_cheese, 200, 600);
		createTopping(white_cheese, 300, 600);

		// var atlasFrame = FlxAtlasFrames.fromTexturePackerJson(AssetPaths.pepperoni_spritesheet__png, AssetPaths.pepperoni_spritesheet__json);
		// var pepperoni = new Topping("Pepperoni", atlasFrame);
		// pepperoni.frame = pepperoni.frames.getByIndex(0);
		// toppings.add(pepperoni);

		add(toppings);
		toppings.forEach((topping) ->
		{
			topping.enableMouseClicks(false); // = true;
		});

		pizza = new Pizza();
		add(pizza);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		/**
			Have to iterate through all the toppings to check if there is a
			topping being dragged so that we can check for overlapping.
		**/
		toppings.forEach((topping) ->
		{
			if (topping.draggableTopping != null && topping.draggableTopping.alive == true)
			{
				draggedTopping = topping.draggableTopping;
			}
		});

		// This runs when the mouse button has been let go and the topping is no longer being dragged
		if (draggedTopping != null && draggedTopping.isDragged == false)
		{
			// If it overlaps, addTopping will run if checkTopping returns true,
			// don't do anything on overlap true return, kill sprite on false overlap return
			FlxG.overlap(draggedTopping, pizza, addTopping, checkTopping) ? null : draggedTopping.kill();
		}

		super.update(elapsed);
	}

	/**
		Takes a Topping object and Pizza object, adds the topping to the
		pizza's toppings array.
	**/
	function addTopping(topping:Topping, pizza:Pizza)
	{
		if (FlxG.pixelPerfectOverlap(topping, pizza))
		{
			pizza.addTopping(topping.value);
		}
		topping.kill();
	}

	function checkTopping(topping:Topping, pizza:Pizza)
	{
		if (topping == null)
		{
			return false;
		}
		else
		{
			return true;
		}
	}

	function createTopping(topping:ToppingEnum, x:Float, y:Float)
	{
		toppings.add(new Topping(topping, x, y));
	}
}
