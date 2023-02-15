package;

import Assets.AssetsUtil;
import Assets.ToppingSprite;
import PizzaOrder;
import Topping.ToppingEnum;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.plugin.FlxMouseControl;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import haxe.Timer;
import lime.app.Event;

class PlayState extends FlxState
{
	var toppings:FlxTypedGroup<Topping>;
	var pizza:Pizza;
	var oven:Oven;
	var trash:FlxSprite;

	public var draggedTopping:Topping;
	public var pizzaToppings:FlxTypedGroup<ToppingSprite>;

	var difIncrease:Int = 0;
	var speed:Int = 0;
	var counter:Timer;
	var patienceEvent:Event<Void->Void>;
	var customers:Array<Customer>;

	var pId = 0;
	private var difficulty = 0;

	var balance:Int = 100;
	var balanceText:FlxText;

	var tickets:Array<Ticket> = new Array<Ticket>();

	// var ticket:FlxSprite;
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
		super.create();
		FlxG.debugger.visible = true;
		// play bg music and loop
		new AssetsUtil().playBGMusic(.01);

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

		pizzaToppings = new FlxTypedGroup<ToppingSprite>();
		// Create a pizza
		pizza = new Pizza(pizzaToppings);
		add(pizza);

		// Create an oven
		oven = new Oven(200, 500);
		add(oven);
		// create trash sprite
		trash = new FlxSprite(0, 500, "assets/images/environment/trash.png");
		add(trash);

		// display first ticket

		// Show balance (score)
		balance -= 25 * difficulty;
		balanceText = new FlxText(0, 0);
		balanceText.text = "Your balance: $" + balance;
		balanceText.size = 64;
		balanceText.x = FlxG.width - balanceText.width;
		add(balanceText);

		// Customer setup
		customers = [];
		patienceEvent = new Event<Void->Void>();
		patienceEvent.add(function()
		{
			customers.shift();
			resetTickets();
			tickets.shift();
			displayTicket();
		});

		customers.push(new Customer(difficulty, patienceEvent));
		resetTickets();
		displayTicket();

		// time of playthrough counter
		counter = new haxe.Timer(1000);
		counter.run = function()
		{
			difIncrease++;
			if (difficulty < 2 && difIncrease % 30 == 0)
			{
				difficulty++;
				trace("Difficulty increased: " + difficulty);
			}
			// Ramping speed
			if (difIncrease % 20 == 0 && speed < 10)
			{
				speed++;
				trace("Speed increased: " + speed);
			}
			// Add new customer
			if (difIncrease % (15 - speed) == 0)
			{
				customers.push(new Customer(difficulty, patienceEvent));
				trace("New customer added: " + customers.length);
				resetTickets();
				displayTicket();
			}
		}
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

		// Only check for overlapping if the pizza is not being dragged
		if (pizza.isDragged == false)
		{
			FlxG.overlap(oven, pizza, cookPizza);
			FlxG.overlap(trash, pizza, resetPizza);
			for (i in 0...tickets.length)
			{
				try
				{
					var overlap = FlxG.overlap(pizza, tickets[i].ticket);
					if (overlap)
					{
						servePizza(pizza, customers[i].order);
						customers.splice(i, 1);
						resetTickets();
						tickets.splice(i, 1);
						displayTicket();
					}
				}
				catch (e:Dynamic)
				{
					continue;
				}
			}
		}
		super.update(elapsed);
	}

	function resetTickets()
	{
		// Reset the tickets
		for (i in 0...tickets.length)
		{
			var ticket = tickets[i];
			remove(ticket.ticket);
			remove(ticket.tHead);
			remove(ticket.t1);
			remove(ticket.t2);
			remove(ticket.t3);
			remove(ticket.t4);
		}
	}

	function displayTicket()
	{
		var xStart = 0;
		for (i in 0...customers.length)
		{
			var ticket = new Ticket(xStart);
			tickets.push(ticket);

			add(ticket.ticket);
			add(ticket.tHead);
			add(ticket.t1);
			add(ticket.t2);
			add(ticket.t3);
			add(ticket.t4);

			customers[i].order.displayOrder(customers[i].order, ticket.t1, ticket.t2, ticket.t3, ticket.t4);

			xStart += Std.int(ticket.ticket.width) + 10;
		}
	}

	public static function getMaxComplexity(difficulty:Int)
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
		pizza.resetPizza();
	}

	function servePizza(pizza:Pizza, order:PizzaOrder)
	{
		// variable that will track our profit or loss
		var profit:Int = 0;

		if (pizza.cooked == false)
		{
			trace('Uncooked');
			profit -= 10;
		}

		// compare created pizza and order
		for (topp in pizza.toppings)
		{
			if (order.ordArray.contains(topp.getName()))
			{
				trace('correct: ' + topp.getName());
				profit += 5;

				order.ordArray.remove(topp.getName());
			}
			else
			{
				trace('incorrect: ' + topp.getName());
				profit -= 5;
			}
		}

		// deduct if missing toppings
		if (order.ordArray.length > 0)
		{
			trace('missing: ' + order.ordArray.length);
			profit -= 5 * order.ordArray.length;
		}

		balance += profit;
		balanceText.text = "Your balance: $" + balance;

		pizza.resetPizza();

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
