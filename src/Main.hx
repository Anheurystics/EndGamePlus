import haxepunk.Engine;
import haxepunk.HXP;
import haxepunk.input.Key;
import haxepunk.screen.ScaleMode;

import ggj2015.MainScene;

class CustomScaleMode extends ScaleMode {
	override public function resize(stageWidth: Int, stageHeight: Int) {
		var scale = haxepunk.math.MathUtil.min(stageWidth / baseWidth, stageHeight / baseHeight);
		HXP.screen.scaleX = scale;
		HXP.screen.scaleY = scale;
		HXP.screen.width = stageWidth;
		HXP.screen.height = stageHeight;
		HXP.screen.x = Std.int((stageWidth - (baseWidth * scale)) * 0.5);
		HXP.screen.y = Std.int((stageHeight - (baseHeight * scale)) * 0.5);
	}
}

class Main extends Engine
{
	override public function init()
	{
	#if debug
		HXP.console.enable();
	#end

		HXP.screen.scaleMode = new CustomScaleMode();
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
