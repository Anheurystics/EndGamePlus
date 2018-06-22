import haxepunk.Engine;
import haxepunk.HXP;
import haxepunk.input.Key;
import haxepunk.screen.*;
import haxepunk.debug.Console;

import ggj2015.MainScene;

class Main extends Engine
{
	override public function init()
	{
	#if debug
		Console.enable();
	#end

		var scaleMode = new UniformScaleMode(Letterbox);
		scaleMode.setBaseSize(400, 300);

		HXP.screen.scaleMode = scaleMode;
		HXP.scene = new MainScene();
	}

	public static function main() { new Main(); }
	
	override public function update():Void 
	{
		super.update();
		if (Key.pressed(Key.F))
		{
			HXP.fullscreen = !HXP.fullscreen;
		}
	}
}
