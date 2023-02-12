package;

import flixel.FlxG;
import flixel.addons.display.FlxExtendedSprite;
import flixel.addons.plugin.FlxMouseControl;
import flixel.graphics.frames.FlxAtlasFrames;

/**
	How I imagine the topping area will look
	 _______________
	|____|____|____|
	|____|____|____|
**/
class Topping extends FlxExtendedSprite
{
	public var spritesheet:FlxAtlasFrames;
	public var draggableTopping:Topping;

	public var value: ToppingEnum;

	/**
		@param value ToppingEnum - the type of the topping i.e pepperoni, mozarella, skittles, etc.
		@param spritesheet  FlxAtlasFrames - spritesheet containing an image for topping while:
		 	it's in the container
			it's being dragged
		 	it's on the pizza
	 */
	public function new(value:String, spritesheet:FlxAtlasFrames, dragged = false)
	{
		super();
		this.value = value;
		this.spritesheet = spritesheet;
		frames = this.spritesheet;
	}

	#if FLX_MOUSE
	/**
	 * Called by FlxMouseControl when this sprite is clicked. Should not usually be called directly.
	 */
	override public function mousePressedHandler():Void
	{
		isPressed = true;

		if (clickable == true && _clickOnRelease == false)
		{
			// Initialize the draggable topping and set the proper frame.
			draggableTopping = new Topping(this.value, this.spritesheet, true);

			draggableTopping.frame = draggableTopping.frames.getByIndex(1);
			draggableTopping.enableMouseDrag();
			draggableTopping.isDragged = true;
			draggableTopping._dragOffsetX = 30;
			draggableTopping._dragOffsetY = 30;

			// Add the topping to the display
			FlxG.state.add(draggableTopping);
		}

		if (mousePressedCallback != null)
		{
			mousePressedCallback(this, mouseX, mouseY);
		}
	}

	/**
	 * Called by FlxMouseControl when this sprite is released from a click. Should not usually be called directly.
	 */
	override public function mouseReleasedHandler():Void
	{
		isPressed = false;
		// Stop dragging the draggable topping
		if (draggableTopping.isDragged == true)
		{
			draggableTopping.stopDrag();
		}
		

		if (mouseReleasedCallback != null)
		{
			mouseReleasedCallback(this, mouseX, mouseY);
		}
	}
	#end

	/**
	 * Core update loop
	 */
	override public function update(elapsed:Float):Void
	{
		#if FLX_MOUSE
		if (draggable == true && isDragged == true)
		{
			updateDrag();
		}

		if (isPressed == false && FlxG.mouse.justPressed)
		{
			checkForClick();
		}
		#end

		super.update(elapsed);
	}
}

 /**
  * Available toppings for the pizza
  */
 enum ToppingEnum {
	pepperoni;
	mushroom;
	yellow_cheese;
	white_cheese;
	light_sauce;
	dark_sauce;
	cooked;
	raw;
}