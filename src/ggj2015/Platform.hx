package ggj2015;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class Platform extends Entity
{
	public function new(x: Float, y: Float, width: Int, height: Int, color: Int = 0xFFFFFF) 
	{
		super(x, y, Image.createRect(width, height, color));
		type = "platform";
		
		setHitboxTo(graphic);
	}	
}