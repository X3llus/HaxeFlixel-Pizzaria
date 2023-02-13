import flixel.FlxSprite;
import flixel.FlxG;

class AssetsUtil
{
	// ..######...#######..##.....##.##....##.########...######........###....##....##.########.....##.....##.##.....##..######..####..######.
	// .##....##.##.....##.##.....##.###...##.##.....##.##....##......##.##...###...##.##.....##....###...###.##.....##.##....##..##..##....##
	// .##.......##.....##.##.....##.####..##.##.....##.##...........##...##..####..##.##.....##....####.####.##.....##.##........##..##......
	// ..######..##.....##.##.....##.##.##.##.##.....##..######.....##.....##.##.##.##.##.....##....##.###.##.##.....##..######...##..##......
	// .......##.##.....##.##.....##.##..####.##.....##.......##....#########.##..####.##.....##....##.....##.##.....##.......##..##..##......
	// .##....##.##.....##.##.....##.##...###.##.....##.##....##....##.....##.##...###.##.....##....##.....##.##.....##.##....##..##..##....##
	// ..######...#######...#######..##....##.########...######.....##.....##.##....##.########.....##.....##..#######...######..####..######.
	public static final successSfx = FlxG.sound.load(AssetPaths.yay__mp3);
	public static final playSuccess = (volume:Float = 1) ->
	{
		successSfx.volume = volume;
		successSfx.play(true);
	};
	public static final failSfx = FlxG.sound.load(AssetPaths.negative__mp3);
	public static final playFail = (volume:Float = 1) ->
	{
		failSfx.volume = volume;
		failSfx.play(true);
	};
	public static final bgMusic = FlxG.sound.load(AssetPaths.upbeat_funky_retro_131297__mp3);
	public static final playBGMusic = (volume:Float = 1, loop:Bool = true) ->
	{
		bgMusic.volume = volume;
		bgMusic.play(true);
		bgMusic.looped = loop;
	};
}

// .####.##.....##....###.....######...########..######.
// ..##..###...###...##.##...##....##..##.......##....##
// ..##..####.####..##...##..##........##.......##......
// ..##..##.###.##.##.....##.##...####.######....######.
// ..##..##.....##.#########.##....##..##.............##
// ..##..##.....##.##.....##.##....##..##.......##....##
// .####.##.....##.##.....##..######...########..######.

class CustomerSprite extends FlxSprite
{
	private var state:Emotion;

	public var avatar:Int;

	public static final AVATAR_COUNT = 82;

	/**
		Create a new customer sprite
		@param avatar an zero-based index of which avatar to render out of 82
			numbers out of bound will render a random avatar
	**/
	public function new(avatar:Int = -1)
	{
		super();
		setAvatar(avatar);
		loadGraphic(AssetPaths.customers__png, false, 92, 96);
		trace(animation.frames);
		state = Emotion.neutral;
		updateEmotion();
	}

	public function setEmotion(emotion:Emotion)
	{
		state = emotion;
	}

	public function getEmotion():Emotion
	{
		return state;
	}

	public function setAvatar(index:Int)
	{
		if (index < 0 || index > AVATAR_COUNT)
			index = FlxG.random.int(0, AVATAR_COUNT);
		else
			avatar = index;
	}

	public function getAvatar():Int
	{
		return avatar;
	}

	private function updateEmotion()
	{
		animation.frameIndex = avatar + state.getIndex() - 1;
	}
}

enum Emotion
{
	neutral;
	happy;
	pensive;
	eating1;
	eating2;
	upset;
	sad;
	mouthfull;
	feeding1;
	feeding2;
}
