package;

import flixel.FlxSprite;
import Topping.ToppingEnum;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.plugin.FlxMouseControl;
import flixel.group.FlxGroup;
import flixel.input.mouse.FlxMouseEventManager;

class PlayState extends FlxState
{
	var toppings:FlxTypedGroup<Topping>;
	var sauces:FlxTypedGroup<Sauce>;
	var pizza:Pizza;
	var oven:Oven;
	var trash:FlxSprite;

	public var draggedTopping:Topping;

	override public function create()
	{
		// Adds the FlxMouseControl plugin - absolutely required
		FlxG.plugins.list.push(new FlxMouseControl());
		FlxG.plugins.add(new FlxMouseEventManager());

		// Create a group of toppings
		toppings = new FlxTypedGroup<Topping>();
		createTopping(pepperoni, 0, 600);
		createTopping(mushroom, 100, 600);
		createTopping(yellow_cheese, 200, 600);
		createTopping(white_cheese, 300, 600);
		add(toppings);

		// Create a group of sauces
		sauces = new FlxTypedGroup<Sauce>();
		createSauce(dark_sauce, 400, 600);
		createSauce(light_sauce, 500, 600);
		add(sauces);

		// Create a pizza
		pizza = new Pizza();
		add(pizza);

		// Create an oven
		oven = new Oven(200, 500);
		add(oven);
		// create trash sprite
		trash = new FlxSprite(0, 500, "assets/images/environment/trash.png");
		add(trash);

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

		/**
			Iterate through all sauces to determine if a sauce must be added
		**/
		sauces.forEach((sauce) ->
		{
			if (sauce.addSauce)
			{
				pizza.addTopping(sauce.value);
				sauce.addSauce = false;
			}
		});

		// Only check for overlapping if the pizza is not being dragged
		if (pizza.isDragged == false)
		{
			FlxG.overlap(oven, pizza, cookPizza);
			FlxG.overlap(trash, pizza, resetPizza);
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

	/**
		Creates a new topping with the given ToppingEnum and x,y coordinates
	**/
	function createTopping(topping:ToppingEnum, x:Float, y:Float)
	{
		toppings.add(new Topping(topping, x, y));
	}

	/**
		Creates a new sauce with given ToppingEnum and x,y coordinates
	**/
	function createSauce(sauce:ToppingEnum, x:Float, y:Float)
	{
		var sauce = new Sauce(sauce, x, y);
		sauces.add(sauce);
	}

	/**
		Moves the pizza and makes it invisible, then calls the cookPizza function
			from the Oven class to cook the pizza
	**/
	function cookPizza(oven:Oven, pizza:Pizza)
	{
		// We must immediately move the pizza to its finished position and make it invisible
		// Some how the overlap is still triggered 4 times before this runs.
		pizza.x = oven.x + 800; // move to the right of pizza, this can be changed
		pizza.visible = false;
		oven.cookPizza(pizza);
	}

	/**
	 * Move the pizza back to the starting position and remove all toppings
	 */
	function resetPizza(trash:FlxSprite, pizza:Pizza)
	{
		// move pizza back to the initial position
		pizza.x = pizza.y = 200;
		pizza.cooked = false;
		for (i in 0...pizza.toppings.length)
			pizza.toppings.shift();
	}
}
