import Topping.ToppingEnum;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxExtendedSprite;
import flixel.graphics.FlxGraphic;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;

class AssetsUtil
{
	public function new() {}

	public final successSfx = FlxG.sound.load(AssetPaths.yay__mp3);

	public function playSuccess(volume:Float = 1)
	{
		successSfx.volume = volume;
		successSfx.play(true);
	}

	public final failSfx = FlxG.sound.load(AssetPaths.negative__mp3);

	public function playFail(volume:Float = 1)
	{
		failSfx.volume = volume;
		failSfx.play(true);
	}

	public final bgMusic = FlxG.sound.load(AssetPaths.upbeat_funky_retro_131297__mp3);

	public function playBGMusic(volume:Float = 1, loop:Bool = true)
	{
		bgMusic.volume = volume;
		bgMusic.play(true);
		bgMusic.looped = loop;
	}
}

class ToppingSprite extends FlxExtendedSprite
{
	public var value:ToppingEnum;

	public function new(topping:ToppingEnum, cooked:Bool = false)
	{
		super();
		enableMouseClicks(false);
		value = topping;
		switch topping
		{
			case ToppingEnum.pepperoni:
				loadGraphic(AssetPaths.pepperoni_topping__png);
			case ToppingEnum.mushroom:
				loadGraphic(AssetPaths.mushroom_topping__png);
			case ToppingEnum.yellow_cheese:
				if (cooked)
					loadGraphic(AssetPaths.cooked_yellow_cheese__png);
				else
				{
					loadGraphic(AssetPaths.yellow_cheese_topping__png);
				}
			case ToppingEnum.white_cheese:
				if (cooked)
					loadGraphic(AssetPaths.cooked_white_cheese__png);
				else
				{
					loadGraphic(AssetPaths.white_cheese_topping__png);
				}
			case ToppingEnum.light_sauce:
				if (cooked)
					loadGraphic(AssetPaths.cooked_light_sauce__png);
				else
				{
					loadGraphic(AssetPaths.light_sauce_topping__png);
				}
			case ToppingEnum.dark_sauce:
				if (cooked)
					loadGraphic(AssetPaths.cooked_dark_sauce__png);
				else
				{
					loadGraphic(AssetPaths.dark_sauce_topping__png);
				}
				updateHitbox();
		}
	}
}

//   d8,
//  `8P
//   88b  88bd88b     ?88,.d88b,  88bd88b d8888b  d888b8b    88bd88b d8888b .d888b, .d888b,
//   88P  88P' ?8b    `?88'  ?88  88P'  `d8P' ?88d8P' ?88    88P'  `d8b_,dP ?8b,    ?8b,
//  d88  d88   88P      88b  d8P d88     88b  d8888b  ,88b  d88     88b       `?8b    `?8b
// d88' d88'   88b      888888P'd88'     `?8888P'`?88P'`88bd88'     `?888P'`?888P' `?888P'
//                      88P'                            )88
//                     d88                             ,88P
//                     ?8P                         `?8888P
// class CustomerSprite extends FlxSprite
// {
// 	private var state:Emotion;
// 	public var avatar:Int;
// 	/** one-based index	 */
// 	public static final AVATAR_COUNT = 83;
// 	/**
// 		Create a new customer sprite
// 		@param avatar an zero-based index of which avatar to render out of 82
// 			numbers out of bound will render a random avatar
// 	**/
// 	public function new(avatar:Int = -1)
// 	{
// 		super();
// 		loadGraphic(AssetPaths.customers__png, true, 92, 96);
// 		for (i in 0...AVATAR_COUNT)
// 			for(j in 0...Emotion.createAll().length)
// 			animation.add(Emotion.createByIndex(j) + "-" + i,[j*i*5]);
// 		// trace(animation.getAnimationList());
// 		setAvatar(avatar);
// 		trace(animation.frames);
// 		setEmotion(Emotion.neutral);
// 		updateGraphic();
// 	}
// 	public function setEmotion(emotion:Emotion)
// 	{
// 		state = emotion;
// 	}
// 	public function getEmotion():Emotion
// 	{
// 		return state;
// 	}
// 	public function setAvatar(index:Int)
// 	{
// 		if (index < 0 || index > AVATAR_COUNT)
// 			index = FlxG.random.int(0, AVATAR_COUNT);
// 		else
// 			avatar = index;
// 	}
// 	public function getAvatar():Int
// 	{
// 		return avatar;
// 	}
// 	private function updateGraphic()
// 	{
// 		animation.play(state.getIndex()+"-"+avatar);
// 	}
// }
// enum Emotion
// {
// 	neutral;
// 	happy;
// 	pensive;
// 	eating1;
// 	eating2;
// 	upset;
// 	sad;
// 	mouthfull;
// 	feeding1;
// 	feeding2;
// }
