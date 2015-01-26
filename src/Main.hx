import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.utils.Draw;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import ferret.ResizeUtils;
import ggj2015.MainScene;

class Main extends Engine
{

	override public function init()
	{
		ResizeUtils.init(400, 300);
		
	#if native
		HXP.resizeStage(800, 600);
	#end
		
	#if debug
		HXP.console.enable();
	#end
		HXP.scene = new MainScene();
	}

	public static function main() { new Main(); }
	
	override public function update():Void 
	{
		super.update();
		if (Input.pressed(Key.F))
		{
			HXP.fullscreen = !HXP.fullscreen;
		}
	}
	
	override public function render(): Void
	{
		super.render();
		var gapX: Int = Std.int(ResizeUtils.gap.x / 2);
		var gapY: Int = Std.int(ResizeUtils.gap.y / 2);
		
		if (gapX != 0)
		{
			Draw.rect(cast HXP.camera.x, cast HXP.camera.y, gapX, HXP.windowHeight, 0);
			Draw.rect(cast(HXP.camera.x + HXP.windowWidth - gapX), cast HXP.camera.y, gapX, HXP.windowHeight, 0);
		}
		
		if (gapY != 0)
		{
			Draw.rect(cast(HXP.camera.x), cast HXP.camera.y, HXP.windowWidth, gapY, 0);
			Draw.rect(cast HXP.camera.x, cast(HXP.camera.y + HXP.windowHeight - gapY), HXP.windowWidth, gapY, 0);
		}
	}

}