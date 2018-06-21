package ggj2015;

import haxepunk.HXP;
import haxepunk.Scene;
import haxepunk.input.Input;
import haxepunk.input.Key;

class MainScene extends Scene
{
	var player: Player;
	
	public function new()
	{
		super();
		
		HXP.defaultFont = "font/emulogic";
		
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