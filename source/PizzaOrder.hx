class PizzaOrder{
	public    var pId:Int;
	public	var pSauce:String;
	public	var pBake:String;
	public	var pTopping:Array<String>;

		public function new(pId, pSauce,pBake, pTopping){
			this.pId = pId;
			this.pSauce = pSauce;
			this.pBake = pBake;
			this.pTopping = pTopping;
		}

		public function displayOrder(pizzaOrder:PizzaOrder, textSauce:flixel.text.FlxText, textBake:flixel.text.FlxText, textTopping:flixel.text.FlxText ){
			//set the text values of text boxes too pizzaOrder ifno
			textSauce.text = pizzaOrder.pSauce;
			textBake.text = pizzaOrder.pBake;

			//Convert array of strings into one string with spaces
			var sTopping = "";
			for (top in pizzaOrder.pTopping){
				sTopping = sTopping + ", " + top;

			}
			textTopping.text = sTopping; 
		}
		public function validateOrder(pId){

		}

	}