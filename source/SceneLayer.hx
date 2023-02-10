import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.group.FlxSpriteGroup;

class SceneLayer extends FlxSpriteGroup
{
	public function new()
	{
		super();
		var padding = 35;

		var pizzaSurface = new FlxSprite(0, 0, AssetPaths.surface__png);
		pizzaSurface.screenCenter();
		add(pizzaSurface);

		var ticketHolder = new FlxSprite(0, 0, AssetPaths.empty_ticketholder__png);
		add(ticketHolder);
		// ? place ticket holder above work surface
		ticketHolder.x = pizzaSurface.x;
		ticketHolder.y = pizzaSurface.y + ticketHolder.height + padding;
	}
}
