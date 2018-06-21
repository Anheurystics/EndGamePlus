package ggj2015;

import haxepunk.graphics.tile.Backdrop;
import haxepunk.graphics.text.Text;
import haxepunk.graphics.tile.TiledImage;
import haxepunk.HXP;
import haxepunk.math.MathUtil;
import haxepunk.math.Random;
import haxepunk.Scene;
import haxepunk.input.Key;
import haxe.macro.Type;
import haxe.Timer;
import openfl.text.TextFormatAlign;

class ChefScene extends Scene
{	
	var bg: Backdrop;
	var tiles: TiledImage;
	
	var chef: Chef;
	
	var minSpeed: Int = 128;
	var maxSpeed: Int = 128;
	var minAngle: Int = 10;
	var maxAngle: Int = 80;
	
	var foodTypes: Array<String> = ["applemato", "carrot", "orange", "watermelon", "banana", "mango"];
	
	var checkTimer: Float = 0;
	
	var timerText: Text;
	var timer: Float = 0;

	public var airCombo: Int = 0;
	public var score: Int = 0;
	
	var scoreText: Text;
	var airComboText: Text;
	
	var instructions: Text;
	var countdown: Text;
	
	var center = 
	#if (flash || html5)
	TextFormatAlign.CENTER;
	#else 
	"center"; 
	#end 
	
	var postWin: Bool = false;
	var postMessageText: Text;
	
	var shiftLength: Int = 60;
	
	public function new() 
	{
		super();
		bg = new Backdrop("graphics/chef/kitchenbackground.png");
		tiles = new TiledImage("graphics/chef/tiledplatform.png", 400, 75);
		chef = new Chef(200, 150);
		
		scoreText = new Text("Score: ", 20, 250, 200, { size: 8, color: 0x000000 } );
		scoreText.smooth = false;
		airComboText = new Text("Air Combo: ", 260, 250, 200, { size: 8, color: 0x000000 } );
		airComboText.smooth = false;
		timerText = new Text("", 200, 270, 200, { size: 8, color: 0x000000, align: center} );
		timerText.smooth = false;
		timerText.centerOrigin();
		
		instructions = new Text("This is a weird new job.\nYour shift lasts for " + shiftLength + " seconds.\n\nSlice and dice to stay in the air.\nChain together combos for a higher score", 200, 150, 200, { size: 8, color: 0x000000, align: center});
		instructions.smooth = false;
		instructions.centerOrigin();
		
		postMessageText = new Text("Press \'R\' to try again.\n(Feels like forever, doesn't it?)", 200, 150, 300, 200, { size: 8, color: 0x000000, align: center } );
		postMessageText.smooth = false;
		postMessageText.centerOrigin();
		
		Timer.delay(function() {
			instructions.visible = false;
		}, 2000);
	}
	
	
	override public function begin() 
	{
		super.begin();
		addGraphic(bg);
		add(new Platform(0, 250, 400, 50));
		addGraphic(tiles, 0, 0, 225);
		
		add(chef);
		addGraphic(scoreText);
		addGraphic(airComboText);
		addGraphic(timerText);
		
		addGraphic(postMessageText);
		postMessageText.visible = false;
		
		addGraphic(instructions);
	}
	
	override public function update() 
	{
		super.update();
		if (postWin)
		{
			if (Key.pressed(Key.R))
			{
				HXP.scene = new ChefScene();
			}
			return;
		}
		
		timer += HXP.elapsed;
		
		chef.x = MathUtil.clamp(chef.x, 0, 400);
		
		checkTimer += HXP.elapsed;
		if (checkTimer > 0.5)
		{
			var lr: Bool = Random.randInt(2) == 0;
			var angle: Float = lr? 0 : 180;
			var inc: Int = lr? 1 : -1;
			var x: Int = lr? 0 : 400;
			var add: Float = Random.randInt(maxAngle - minAngle + 1) + minAngle;
			
			create(Food).spawn(x, 150, angle + (inc * add), 128, foodTypes[Random.randInt(foodTypes.length)], Random.randInt(4) == 0);
			
			checkTimer = 0;
		}
		
		scoreText.text = "Score: " + score;
		
		if(timer >= shiftLength) timer = shiftLength;
		
		var i: Int = Std.int(timer * 100);
		timer = i / 100;
		
		airComboText.text = "Air Combo: " + airCombo;
		timerText.text = '${timer} s';
		
		if (timer == shiftLength)
		{
			var foods: Array<Food> = new Array();
			getClass(Food, foods);
			
			postMessageText.visible = true;
			postWin = true;
			removeList(foods);
		}
	}	
}