package;

import Assets.AssetsUtil;
import PizzaOrder;
import Topping.ToppingEnum;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxExtendedSprite;
import flixel.addons.plugin.FlxMouseControl;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	var toppings:FlxTypedGroup<Topping>;
	var sauces:FlxTypedGroup<Sauce>;
	var pizza:Pizza;
	var oven:Oven;
	var trash:FlxSprite;

	public var draggedTopping:Topping;

	public var pizzaToppings:FlxTypedGroup<FlxSprite>;

	var pId = 0;
	private var difficulty = 0;

	var balance:Int = 100;
	var balanceText:FlxText;
	var orderOne:PizzaOrder;
	var orderTwo:PizzaOrder;

	// Random Number generator
	public function randomRangeInt(min:Int, max:Int):Int
	{
		return Math.floor(Math.random() * (1 + max - min)) + min;
	}

	public function new(difficulty:Int)
	{
		super();
		this.difficulty = difficulty;
	}

	override public function create()
	{
		FlxG.debugger.visible = true;
		// play bg music and loop
		new AssetsUtil().playBGMusic(.32);

		// Adds the FlxMouseControl plugin - absolutely required
		FlxG.plugins.list.push(new FlxMouseControl());

		// Create a group of toppings
		toppings = new FlxTypedGroup<Topping>();
		createTopping(pepperoni, 0, 600);
		createTopping(mushroom, 100, 600);
		createTopping(yellow_cheese, 200, 600);
		createTopping(white_cheese, 300, 600);
		createTopping(dark_sauce, 400, 600);
		createTopping(light_sauce, 500, 600);
		add(toppings);

		// Create a group of sauces
		// sauces = new FlxTypedGroup<Sauce>();
		// createSauce(dark_sauce, 400, 600);
		// createSauce(light_sauce, 500, 600);
		// add(sauces);

		pizzaToppings = new FlxTypedGroup<FlxSprite>();
		// Create a pizza
		pizza = new Pizza(pizzaToppings);
		add(pizza);
		// place ingrdient spirte over the pizza
		add(pizzaToppings);

		// Create an oven
		oven = new Oven(200, 500);
		add(oven);
		// create trash sprite
		trash = new FlxSprite(0, 500, "assets/images/environment/trash.png");
		add(trash);

		super.create();

		// Delete all below this, Just a demo of how it works

		orderOne = newOrder(getMaxComplexity());
		trace("order 1: ");
		trace(orderOne.pSauce);
		trace(orderOne.pCheese);
		trace(orderOne.pTopping);
		trace(orderOne.ordArray);

		orderTwo = newOrder(getMaxComplexity());
		trace("order 2: ");
		trace(orderTwo.pSauce);
		trace(orderTwo.pCheese);
		trace(orderTwo.pTopping);
		trace(orderTwo.ordArray);

		var t = new flixel.text.FlxText(0, 0, 0, "", 64);
		var t2 = new flixel.text.FlxText(0, 0, 0, "", 64);
		var t3 = new flixel.text.FlxText(0, 0, 0, "", 12);
		var t4 = new flixel.text.FlxText(0, 0, 0, "", 12);

		t.screenCenter();
		add(t);
		t.visible = false;

		t2.screenCenter();
		add(t2);
		t2.visible = false;

		t3.screenCenter();
		add(t3);
		t3.visible = false;

		t4.screenCenter();
		add(t4);
		t4.visible = true;

		orderTwo.displayOrder(orderTwo, t, t2, t3, t4);

		balance -= 25 * difficulty;
		balanceText = new FlxText(0, 0);
		balanceText.text = "Your balance: $" + balance;
		balanceText.size = 64;
		balanceText.x = FlxG.width - balanceText.width;
		add(balanceText);

		var btn = new FlxButton(0, 0, "serve", onButtonClick);
		add(btn);
	}

	function onButtonClick()
	{
		{
			servePizza(pizza, orderTwo);
		}
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
		// sauces.forEach((sauce) ->
		// {
		// 	if (sauce.addSauce)
		// 	{
		// 		pizza.addTopping(sauce.value);
		// 		sauce.addSauce = false;
		// 	}
		// });

		// Only check for overlapping if the pizza is not being dragged
		if (pizza.isDragged == false)
		{
			FlxG.overlap(oven, pizza, cookPizza);
			FlxG.overlap(trash, pizza, resetPizza);
		}
		super.update(elapsed);
	}

	public function getMaxComplexity()
	{
		switch (difficulty)
		{
			case 0:
				return 3;
			case 1:
				return 4;
			case 2:
				return 5;
			default:
				return 3;
		}
	}

	public function newOrder(complexity:Int):PizzaOrder
	{
		pId += 1;
		// Init all flags
		var pSauce = "";

		var pCheese = "";
		var pTopping:Array<String> = [];
		var ordArray:Array<String> = [];

		while (complexity > 0)
		{ // create pizza loop
			// if complexity is higher then offering, set to max offerings
			if (complexity > 4)
				complexity = 4;

			var x = randomRangeInt(1, 6); // Decides on random topping

			if (x == 1 && pSauce == "")
			{ // random sauce
				complexity -= 1;
				pSauce = "light_sauce";
			}
			if (x == 2 && pCheese == "")
			{ // Pick Special Cheese
				complexity -= 1;
				pCheese = "yellow_cheese";
			}

			if (x > 3)
			{ // random Topping
				x = randomRangeInt(1, 2);
				if (x == 1 && pTopping.contains("mushroom") == false)
				{
					pTopping.push("mushroom");
					complexity -= 1;
				}
				if (x == 2 && pTopping.contains("pepperoni") == false)
				{
					pTopping.push("pepperoni");
					complexity -= 1;
				}
			}
		}
		// if no value set, set a defult
		if (pSauce == "")
			pSauce = "dark_sauce";

		if (pCheese == "")
			pCheese = "white_cheese";

		// pizzaorder made and returned
		var order = new PizzaOrder(pId, pSauce, pCheese, pTopping, ordArray);

		ordArray.push(pSauce);
		ordArray.push(pCheese);

		for (top in pTopping)
		{ // each topping
			ordArray.push(top);
		}

		return order;
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
		pizza.updateGraphic();
	}

	function servePizza(pizza:Pizza, order:PizzaOrder)
	{
		trace(pizza.toppings);
		var profit:Int = 0;

		if (pizza.cooked == false)
		{
			profit -= 10;
		}

		for (topp in pizza.toppings)
		{
			if (order.ordArray.contains(topp.getName()))
			{
				// pizza.toppings.remove(topp);
				profit += 5;

				trace("order ontains " + topp);

				order.ordArray.remove(topp.getName());
			}
			else
			{
				profit -= 5;
			}
		}

		trace(order.ordArray);

		if (order.ordArray.length > 0)
		{
			profit -= 5 * order.ordArray.length;
		}

		balance += profit;
		balanceText.text = "Your balance: $" + balance;
		trace(balance);

		resetPizza(trash, pizza);

		if (balance < 0)
		{
			endGame();
		}
	}

	function endGame()
	{
		trace("Endgame activated");
		var finalText = new FlxText(0, 0, FlxG.width * 0.8, "You are out of money! You served " + pId + " orders");
		finalText.autoSize = true;
		finalText.screenCenter();
		add(finalText);
	}
}
