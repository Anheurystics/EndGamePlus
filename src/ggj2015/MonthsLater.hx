package ggj2015;

import haxepunk.graphics.Image;
import haxepunk.graphics.text.Text;
import haxepunk.HXP;
import haxepunk.Scene;
import haxe.Timer;
import openfl.text.TextFormatAlign;

class MonthsLater extends Scene
{
	var desc: Text;
	var center =
	#if (flash || html5)
	TextFormatAlign.CENTER;
	#else
	"center";
	#end
	
	public function new() 
	{
		super();
		desc = new Text("5 months and 3 job\ninterviews later", 200, 150, 300, 200, { color: 0xFFFFFF, align: center } );
		addGraphic(Image.createRect(400, 300, 0));
		
		desc.centerOrigin();
		desc.smooth = false;
		addGraphic(desc);
		
		Timer.delay(function() {
			HXP.scene = new ChefScene();
		}, 5000);
	}	
}