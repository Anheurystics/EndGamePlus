package ggj2015;

import haxepunk.Entity;
import haxepunk.graphics.Graphiclist;
import haxepunk.graphics.Image;
import haxepunk.graphics.text.Text;
import haxepunk.HXP;
import haxepunk.math.Random;
import openfl.text.TextFormatAlign;

class NPC extends Entity
{
	public static var NPC_TUTORIAL: Int = 0;
	public static var NPC_FLAVOR: Int = 1;
	
	var greetings: Array<String>;
	var messages: Array<String>;
	var npcType: Int;
	
	var messageIndex: Int;
	
	var textGraphic: Text;
	var image: Image;
	var speech: Image;
	
	var showing: Bool = false;
	var showTimer: Float = 0;
	
	public function new(x: Float, y: Float, _image: Image, _greetings: Array<String>, _messages: Array<String>, _npcType: Int)
	{
		super(x, y, image);
		type = "npc";
		
		greetings = _greetings;
		messages = _messages;
		npcType = _npcType;
		
		messageIndex = 0;
		
		image = _image;
		image.centerOrigin();
		image.smooth = false;
		
		setHitboxTo(image);
		
		textGraphic = new Text("", 0, -80, 200, 0, { size: 8, color: 0x000000, wordWrap: true, align: TextFormatAlign.CENTER} );
		textGraphic.smooth = false;
		textGraphic.centerOrigin();
		
		graphic = new Graphiclist([image, textGraphic]);
		
	}
	
	override public function update():Void 
	{
		super.update();
		if (showing)
		{
			showTimer += HXP.elapsed;
			if (showTimer >= 5)
			{
				showTimer = 0;
				showing = false;
				textGraphic.text = "";
			}
		}
		
		var player: Player = cast scene.nearestToEntity("player", this);
		if (player != null)
		{
			image.flipped = player.x - x < 0;
		}
		
		if (!showing)
		{
			textGraphic.text = (collide("player", x, y) != null)? greetings[Random.randInt(greetings.length)] : "";
		}
	}
	
	public function interact(): Void
	{
		if (npcType == NPC_TUTORIAL)
		{
			messageIndex++;
			
			if (messageIndex == messages.length) messageIndex = 0;
			
			show_message(messageIndex);
		}
		if (npcType == NPC_FLAVOR)
		{
			messageIndex = Random.randInt(messages.length);
			show_message(messageIndex);
		}
		showing = true;
	}
	
	public function show_message(index: Int): Void
	{
		textGraphic.text = messages[index];
	}
}