package ggj2015;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.TiledImage;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import openfl.geom.Rectangle;
import openfl.text.TextFormatAlign;

enum StageState {
	PREBOSS;
	BOSS;
	CREDITS;
	POSTCREDITS;
}

class StageScene extends Scene
{	
	var cameraXMin: Float = 0;
	var cameraXMax: Float = HXP.NUMBER_MAX_VALUE;
	var stageState: StageState;
	
	var player: Player;
	var dragon: Dragon;
	var greenScreen: Entity;
	var creditsBG: Entity;
	var creditsText: Text;
	
	var woodFloor1: TiledImage;
	var grassFloor1: TiledImage;
	
	var creditNames: Array<String> = [
		"Congratulations! You have saved\nthe kindgom from the dragon.",
		"Peace has been restored to the realm.",
		"Directed by\n\nThe Director",
		"Produced by\n\nDark Potato Productions",
		"Written by\n\nA Lot of People Productions",
		"Rigging by\n\nAnheurystics Studio",
		"Costumes and Design by\n\nKageto Fashion",
		"Special Thanks to\n\nThe Sapphireous Foundation"
	];
	
	var creditIndex: Int = 0;
	var creditInterval: Float = 1.5;
	var creditTimer: Float = 0;
	
	var creditLockTimer: Float = 0;
	
	var creditMoved: Bool = false;
	var creditEdge: Image;
	
	public function new() 
	{
		super();
		player = new Player(50, 150, "player.png");
		greenScreen = new Entity(800, 0, Image.createRect(400, 300, 0x00FF00));
		creditsBG = new Entity(800, 0, Image.createRect(400, 300, 0));
		creditsText = new Text("", 0, 0, 400, 150, { size: 8, color: 0xFFFFFF, align: TextFormatAlign.CENTER } );
		creditsText.smooth = false;
		creditsText.centerOrigin();
		
		stageState = PREBOSS;
		
		woodFloor1 = new TiledImage("graphics/stage/wood_2.png", 1200, 48);
		woodFloor1.smooth = false;
		
		grassFloor1 = new TiledImage("graphics/stage/grassplatform.png", 800, 16, new Rectangle(0, 0, 50, 16));
		creditEdge = new Image("graphics/stage/credits_edge.png");
		creditEdge.smooth = false;
		
		creditTimer = creditInterval;
	}
	
	override public function begin() 
	{
		super.begin();
		add(greenScreen);
		add(creditsBG);
		addGraphic(new Image("graphics/stage/sunset.png"));
		addGraphic(new Image("graphics/stage/sunset.png"), 0, 400);
	
		add(new Entity(1000, 150, creditsText));
		
		add(dragon = new Dragon(700, 150));
		
		add(new Platform(1200, 230, 2400, 70, 0x453412));
		add(new Platform(0, 230, 800, 70, 0x1F1207));
		
		addGraphic(grassFloor1, 0, 0, 225);
		addGraphic(woodFloor1, 0, 1200, 210);
		addGraphic(new Image("graphics/stage/bigBox.png"), 1, 1300, 210);
		
		addGraphic(creditEdge, 0, 1200, 0);
		
		add(new NPC(1400, 190, new Image("graphics/stage/anheu.png"), ["The director would like\nto see you now."], ["You should go to him."], NPC.NPC_FLAVOR));
		add(new NPC(1600, 195, new Image("graphics/stage/dpk.png"), ["..."], ["Any additional roles after this?"], NPC.NPC_FLAVOR));	
		add(new NPC(1500, 200, new Image("graphics/stage/Crumbles.png"), ["Hi there.", ""], ["I don't get paid enough for this.", "I'm So Meta, Even\nThis Acronym"], NPC.NPC_FLAVOR));
		
		add(new NPC(100, 206, new Image("graphics/stage/jessey.png"), ["Beware!\nThe dragon lies ahead."], ["Be quick on your feet.\nYou can use either the\nWASD or the arrow keys."], NPC.NPC_TUTORIAL));
		add(new NPC(200, 206, new Image("graphics/stage/Anna.png"), ["It will get pretty\ndangerous"], ["Jump with Z\\J,\nand attack with X\\K!"], NPC.NPC_TUTORIAL));
		
		add(new NPC(1800, 206, new Image("graphics/stage/Morpheus.png"), ["Greetings."], ["I noticed that you are currently jobless.\nThese posters are job listings\nyou might be interested in."], NPC.NPC_TUTORIAL));
		
		add(new JobPoster(1900, 180, new Image("graphics/stage/poster1.png"), "Would you like to work as a chef?"));
		add(new JobPoster(1950, 180, new Image("graphics/stage/poster2.png"), "Would you like to work as a plumber?"));
		add(new JobPoster(2000, 180, new Image("graphics/stage/poster3.png"), "Would you like to work as a serviceman?"));
		
		add(player);
		
		add(new Platform(800, 230, 400, 70, 0));
	}
	
	override public function update() 
	{
		super.update();
		
		if (stageState == PREBOSS) 
		{
			cameraXMin = 0;
			cameraXMax = HXP.NUMBER_MAX_VALUE;
		}
		if (stageState == BOSS)
		{
			cameraXMin = 400;
			cameraXMax = dragon.dead? HXP.NUMBER_MAX_VALUE : 800;
		}
		if (stageState == CREDITS)
		{
			if (creditIndex < creditNames.length )
			{
				cameraXMin = 800;
				cameraXMax = 1200;
			}
			else
			{
				if (creditMoved)
				{
					cameraXMin = 800;
					cameraXMax = HXP.NUMBER_MAX_VALUE;
				}
				else
				{
					if (player.velocity.x != 0)
					{
						creditMoved = true;
					}
				}
			}
			
			creditTimer += HXP.elapsed;
			if (creditTimer >= creditInterval)
			{
				creditTimer = 0;
				var next: String = creditNames[creditIndex++];
				creditsText.text = next == null? "" : next;
			}
		}
		if (stageState == POSTCREDITS)
		{
			cameraXMin = 1200;
			cameraXMax = 2000;
		}
		
		player.x = HXP.clamp(player.x, cameraXMin, cameraXMax);
		
		if (!(stageState == CREDITS && !creditMoved))
		{
			HXP.camera.x = HXP.clamp(player.x - 200, cameraXMin, cameraXMax - 400);
		}
		
		if (HXP.camera.x >= 0 && HXP.camera.x < 400)
		{
			stageState = PREBOSS;
		}
		else
		if (HXP.camera.x >= 400 && HXP.camera.x < 800)
		{
			stageState = BOSS;
		}
		else
		if (HXP.camera.x >= 800 && HXP.camera.x < 1200)
		{
			stageState = CREDITS;
		}
		else
		if (HXP.camera.x >= 1200 && HXP.camera.x < 2400)
		{
			stageState = POSTCREDITS;
		}
	}
	
	override public function render() 
	{
		super.render();
	}
}