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
	public var name:String;
	public var spritesheet:FlxAtlasFrames;
	public var draggableTopping:Topping;

	/**
		name:String - name of the topping i.e pepperoni, mozarella, skittles, etc.
		spritesheet:FlxAtlasFrames - spritesheet containing an image for topping while:
		 it's in the container
		 it's being dragged
		 it's on the pizza
	**/
	public function new(name:String, spritesheet:FlxAtlasFrames, dragged = false)
	{
		super();
		this.name = name;
		this.spritesheet = spritesheet;
		frames = this.spritesheet;

		if (dragged == false)
		{
			// Initialize the draggable topping and set the proper frame.
			draggableTopping = new Topping(this.name, this.spritesheet, true);
			draggableTopping.frame = draggableTopping.frames.getByIndex(1);
		}
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
			trace("Handler");

			/**
				Revive the sprite if it has been killed. Drag the sprite around 
				while mouse is still being pressed down.
			**/
			if (draggableTopping.alive == false)
			{
				draggableTopping.revive();
			}
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
		// Kill the sprite once the mouse button is released
		draggableTopping.kill();
		isPressed = false;

		if (isDragged == true)
		{
			stopDrag();
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
