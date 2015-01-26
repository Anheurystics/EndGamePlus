package ggj2015;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.Tween;
import com.haxepunk.Tweener;
import com.haxepunk.utils.Ease;
import openfl.geom.Point;

typedef Explosion = 
{
	var color: Int;
	var num: Int;
}

class Food extends Entity
{
	var velocity: Point;
	var explosion: Array<Emitter>;
	var gfxList: Graphiclist;
	
	var foodType: String;
	
	var explosionInfo: Map<String, Explosion> = 
	[
		"orange" => {color: 0xFFC900, num: 15},
		"applemato" => {color: 0xFAF1CC, num: 12},
		"carrot" => {color: 0xFF6A00, num: 15},
		"watermelon" => { color: 0xFF3333, num : 30 },
		"banana" => { color: 0xFFFF00, num: 9 },
		"mango" => { color: 0xFFD800, num: 15}
	];
	
	public function new()
	{
		super();
		type = "food";
		velocity = new Point();
	}
	
	var speed: Int;
	var image: Image;
	
	var large: Bool = false;
	
	public var exploded: Bool;
	
	var hitpoints: Int;
	
	public function spawn(_x: Float, _y: Float, _dir: Float, _speed: Int, _foodType: String, _large: Bool = false)
	{
		x = _x;
		y = _y;
		velocity.x = Math.cos(HXP.RAD * _dir) * _speed;
		velocity.y = Math.sin(HXP.RAD * _dir) * _speed;
		
		speed = _speed;
		
		foodType = _foodType;
		
		image = new Image("graphics/chef/" + foodType + ".png");
		image.smooth = false;
		
		large = _large;
		
		exploded = false;
		
		hitpoints = large? 2 : 1;
		
		if (large)
		{
			image.scale *= 2;
		}
		
		image.centerOrigin();
		graphic = image;
		
		explosion = new Array();
		
		explosion[0] = new Emitter("graphics/chef/particle_small.png");
		explosion[1] = new Emitter("graphics/chef/particle_medium.png");
		
		explosion[0].newType("default").setGravity(0.9).setMotion(0, 5, 0.2, 360, 20, 0.1).setColor(explosionInfo[foodType].color, explosionInfo[foodType].color);
		explosion[1].newType("default").setGravity(0.9).setMotion(0, 5, 0.2, 360, 20, 0.1).setColor(explosionInfo[foodType].color, explosionInfo[foodType].color);
		
		setHitboxTo(image);
	}
	
	public function explode()
	{
		gfxList = new Graphiclist();
		
		exploded = true;
		
		for (exp in explosion)
		{
			gfxList.add(exp);
			for (i in 0...explosionInfo[foodType].num * (large? 2 : 1))
			{
				exp.emit("default");
			}
		}
		
		if (large)
		{
			var n: Int = HXP.rand(4) + 2;
			for (i in 0...n)
			{
				scene.create(Food).spawn(x, y, HXP.rand(360), 100, foodType, false);
			}
		}
		
		graphic = gfxList;
		velocity.x = velocity.y = 0;
		
		setHitbox();
	}
	
	public function hit(): Bool
	{
		hitpoints -= 1;
		if (hitpoints == 0)
		{
			explode();
			return true;
		}
		else
		{
			var player: Chef = cast scene.nearestToEntity("player", this);
			var angle: Float = HXP.angle(0, 0, player.velocity.x, player.velocity.y);
			
			velocity.x = Math.cos(HXP.RAD * angle) * 100;
			velocity.y = Math.sin(HXP.RAD * angle) * 100;
			return false;
		}
	}
	
	override public function update():Void 
	{
		super.update();
		velocity.y += speed / 2 * HXP.elapsed;
		
		image.angle -= HXP.sign(velocity.x) * (velocity.x / 256) * 150 * HXP.elapsed;
		
		moveBy(velocity.x * HXP.elapsed, velocity.y * HXP.elapsed, "platform");
		
		if (graphic != gfxList && collide("platform", x, y + 1) != null)
		{
			explode();
		}
	}
}