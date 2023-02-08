import flixel.system.FlxSoundGroup;
import flixel.FlxG;
import flixel.system.FlxSound;

 class AssetsUtil {
	public static final successSfx = FlxG.sound.load(AssetPaths.yay_6120__mp3, volume);
	public static final playSuccess = (volume:Float = 1) ->{
		successSfx.volume = volume;
		successSfx.play(true);
	};
	public static final failSfx = FlxG.sound.load(AssetPaths.negative_beeps_6008__mp3, volume);
	public static final playFail = (volume:Float = 1) ->{
		failSfx.volume = volume;
		failSfx.play(true);
	};
	public static final bgMusic = FlxG.sound.load(AssetPaths.upbeat_funky_retro_131297__mp3, volume);
	public static final playBGMusic = (volume:Float = 1) -> {
		bgMusic.volume = volume;
		bgMusic.play(true);
	};
 }