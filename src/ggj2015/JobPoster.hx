package ggj2015;

import haxepunk.Entity;
import haxepunk.graphics.Graphiclist;
import haxepunk.graphics.Image;
import haxepunk.graphics.text.Text;
import openfl.text.TextFormatAlign;

class JobPoster extends Entity
{
	var image: Image;
	var queryText: Text;
	
	public static var querying: Bool = false;
	public static var currentQuerying: JobPoster;
	
	var center = 
	#if (flash || html5)
	TextFormatAlign.CENTER;
	#else
	"center";
	#end
	
	var queries: Bool;
	
	public function new(x: Float, y: Float, _image: Image, queryQuestion: String, _queries: Bool = true) 
	{
		super(x, y);
		
		type = "poster";
		
		image = _image;
		queries = _queries;
		
		queryText = new Text(queryQuestion, 200, 150, 200, 100, { color: 0x000000, size: 8, align: center } );
		queryText.smooth = false;
		queryText.visible = false;
		
		image.centerOrigin();
		image.smooth = false;
		setHitboxTo(image);
		
		graphic = new Graphiclist([image, queryText]);
	}
	
	public function query(): Void
	{
		if (querying) return;
		querying = true;
		currentQuerying = this;
		
		queryText.visible = true;
	}
}