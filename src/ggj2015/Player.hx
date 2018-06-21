package ggj2015;

import haxepunk.Entity;
import haxepunk.graphics.Image;
import haxepunk.graphics.Spritemap;
import haxepunk.HXP;
import haxepunk.math.Random;
import haxepunk.Sfx;
import haxepunk.input.Input;
import openfl.geom.Point;

class Player extends Entity
{
	static var MOVESPEED: Int = 128;
	static var JUMPFORCE: Int = 256;
	
	public var velocity: Point;
	
	var spritemap: Spritemap;
	
	var lastDir: Int = 1;
	
	var slashCallback: Slash->String->Void;
	
	var slashLifetime: Float = 0.2;
	var slashSpeed: Int = 256;
	
	public function new(x: Float, y: Float, spriteSource: String) 
	{
		super(x, y, spritemap = new Spritemap("graphics/" + spriteSource, 48, 48));
		spritemap.onAnimationComplete.bind(spritemapCallback);
		
		spritemap.smooth = false;
		
		spritemap.add("idle", [0]);
		spritemap.add("walk", [1, 2, 3, 2], 8);
		spritemap.add("jump", [3]);
		spritemap.add("attack", [4, 5, 5, 6, 6], 18, false);
		
		spritemap.play("idle");
		
		spritemap.centerOrigin();
		
		type = "player";
		setHitbox(32, 48, 16, 24);
		
		velocity = new Point();
	}
	
	function spritemapCallback(anim: Animation)
	{
		if (anim.name == "attack")
		{
			spritemap.play("idle");
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
				
		if (spritemap.currentAnimation.ensure().name != "attack")
		{
			if (Input.check("player_left"))
			{
				velocity.x = -MOVESPEED;
				spritemap.flipped = true;
				lastDir = -1;
			}
			else
			if (Input.check("player_right"))
			{
				velocity.x = MOVESPEED;
				spritemap.flipped = false;
				lastDir = 1;
			}
			else
			{
				velocity.x = 0;
			}
			
			if (velocity.x == 0)
			{
				spritemap.play("idle");
			}
			else
			{
				spritemap.play("walk");
			}
			
			if (Input.pressed("player_attack"))
			{
				scene.create(Slash).spawn(x + (lastDir * 16), y + 12, lastDir, slashCallback, slashSpeed, slashLifetime);
				Sound.get("audio/sword" + (Random.randInt(3) + 1)).play();
				spritemap.play("attack");
				
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
				Sound.get("audio/jump" + (Random.randInt(3) + 1)).play();
				jump();
			}
		}
		else
		{
			if (spritemap.currentAnimation.ensure().name != "attack")
			{
				spritemap.play("jump");
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
}