package controller;
import flash.geom.Point;
import flixel.FlxG;
import flixel.util.FlxPoint;

/**
 * ...
 * @author q
 */
class MouseController extends Controller
{

	public function new() 
	{
		super();
		
	}
		
	override public function update(_target:Fighter):Void 
	{
		var p:Point = new Point();
		p.x = FlxG.mouse.x - _target.x;
		p.y = FlxG.mouse.y - _target.y;
		
		if (FlxG.mouse.pressed)
		{
			_target.move(p);
		}
		
		if (FlxG.mouse.justPressedRight)
		{
			_target.shoot(p, 1);
		}
		
		
	}
}