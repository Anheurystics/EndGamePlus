package ggj2015;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import com.haxepunk.utils.Input;
import openfl.geom.Point;

class Player extends Entity
{
	static var MOVESPEED: Int = 128;
	static var JUMPFORCE: Int = 256;
	
	public var velocity: Point;
	
	var anim: Spritemap;
	
	var lastDir: Int = 1;
	
	var slashCallback: Slash->String->Void;
	
	var slashLifetime: Float = 0.2;
	var slashSpeed: Int = 256;
	
	public function new(x: Float, y: Float, spriteSource: String) 
	{
		super(x, y, anim = new Spritemap("graphics/" + spriteSource, 48, 48, animCallback));
		
		anim.smooth = false;
		
		anim.add("idle", [0]);
		anim.add("walk", [1, 2, 3, 2], 8);
		anim.add("jump", [3]);
		anim.add("attack", [4, 5, 5, 6, 6], 18, false);
		
		anim.play("idle");
		
		anim.centerOrigin();
		
		type = "player";
		setHitbox(32, 48, 16, 24);
		
		velocity = new Point();
	}
	
	function animCallback()
	{
		if (anim.currentAnim == "attack")
		{
			anim.play("idle");
		}
	}
	
	override public function update():Void 
	{
		super.update();		
		moveBy(velocity.x * HXP.elapsed, velocity.y * HXP.elapsed, "platform", true);
		
		velocity.y += 512 * HXP.elapsed;
		
		if (x > 1900)
		{
			HXP.scene = new MonthsLater();
		}
				
		if (anim.currentAnim != "attack")
		{
			if (Input.check("player_left"))
			{
				velocity.x = -MOVESPEED;
				anim.flipped = true;
				lastDir = -1;
			}
			else
			if (Input.check("player_right"))
			{
				velocity.x = MOVESPEED;
				anim.flipped = false;
				lastDir = 1;
			}
			else
			{
				velocity.x = 0;
			}
			
			if (velocity.x == 0)
			{
				anim.play("idle");
			}
			else
			{
				anim.play("walk");
			}
			
			if (Input.pressed("player_attack"))
			{
				scene.create(Slash).spawn(x + (lastDir * 16), y + 12, lastDir, slashCallback, slashSpeed, slashLifetime);
				Sound.get("audio/sword" + (HXP.rand(3) + 1)).play();
				anim.play("attack");
				
				var npc: NPC = cast collide("npc", x, y);
				if (npc != null)
				{
					npc.interact();
				}
			} 
		}
		
		if (onGround())
		{
			if (velocity.y != 0) velocity.y = 0;
			
			if (Input.pressed("player_jump"))
			{
				Sound.get("audio/jump" + (HXP.rand(3) + 1)).play();
				jump();
			}
		}
		else
		{
			if (anim.currentAnim != "attack")
			{
				anim.play("jump");
			}
		}
		
		if (collide("platform", x, y - 1) != null)
		{
			if (velocity.y < 0) velocity.y = 0;
		}
	}
	
	function onGround(): Bool {
		return collide("platform", x, y + 1) != null;
	}
	
	public function jump(scale: Float = 1.0): Void
	{
		velocity.y = -JUMPFORCE * scale;
	}
	
	override public function render():Void 
	{
		super.render();
	}
}