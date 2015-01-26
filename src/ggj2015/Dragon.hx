package ggj2015;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import com.haxepunk.masks.Hitbox;
import com.haxepunk.masks.Imagemask;
import com.haxepunk.masks.Masklist;
 
class Dragon extends Entity
{
	var anim: Spritemap;
	
	var nextBlink: Float = 5.0;
	var blinkRate: Float = 0;
	
	var yDir: Int = -1;
	
	var health: Int = 10;
	public var dead: Bool = false;
	
	var prevX: Float;
	var recoilDist: Int = 50;
	var recoiling: Bool = false;
	var recoilBack: Bool = false;
	var recoilDir: Int = 1;
	var recoilBackDur: Float = 2;
	
	public function new(x: Float, y: Float) 
	{
		super(x, y, anim = new Spritemap("graphics/stage/dragon.png", 86, 51, animCallback));
		
		type = "dragon";
		
		anim.scale = 3;
		anim.smooth = false;
		anim.centerOrigin();
		
		anim.add("idle", [0]);
		anim.add("blink", [1, 2, 1], 9, false);
		anim.add("recoil_blink", [2], 3, false);
		anim.add("die", [0, 1, 2], 5, false);		
		
		mask = new Masklist([new Hitbox(160, 84, 0, -16), new Hitbox(120, 120, -120, -48)]);
	}
	
	function animCallback()
	{
		if (anim.currentAnim == "blink")
		{
			anim.play("idle");
		}
	}
	
	override public function update():Void 
	{
		super.update();
		y += yDir * HXP.elapsed * (dead? 150 : 30);
		if (recoiling)
		{
			x += recoilDir * HXP.elapsed * 100;
			if (recoilDir == 1)
			{
				if (x - prevX >= recoilDist)
				{
					recoilDir = -1;
				}
			}
			else
			if (recoilDir == -1)
			{
				if (x <= prevX)
				{
					x = prevX;
					recoilDir = 1;
					recoiling = false;
					anim.play("idle");
				}
			}
		}
		else
		{
			if (!dead)
			{
				var player: Player = cast scene.nearestToEntity("player", this);
				if (player != null)
				{
					if (Math.abs(x - player.x) < 100)
					{
						yDir = cast HXP.sign(player.y - y) * 2;
					}
				}
			}
			
			if (!dead)
			{
				if (y - halfHeight < 0)
				{
					y = halfHeight;
					yDir = 1;
				}
				if ( y + halfHeight > 250)
				{
					y = 250 - halfHeight;
					yDir = -1;
				}
				
				blinkRate += HXP.elapsed;
				if (blinkRate >= nextBlink)
				{
					blinkRate = 0;
					nextBlink = HXP.rand(3) + 2;
					anim.play("blink");
				}
				
				var slash: Slash = cast collide("slash", x, y);
				if (slash != null)
				{
					recoiling = true;
					prevX = x;
					anim.play("recoil_blink");
					
					slash.explode();
					health -= 1;
					if (health == 0)
					{
						anim.play("die");
						dead = true;
						yDir = 1;	
					}
				}
			}
		}
	}
}