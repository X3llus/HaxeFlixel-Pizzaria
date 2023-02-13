class PizzaOrder{
	public  var pId:Int;
	public	var pSauce:String;
	public  var pCheese:String;
	public	var pTopping:Array<String>;
	public	var ordArray:Array<String>;

		public function new(pId, pSauce, pCheese, pTopping, ordArray){
			this.pId = pId;
			this.pSauce = pSauce;
			this.pCheese = pCheese;
			this.pTopping = pTopping;
			this.ordArray = ordArray;
		}

		public function displayOrder(pizzaOrder:PizzaOrder, textSauce:flixel.text.FlxText, textCheese:flixel.text.FlxText, textTopping:flixel.text.FlxText, textOrd:flixel.text.FlxText ){
			//set the text values of text boxes too pizzaOrder ifno
			textSauce.text = pizzaOrder.pSauce;
			textCheese.text = pizzaOrder.pCheese;
			//Convert array of strings into one string with spaces
			var sTopping = "";
			for (top in pizzaOrder.pTopping){
				sTopping = sTopping + ", " + top;

			}
			textTopping.text = sTopping; 

			//Convert array of strings into one string with spaces
			var sOrder = "";
			for (ord in pizzaOrder.ordArray){
				sOrder = sOrder + ", " + ord;

			}
			textOrd.text = sOrder;
		}
		public function validateOrder(pId){

		}

	}
