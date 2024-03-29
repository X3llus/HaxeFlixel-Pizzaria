package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.ui.FlxButtonPlus;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
	private var title:FlxText;
	private var rules:FlxText;
	private var score:FlxText;
	private var difficulty:FlxText;
	private var complexity:FlxText;
	private var background:FlxSprite;
	private var decreaseDifficulty:FlxButton;
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

		var background = new FlxBackdrop("assets/images/environment/bg.jpg", FlxAxes.XY);
		background.scale.set(0.25, 0.25);
		add(background);

		// Set game title
		title = new FlxText(50, 0, 0, "Welcome to HaxeFlixel Pizzaria!", 30);
		title.alignment = CENTER;
		title.screenCenter(X);
		title.y = 30;
		title.replaceColor(FlxColor.WHITE, FlxColor.BLACK);
		add(title);

		// Display
		score = new FlxText(50, 0, 0, "Score: " + totalPoints, 18);
		score.alignment = CENTER;
		score.screenCenter(X);
		score.y = title.y + 30;

		// Rules of the game
		rules = new FlxText(50, 0, FlxG.width * 0.8,
			"  Basic Rules: As described in the concept, the basic rules of the game are simple. The player will receive orders with specific pizzas,\nand it is your job to accurately replicate the order, within the customer's patience. Your score will be impacted by the accuracy of your pizza,\nand if you cant complete a customer's order before there paitence runs out, you will lose score. The control scheme for the game revolves around\nmouse click and mouse drag interactions. Instructions for creating your pizza are detailed below.
			    Creating Your Pizza:

				Pizza Dough: Pizza dough will spawn on the user's screen, and be the base of your pizza. Once you finish and submit your pizza, a new pizza dough will appear.
			
				Adding Ingredients: To add an ingredient to your pizza, simply locate the appropriate ingredient on your UI, and drag it onto your pizza dough, you will then 
				notice it appear on your pizza.
			
				Following your order: As previously stated, it is important that you follow the customer's order when creating your pizzas. Adding extra ingredients, or\nfailing to include some required ingredients will impact your score and performance. It is important to work on the order that was first in the queue, as\nworking on other orders will not provide you with the correct score (You will be handing customers 1 customer 3’s order if you do not follow this rule).\nIt is also important to note that as a part of your challenge, you cannot undo any ingredients or start over, so be careful with what you place on your pizza.
				More Rules and detials found at: https://docs.google.com/document/d/1aPKpBNn7B7GIKRlpjAQMcnFjv93RzyuX0riykhti_Y8/edit?usp=viewing OR within project documents",
			15);

		rules.alignment = CENTER;
		rules.screenCenter(X);
		rules.y = score.y + 100;
		rules.replaceColor(FlxColor.WHITE, FlxColor.BLACK);
		add(rules);

		// Initial Difficulty
		difficulty = new FlxText(50, 0, 130, "Easy", 20);
		difficulty.alignment = CENTER;
		difficulty.screenCenter(X);
		difficulty.y = rules.height + 200;
		add(difficulty);

		// Decrease Difficulty button
		decreaseDifficulty = new FlxButton(0, 0, "v", clickEasier);
		decreaseDifficulty.x = (difficulty.x - (150 - difficulty.width) - decreaseDifficulty.width);
		decreaseDifficulty.y = (difficulty.y + 5);
		add(decreaseDifficulty);

		// Increase Difficulty button
		increaseDifficulty = new FlxButton(0, 0, "^", clickHarder);
		increaseDifficulty.x = (difficulty.x + 150);
		increaseDifficulty.y = (difficulty.y + 5);
		add(increaseDifficulty);

		// Increase Difficulty button
		// difficulty = new FlxButtonPlus(0, 0, clickHarder, ">  Easy  <", 160, 30);
		// difficulty.screenCenter(X);
		// difficulty.y = rules.height + 200;
		// difficulty.textNormal.setFormat(null, 20, 0xffffff, "center", OUTLINE, FlxColor.BLACK);
		// difficulty.textHighlight.setFormat(null, 20, 0xffffff, "center", OUTLINE, FlxColor.BLACK);
		// difficulty.textHighlight.text = "> > > > >";
		// difficulty.updateActiveButtonColors([0x7d7c7c, 0xb0b0b0]);
		// add(difficulty);

		complexity = new FlxText(50, 0, 0, "Maximum toppings per pizza: 3", 16);
		complexity.alignment = CENTER;
		complexity.screenCenter(X);
		complexity.y = difficulty.y + 40;
		add(complexity);

		// Centered Play button to start/restart the game
		play = new FlxButton(0, 0, "Play", clickPlay);
		play.screenCenter(X);
		play.scale.set(2, 2);
		// play.textNormal.setFormat(null, 26, 0xffffff, "center", OUTLINE, FlxColor.BLACK);
		// play.textHighlight.setFormat(null, 26, 0xffffff, "center", OUTLINE, FlxColor.BLACK);
		play.y = difficulty.y + 100;
		add(play);

		super.create();
	}

	private function clickEasier()
	{
		switch (currentDifficulty)
		{
			case 0:
				currentDifficulty=2;
				difficulty.text = "Hard";
				complexity.text = "Maximum toppings per pizza: 5";
			case 1:
				currentDifficulty--;
				difficulty.text = "Easy";
				complexity.text = "Maximum toppings per pizza: 3";
			case 2:
				currentDifficulty--;
				difficulty.text = "Normal";
				complexity.text = "Maximum toppings per pizza: 4";
			default:
				currentDifficulty = 0;
				difficulty.text = "Easy";
				complexity.text = "Maximum toppings per pizza: 3";
		}
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
