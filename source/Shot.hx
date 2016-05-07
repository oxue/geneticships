package ;
import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
 * ...
 * @author q
 */
class Shot extends FlxSprite
{
	public var team:Int;
	
	public function new(X:Float, Y:Float) 
	{
		super(X, Y);
		makeGraphic(8, 8, FlxColor.TEAL,false, "shot");
	}
	
	override public function update():Void 
	{
		super.update();
		if (!isOnScreen())
		destroy();
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		if (team & 1 == 1) GlobalGroups.goodShots.add(this);
		if (team & 2 == 2) GlobalGroups.badShots.add(this);
	}
	
}