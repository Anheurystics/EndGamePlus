package ggj2015;
import haxepunk.Sfx;

class Sound
{
	static var sounds: Map<String, Sfx> = new Map();
	
	#if flash
	static var ext: String = "mp3";
	#else
	static var ext: String = "ogg";
	#end
	
	public static function get(name: String): Sfx
	{
		if (sounds.exists(name)) return sounds.get(name);
		
		var sfx: Sfx = new Sfx(name + "." + ext);
		sounds.set(name, sfx);
		
		return sfx;
	}
	
}