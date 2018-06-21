package ggj2015;

import haxepunk.Entity;
import haxepunk.graphics.Spritemap;
import haxepunk.HXP;
import haxepunk.math.Random;
import haxepunk.math.MathUtil;
import haxepunk.masks.Hitbox;
import haxepunk.masks.Imagemask;
import haxepunk.masks.Masklist;
 
class Dragon extends Entity
{
	var spritemap: Spritemap;
	
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
		super(x, y, spritemap = new Spritemap("graphics/stage/dragon.png", 86, 51));
		
		type = "dragon";
		
		spritemap.scale = 3;
		spritemap.smooth = false;
		spritemap.centerOrigin();

		spritemap.onAnimationComplete.bind(animCallback);
		
		spritemap.add("idle", [0]);
		spritemap.add("blink", [1, 2, 1], 9, false);
		spritemap.add("recoil_blink", [2], 3, false);
		spritemap.add("die", [0, 1, 2], 5, false);		
		
		mask = new Masklist([new Hitbox(160, 84, 0, -16), new Hitbox(120, 120, -120, -48)]);
	}
	
	function animCallback(anim: Animation)
	{
		if (anim.name == "blink")
		{
			spritemap.play("idle");
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
					spritemap.play("idle");
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
						yDir = cast MathUtil.sign(player.y - y) * 2;
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
					nextBlink = Random.randInt(3) + 2;
					spritemap.play("blink");
				}
				
				var slash: Slash = cast collide("slash", x, y);
				if (slash != null)
				{
					recoiling = true;
					prevX = x;
					spritemap.play("recoil_blink");
					
					slash.explode();
					health -= 1;
					if (health == 0)
					{
						spritemap.play("die");
						dead = true;
						yDir = 1;	
					}
				}
			}
		}
	}
}