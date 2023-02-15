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
	public var value:ToppingEnum;

	/**
		@param value ToppingEnum - the type of the topping i.e pepperoni, mozarella, skittles, etc.
		@param x Int - the x coordinate of the topping
		@param y Int - the y coordinate of the topping
	 */
	public function new(value:ToppingEnum, x:Float, y:Float)
	{
		super();
		this.value = value;
		this.x = x;
		this.y = y;
		this.loadGraphic("assets/images/ingredients/" + value + ".png");
		this.draggableTopping = null;
		this.enableMouseClicks(false);
	}

	#if FLX_MOUSE
	/**
	 * Called by FlxMouseControl when this sprite is clicked. Should not usually be called directly.
	 */
	override public function mousePressedHandler():Void
	{
		isPressed = true;
		trace(isPressed);

		if (clickable == true && _clickOnRelease == false)
		{
			// First check if the sprite is already created but dead
			if (draggableTopping != null && draggableTopping.alive == false)
			{
				draggableTopping.reset(this.x, this.y);
			}
			else
			{
				// Initialize the draggable topping and set the dragging image.
				draggableTopping = new Topping(this.value, this.x, this.y);
				draggableTopping.loadGraphic("assets/images/large/" + this.value + "_clump_large.png");
				draggableTopping.scale.set(0.4, 0.4);
				draggableTopping.updateHitbox();
				// Add the topping to the display
				FlxG.state.add(draggableTopping);
			}
			draggableTopping.enableMouseDrag();
			draggableTopping.isDragged = true;
			draggableTopping._dragOffsetX = 180;
			draggableTopping._dragOffsetY = 180;
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
		trace(isPressed);
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
}

/**
 * Available toppings for the pizza
 */
enum ToppingEnum
{
	pepperoni;
	mushroom;
	yellow_cheese;
	white_cheese;
	light_sauce;
	dark_sauce;
}
