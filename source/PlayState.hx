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
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.Timer;
import lime.app.Event;

class PlayState extends FlxState
{
	var toppings:FlxTypedGroup<Topping>;
	var sauces:FlxTypedGroup<Sauce>;
	var pizza:Pizza;
	var oven:Oven;
	var trash:FlxSprite;

	var difIncrease:Int;
	var counter:Timer;

	public var draggedTopping:Topping;

	public var pizzaToppings:FlxTypedGroup<FlxSprite>;

	var patienceEvent:Event<Void->Void>;
	var customers:Array<Customer>;
  
	var pId = 0;
	var difficulty:Int;

	public function new(difficulty:Int)
	{
		super();
		this.difficulty = difficulty;
	}

	override public function create()
	{
		super.create();
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

		customers = [];
		patienceEvent = new Event<Void->Void>();
		patienceEvent.add(function () {
			customers.shift();
			// Replace order with next customers order and add to the failure count
		});
		// TODO: create timer to start adding customers

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

		//Delete all below this, Just a demo of how it works
		var pizzaTwo = PizzaOrder.newOrder(2);
	
		trace(pizzaTwo.pId);
        trace(pizzaTwo.pSauce);
        trace(pizzaTwo.pCheese);
        trace(pizzaTwo.pTopping);
        trace(pizzaTwo.ordArray);


        var ticket = new FlxSprite(-175,-175);
        ticket.loadGraphic("assets/images/environment/notepad.jpg");
        ticket.scale.set( 0.30,0.30);
        add(ticket);

        var tHead = new flixel.text.FlxText(39,100,0,"Current Order",12);
        var t = new flixel.text.FlxText(39,135,0,"",12);
        var t2 = new flixel.text.FlxText(39,165,0,"",12);
        var t3 = new flixel.text.FlxText(39,195,0,"",9);
        var t4 = new flixel.text.FlxText(37,160,"",7);
        //t.FlxColor =  flixel.util.FlxColor.BLACK;
        tHead.color = FlxColor.BLACK;
        t.color = FlxColor.BLACK;
        t2.color = FlxColor.BLACK;
        t3.color = FlxColor.BLACK;
        t4.color = FlxColor.BLACK;
		add(tHead);
		tHead.visible = true;
		add(t);
		t.visible = true;
		add(t2);
		t2.visible = true;
		add(t3);
		t3.visible = true;
		add(t4);
		t4.visible = false;

		pizzaTwo.displayOrder(pizzaTwo,t,t2,t3,t4);
	}


	override public function update(elapsed:Float)
	{
	
		// TODO: check if current order is null, if so, get next customers order.

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
}