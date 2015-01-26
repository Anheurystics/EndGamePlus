package ggj2015;

class Chef extends Player
{
	public function new(x: Float, y: Float) 
	{
		super(x, y, "chef/chef.png");
		
		slashCallback = function(slash: Slash, type: String) {
			var cs: ChefScene = cast(scene, ChefScene);
			if (type == "smashfood")
			{
				cs.score += 10 + cs.airCombo;
			}
			if (type == "hitfood" || type == "smashfood")
			{
				cs.airCombo += 1;
				jump(0.75);
			}
		};
	}
	
	override public function update():Void 
	{
		super.update();
		if (onGround()) cast(scene, ChefScene).airCombo = 0;
	}
}