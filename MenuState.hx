package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
	private var title:FlxText;
	private var rules:FlxText;
	private var score:FlxText;
	private var difficulty:FlxText;
	private var complexity:FlxText;
	private var background:FlxSprite;
	private var increaseDifficulty:FlxButton;
	private var play:FlxButton;
	private var totalPoints = 0;
	private var currentDifficulty = 0;

	// Constructor called after the game ends
	// Total score from the previous run is passed as an argument
	public function new(totalPoints:Int)
	{
		super();
		this.totalPoints = totalPoints;
	}

	// Function to create the menu state
	override function create()
	{
		// Set Background Sprite (uncomment when image is found)
		/*background = new FlxSprite();
				background.loadGraphic(AssetPaths.backgroundPizza__png, false, image-width, image-height, true); 
			add(background); */

		// Set game title
		title = new FlxText(50, 0, 0, "Welcome to HaxeFlixel Pizzaria!", 30);
		title.alignment = CENTER;
		title.screenCenter(X);
		title.y = 30;
		add(title);

		// Display
		score = new FlxText(50, 0, 0, "Score: " + totalPoints, 18);
		score.alignment = CENTER;
		score.screenCenter(X);
		score.y = title.y + 30;

		// Rules of the game
		rules = new FlxText(50, 0, FlxG.width*0.8, "  Basic Rules: As described in the concept, the basic rules of the game are simple. The player will receive orders with specific pizzas, 
			                             and it is your job to accurately replicate the order, within the customer's patience. Your score will be impacted by the accuracy of your pizza, 
			                             and if you cant complete a customer's order before there paitence runs out, you will lose score. The control scheme for the game revolves around 
			                             mouse click and mouse drag interactions. Instructions for creating your pizza are detailed below.

			               Creating Your Pizza:

	     							     Pizza Dough: Pizza dough will spawn on the user's screen, and be the base of your pizza. Once you finish and submit your pizza, a new pizza dough will appear.
									   
									     Adding Ingredients: To add an ingredient to your pizza, simply locate the appropriate ingredient on your UI, and drag it onto your pizza dough, you will then 
									     notice it appear on your pizza.
									   
									     Following your order: As previously stated, it is important that you follow the customer's order when creating your pizzas. Adding extra ingredients, or 
									     failing to include some required ingredients will impact your score and performance. It is important to work on the order that was first in the queue, as 
									     working on other orders will not provide you with the correct score (You will be handing customers 1 customer 3’s order if you do not follow this rule). 
									     It is also important to note that as a part of your challenge, you cannot undo any ingredients or start over, so be careful with what you place on your pizza.

									     More Rules and detials found at: https://docs.google.com/document/d/1aPKpBNn7B7GIKRlpjAQMcnFjv93RzyuX0riykhti_Y8/edit?usp=viewing OR within project documents", 15);
		rules.alignment = CENTER;
		rules.screenCenter(X);
		rules.y = score.y + 100;
		add(rules);

		// Initial Difficulty
		difficulty = new FlxText(50, 0, 130, "Easy", 20);
		difficulty.alignment = CENTER;
		difficulty.screenCenter(X);
		difficulty.y = rules.y + 450;
		add(difficulty);

		// Increase Difficulty button
		increaseDifficulty = new FlxButton(0, 0, "^", clickHarder);
		increaseDifficulty.x = (difficulty.x + 130);
		increaseDifficulty.y = (difficulty.y + 5);
		add(increaseDifficulty);

		complexity = new FlxText(50, 0, 0, "Maximum toppings per pizza: 3", 10);
		complexity.alignment = CENTER;
		complexity.screenCenter(X);
		complexity.y = difficulty.y + 30;
		add(complexity);

		// Centered Play button to start/restart the game
		play = new FlxButton(0, 0, "Play", clickPlay);
		play.x = (FlxG.width / 2) - (play.width / 2);
		play.y = (FlxG.height / 2+225);
		add(play);

		super.create();
	}

	private function clickHarder()
	{
		switch (currentDifficulty)
		{
			case 0:
				currentDifficulty++;
				difficulty.text = "Normal";
				complexity.text = "Maximum toppings per pizza: 4";
			case 1:
				currentDifficulty++;
				difficulty.text = "Hard";
				complexity.text = "Maximum toppings per pizza: 5";
			case 2:
				currentDifficulty = 0;
				difficulty.text = "Easy";
				complexity.text = "Maximum toppings per pizza: 3";
			default:
				currentDifficulty = 0;
				difficulty.text = "Easy";
				complexity.text = "Maximum toppings per pizza: 3";
		}
	}

	// Called when the play button is pressed, switches to PlayState
	private function clickPlay()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () ->
		{
			FlxG.switchState(new PlayState(currentDifficulty));
		});
	}
}
