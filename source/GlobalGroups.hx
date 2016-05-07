package ;
import flixel.group.FlxGroup;

/**
 * ...
 * @author q
 */
class GlobalGroups
{

	public static var goodShots:FlxGroup;
	public static var badShots:FlxGroup;
	public static var goodFighters:FlxGroup;
	public static var badFighters:FlxGroup;
	
	public static function init():Void
	{
		goodShots = new FlxGroup();
		goodFighters = new FlxGroup();
		badShots = new FlxGroup();
		badFighters = new FlxGroup();
	}
	
	public function new() 
	{
		
	}
	
}