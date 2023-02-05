package;

import flixel.FlxState;
import PizzaOrder;



class PlayState extends FlxState
{
	var pId = 0;
	

	//Random Number generator
	public function randomRangeInt(min:Int, max:Int):Int
	{
		return Math.floor(Math.random() * (1+ max-min)) + min;
	}

	override public function create()
	{
		super.create();

		

		//Delete all below this, Just a demo of how it works
		var pizzaOne = newOrder(5);
		trace(pizzaOne.pId);
		trace(pizzaOne.pSauce);
		trace(pizzaOne.pBake);
		trace(pizzaOne.pTopping);

		var pizzaTwo = newOrder(3);
		trace(pizzaTwo.pId);
		trace(pizzaTwo.pSauce);
		trace(pizzaTwo.pBake);
		trace(pizzaTwo.pTopping);
	
		var t = new flixel.text.FlxText(0,0,0,"",64);
		var t2 = new flixel.text.FlxText(0,0,0,"",64);
		var t3 = new flixel.text.FlxText(0,0,0,"",12);

		t.screenCenter();
			add(t);
			t.visible = false;

			t2.screenCenter();
			add(t2);
			t2.visible = false;

			t3.screenCenter();
			add(t3);
			t3.visible = true;


		pizzaTwo.displayOrder(pizzaTwo,t,t2,t3);



	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public function newOrder(complexity:Int):PizzaOrder{
		pId +=1;
		//Init all flags
		var pSauce = "";
		var pBake = "";
		var pTopping:Array<String> = [];

		while (complexity> 0 ){//create pizza loop
			//if complexity is higher then offering, set to max offerings
			if(complexity >5 )
				complexity = 5;

			var x = randomRangeInt(1,8); //Decides on random topping
			
			if (x == 1 && pSauce == ""){//random sauce
				complexity -=1;
				x = randomRangeInt(1,2);
				if(x==1)
					pSauce = "Light";
				else 
					pSauce = "Extra";

			}
			if(x == 2 && pBake =="" ){//Welldone Bake
				complexity -=1;
				pBake = "Well Done";
			}
			if(x>2){//random Topping
				x = randomRangeInt(1,3);
				if(x == 1 && pTopping.contains("Topping1") == false){
					pTopping.push("Topping1");
					complexity -=1;
				}
				if(x == 2 && pTopping.contains("Topping2")== false){
					pTopping.push("Topping2");
					complexity -=1;
				}
				if(x == 3 && pTopping.contains("Topping3")== false){
					pTopping.push("Topping3");
					complexity -=1;
				}


			}
		}
		//if no value set, set a defult 
		if(pSauce == "")
			pSauce = "Regular";
		if(pBake == "")
			pBake = "Regular";

		//pizzaorder made and returned
		var pizza = new PizzaOrder(pId,pSauce,pBake, pTopping);
		return pizza;
	}

	
	
}

