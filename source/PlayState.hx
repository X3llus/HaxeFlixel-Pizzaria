package;

import PizzaOrder;
import flixel.FlxState;

class PlayState extends FlxState
{
	var pId = 0;
	private var difficulty = 0;

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

		//Delete all below this, Just a demo of how it works
		var pizzaOne = newOrder(5);
		// trace(pizzaOne.pId);
		// trace(pizzaOne.pSauce);
		// trace(pizzaOne.pBake);
		// trace(pizzaOne.pTopping);

		var pizzaTwo = newOrder(2);
		trace(pizzaTwo.pId);
		trace(pizzaTwo.pSauce);
		trace(pizzaTwo.pCheese);
		trace(pizzaTwo.pTopping);
		trace(pizzaTwo.ordArray);
	
		var t = new flixel.text.FlxText(0,0,0,"",64);
		var t2 = new flixel.text.FlxText(0,0,0,"",64);
		var t3 = new flixel.text.FlxText(0,0,0,"",12);
		var t4 = new flixel.text.FlxText(0,0,0,"",12);

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


		pizzaTwo.displayOrder(pizzaTwo,t,t2,t3,t4);
	}

	override public function update(elapsed:Float)
	{
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

	public function newOrder(complexity:Int):PizzaOrder{
		pId +=1;
		//Init all flags
		var pSauce = "";
		
		var pCheese = "";
		var pTopping:Array<String> = [];
		var ordArray:Array<String> = [];

		while (complexity> 0 ){//create pizza loop
			//if complexity is higher then offering, set to max offerings
			if(complexity >4 )
				complexity = 4;

			var x = randomRangeInt(1,6); //Decides on random topping
			
			if (x == 1 && pSauce == ""){//random sauce
				complexity -=1;
				pSauce = "light_sauce";
				

			}
			if(x == 2 && pCheese =="" ){//Pick Special Cheese
				complexity -=1;
				pCheese = "yellow_Cheese";
			}
			

			if(x>3){//random Topping
				x = randomRangeInt(1,2);
				if(x == 1 && pTopping.contains("mushroom") == false){
					pTopping.push("mushroom");
					complexity -=1;
				}
				if(x == 2 && pTopping.contains("pepperoni")== false){
					pTopping.push("pepperoni");
					complexity -=1;
				}
				

			}
		}
		//if no value set, set a defult 
		if(pSauce == "")
			pSauce = "dark_sauce";
		
		if(pCheese == "")
			pCheese = "White_Cheese";

		//pizzaorder made and returned
		var pizza = new PizzaOrder(pId,pSauce, pCheese, pTopping, ordArray);

		ordArray.push(pSauce);
		ordArray.push(pCheese);

		for (top in pTopping){//each topping
				ordArray.push(top);
			}
	


		return pizza;
	}
}
