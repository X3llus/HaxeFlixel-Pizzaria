package;
using StringTools;

class PizzaOrder{
	public var pId:Int;
	public var pSauce:String;
	public var pCheese:String;
	public var pTopping:Array<String>;
	public var ordArray:Array<String>;

	static var pIdCounter = 0;

	public function new(pId, pSauce, pCheese, pTopping, ordArray){
		this.pId = pId;
		this.pSauce = pSauce;
		this.pCheese = pCheese;
		this.pTopping = pTopping;
		this.ordArray = ordArray;
	}

	public static function newOrder(complexity:Int):PizzaOrder{
		function randomRangeInt(min:Int, max:Int):Int
		{
			return Math.floor(Math.random() * (1 + max - min)) + min;
		}

		pIdCounter +=1;
		//Init all flags
		var pSauce = "";
		
		var pCheese = "";
		var pTopping:Array<String> = [];
		var ordArray:Array<String> = [];

		while (complexity > 0){//create pizza loop
			//if complexity is higher then offering, set to max offerings
			if (complexity > 4)
				complexity = 4;

			//Decides on random topping
			var x = randomRangeInt(1, 6);
			
			if (x == 1 && pSauce == ""){
				//random sauce
				complexity -=1;
				pSauce = "light_sauce";
			}
			if(x == 2 && pCheese =="" ){
				//Pick Special Cheese
				complexity -=1;
				pCheese = "yellow_Cheese";
			}
			

			if(x>3){//random Topping
				x = randomRangeInt(1, 2);
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
		var pizza = new PizzaOrder(pIdCounter,pSauce, pCheese, pTopping, ordArray);

		ordArray.push(pSauce);
		ordArray.push(pCheese);

		for (top in pTopping){//each topping
				ordArray.push(top);
			}
	


		return pizza;
	}


	public function displayOrder(pizzaOrder:PizzaOrder, textSauce:flixel.text.FlxText, textCheese:flixel.text.FlxText, textTopping:flixel.text.FlxText, textOrd:flixel.text.FlxText){
		//set the text values of text boxes too pizzaOrder ifno

		pizzaOrder.pSauce = pSauce.replace("_", " ");
		pizzaOrder.pCheese = pCheese.replace("_", " ");

		textSauce.text = pizzaOrder.pSauce;
		textCheese.text = pizzaOrder.pCheese;
		//Convert array of strings into one string with spaces
		var sTopping = "";
		for (top in pizzaOrder.pTopping){
			sTopping = sTopping + " " + top;

		}
		textTopping.text = sTopping; 

		//Convert array of strings into one string with spaces
		var sOrder = "";
		for (ord in pizzaOrder.ordArray){
			sOrder = sOrder + " " + ord;

		}
		textOrd.text = sOrder;
	}

	public function validateOrder(pId){

	}

}
