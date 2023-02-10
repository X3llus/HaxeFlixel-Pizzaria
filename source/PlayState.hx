package;

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
	var draggedTopping:Topping;
	var pizza:Pizza;

	override public function create()
	{
		// Adds the FlxMouseControl plugin - absolutely required
		FlxG.plugins.list.push(new FlxMouseControl());

		// Create a group of toppings
		toppings = new FlxTypedGroup<Topping>();

		var atlasFrame = FlxAtlasFrames.fromTexturePackerJson(AssetPaths.pepperoni_spritesheet__png, AssetPaths.pepperoni_spritesheet__json);
		var pepperoni = new Topping("Pepperoni", atlasFrame);
		pepperoni.frame = pepperoni.frames.getByIndex(0);
		toppings.add(pepperoni);

		add(toppings);
		toppings.forEach((topping) ->
		{
			topping.enableMouseClicks(false); // = true;
		});

		pizza = new Pizza("Large");
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
			if (topping.draggableTopping != null)
			{
				draggedTopping = topping.draggableTopping;
			}
		});

		FlxG.overlap(draggedTopping, pizza, addTopping, checkTopping);
		super.update(elapsed);
	}

	/**
		Takes a Topping object and Pizza object, adds the topping to the
		pizza's topping array of toppings.
	**/
	function addTopping(topping:Topping, pizza:Pizza)
	{
		if (FlxG.pixelPerfectOverlap(topping, pizza))
		{
			// Add the topping to the pizza once it is done being dragged
			if (topping.isDragged == false)
			{
				pizza.addTopping(topping.name);
				topping.kill();
			};
		};
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
}
