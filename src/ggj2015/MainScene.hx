package ggj2015;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class MainScene extends Scene
{
	var player: Player;
	
	public function new()
	{
		super();
		
		HXP.defaultFont = "font/emulogic.ttf";
		
		Input.define("player_left", [Key.A, Key.LEFT]);
		Input.define("player_right", [Key.D, Key.RIGHT]);
		Input.define("player_jump", [Key.J, Key.Z]);
		Input.define("player_attack", [Key.K, Key.X]);
	}
	
	override public function begin() 
	{
		super.begin();
		
		HXP.scene = new StageScene();
	}
}