package;

import controller.AIController;
import controller.MouseController;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		set_bgColor(0xffeeeeee);
		
		GlobalGroups.init();
		AIController.init();
		
		var f:Fighter = new Fighter(100, 100);
		f.setController(new MouseController());
		f.replaceColor(0xffff0000, 0xff00ff00);
		add(f);
		
		///////////////////
		// First Generation
		var i:Int = 10;
		while (i-->0)
		{
			var e:Fighter = new Fighter(AIController.randRange(0, FlxG.width), AIController.randRange(0, FlxG.height));
			var ai:AIController = new AIController();
			ai.setTarget(f);
			ai.setAI(AIController.generateAIEntry());
			e.setController(ai);
			add(e);
		}
	}	
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}	
}