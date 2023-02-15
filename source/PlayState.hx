package;

import Assets.AssetsUtil;
import Assets.ToppingSprite;
import PizzaOrder;
import Topping.ToppingEnum;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxExtendedSprite;
import flixel.addons.plugin.FlxMouseControl;
import flixel.addons.ui.FlxButtonPlus;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxColor;
import haxe.Timer;
import lime.app.Event;

class PlayState extends FlxState
{
	var toppings:FlxTypedGroup<Topping>;
	var pizza:Pizza;
	var oven:Oven;
	var trash:FlxExtendedSprite;

	public var draggedTopping:Topping;

	var difIncrease:Int = 0;
	var speed:Int = 0;
	var counter:Timer;
	var patienceEvent:Event<Void->Void>;
	var customers:Array<Customer>;

	private var difficulty = 0;

	var balance:Int = 100;
	var balanceText:FlxText;
	var currentOrder:PizzaOrder;

	var pizzasServed:Int = 0;
	var tickets:Array<Ticket> = new Array<Ticket>();

	// sounds
	var soundPlace:flixel.system.FlxSound;
	var soundTimer:flixel.system.FlxSound;
	var soundFire:flixel.system.FlxSound;
	var soundScore:flixel.system.FlxSound;
	var soundTicket:flixel.system.FlxSound;

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
		// var backgroundSprite = new FlxGraphic("assets/images/environment/bg.png");
		var background = new FlxBackdrop("assets/images/environment/bg.jpg", FlxAxes.XY);
		background.scale.set(0.25, 0.25);
		add(background);

		FlxG.debugger.visible = false;
		// play bg music and loop
		// sounds
		FlxG.sound.playMusic("assets/music/background.ogg");

		soundPlace = FlxG.sound.load("assets/sounds/place.wav");
		soundFire = FlxG.sound.load("assets/sounds/fire.wav");
		soundTimer = FlxG.sound.load("assets/sounds/timer.wav");
		soundScore = FlxG.sound.load("assets/sounds/score.wav");
		soundTicket = FlxG.sound.load("assets/sounds/ticket.wav");

		// Adds the FlxMouseControl plugin - absolutely required
		FlxG.plugins.list.push(new FlxMouseControl());

		// Create a group of toppings
		toppings = new FlxTypedGroup<Topping>();
		createTopping(mushroom, 0);
		createTopping(pepperoni, 200);
		createTopping(yellow_cheese, 400);
		createTopping(white_cheese, 600);
		createTopping(dark_sauce, 800);
		createTopping(light_sauce, 1000);
		add(toppings);

		// Create a pizza
		pizza = new Pizza();
		add(pizza);

		// Create an oven
		oven = new Oven(FlxG.width - 200, FlxG.height / 2);
		add(oven);

		// create trash sprite
		trash = new FlxExtendedSprite(FlxG.width - 200, FlxG.height - 200, "assets/images/environment/trash.png");
		trash.scale.set(4, 4);
		trash.updateHitbox();
		trash.enableMouseClicks(true);
		trash.mousePressedCallback = (sprite, _, _) ->
		{
			resetPizza(sprite, pizza);
		}
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
			resetTickets();
			customers.shift();
			displayTicket();
		});

		customers.push(new Customer(difficulty, patienceEvent));
		// resetTickets();
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
			if (difIncrease % 20 == 0 && speed < 5)
			{
				speed++;
				trace("Speed increased: " + speed);
			}
			// Add new customer
			if (difIncrease % (10 - speed) == 0 && customers.length < 5)
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
				var overlap = FlxG.overlap(pizza, tickets[i].ticket);
				if (overlap)
				{
					trace("Pizza served to customer " + tickets.length);
					trace("Customer order: " + tickets);
					servePizza(pizza, customers[i].order);
					customers.splice(i, 1);
					resetTickets();
					tickets.splice(i, 1);
					displayTicket();
					break;
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
		tickets = [];
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
			soundTicket.play();
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
			soundPlace.play();
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
	function createTopping(topping:ToppingEnum, x:Float)
	{
		toppings.add(new Topping(topping, x));
	}

	/**
		Moves the pizza and makes it invisible, then calls the cookPizza function
			from the Oven class to cook the pizza
	**/
	function cookPizza(oven:Oven, pizza:Pizza)
	{
		// We must immediately move the pizza to its finished position and make it invisible
		// Some how the overlap is still triggered 4 times before this runs.
		pizza.x = FlxG.width / 2 - pizza.width / 2;
		pizza.visible = false;
		oven.cookPizza(pizza);
		soundFire.play();
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
		// keep track of served pizzas
		pizzasServed++;

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
				// pizza.toppings.remove(topp);
				profit += 5;

				order.ordArray.remove(topp.getName());
			}
			else
			{
				// decrease profit because of wasted ingredient
				profit -= 5;
			}
		}

		// deduct if missing toppings
		if (order.ordArray.length > 0)
		{
			profit -= 5 * order.ordArray.length;
		}

		balance += profit;
		balanceText.text = "Your balance: $" + balance;
		soundScore.play();
		pizza.resetPizza();

		if (balance < 0)
		{
			endGame();
		}
	}

	function endGame()
	{
		trace("Endgame activated");
		var finalText = new FlxText(0, 0, FlxG.width * 0.8, "You are out of money! You served " + pizzasServed + " orders", 64);
		pizza.kill();
		counter.stop();

		finalText.autoSize = true;
		finalText.screenCenter();
		finalText.color = FlxColor.RED;
		add(finalText);

		var menuButton = new FlxButtonPlus(0, 0, goToMenuState, "Back to main menu");
		menuButton.setSize(2.0, 2.0);
		menuButton.screenCenter();
		menuButton.y += finalText.height;
		add(menuButton);
	}

	function goToMenuState()
	{
		FlxG.switchState(new MenuState(pizzasServed));
	}
}
