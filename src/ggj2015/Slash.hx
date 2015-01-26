package ggj2015;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;

class Slash extends Entity
{
	var speed: Int;
	var lifetime: Float;
	
	var dir: Int;
	var life: Float;
	
	var anim: Spritemap;
	
	var callback: Slash->String->Void;
	
	public function new() 
	{
		super(0, 0, anim = new Spritemap("graphics/slash.png", 24, 24, animCallback));
		type = "slash";
		
		anim.add("idle", [0, 0, 1, 1], 10, false);
		anim.add("spark", [4, 5, 6, 7], 16, false);
		anim.centerOrigin();
		
		setHitboxTo(anim);
	}
	
	function animCallback()
	{
		if (anim.currentAnim == "spark")
		{
			scene.recycle(this);
		}
	}
	
	public function spawn(_x: Float, _y: Float, _dir: Int, _callback: Slash->String->Void, _speed: Int = 256, _lifetime: Float = 0.2)
	{
		x = _x;
		y = _y;
		dir = _dir;
		callback = _callback;
		life = 0;
		
		speed = _speed;
		lifetime = _lifetime;
		
		anim.flipped = dir == -1;
		anim.stop(true);
		anim.play("idle");
	}
	
	override public function update():Void 
	{
		super.update();

		if (anim.currentAnim != "spark")
		{
			x += speed * HXP.elapsed * dir;
		
			life += HXP.elapsed;
			if (life >= lifetime)
			{
				scene.recycle(this);
			}
			
			var food: Food = cast collide("food", x, y);
			if (food != null && !food.exploded)
			{
				explode();
				if (food.hit())
				{
					callback(this, "smashfood");
				}
				else
				{
					callback(this, "hitfood");
				}
			}
		}
	}
	
	public function explode()
	{
		anim.play("spark");
	}
}