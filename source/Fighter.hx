package ;
import controller.AIController.AIEntry;
import flash.geom.Point;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxAngle;
import haxe.ds.Vector;
import openfl.Assets;

/**
 * ...
 * @author q
 */
class Fighter extends FlxSprite
{
	
	public static inline var FIGHTER_ACC:Float = 600;
	
	public static inline var SHIP_HEALTH:Float = 100;
	
	public static inline var SHIP_MAX_ENERGY:Float = 200;
	public static inline var SHIP_ENERGY_REGEN:Float = 20;
	public static inline var SHIP_SHOT_COST:Float = 15;
	public static inline var SHIP_SHOT_TIMER:Float = 0.1;
	public static inline var SHOT_SPEED:Float = 250;
	
	private var controller:Controller;
	private var shotTimer:Float;
	private var energy:Float;
	
	public var timeSpentAlive:Float;
	
	public function new(X:Float, Y:Float) 
	{
		super(X, Y,Assets.getBitmapData("assets/images/Fighter.png"));
		//loadRotatedGraphic(Assets.getBitmapData("assets/images/Fighter.png"));
		replaceColor(0xffffffff, 0);
		health = Fighter.SHIP_HEALTH;
		shotTimer = 0;
		timeSpentAlive = 0;
		energy = SHIP_MAX_ENERGY;
	}
	
	public function move(_direction:Point):Void
	{
		_direction.normalize(Fighter.FIGHTER_ACC);
		acceleration.x = _direction.x;
		acceleration.y = _direction.y;
		if (_direction.x != 0 || _direction.y != 0)
		{
			maxVelocity.x = Math.abs(acceleration.x);
			maxVelocity.y = Math.abs(acceleration.y);
			
			angle = Math.atan2(_direction.y, _direction.x) * 180 / 3.14 + 90;
		}
	}
	
	public function shoot(_direction:Point, _team:Int):Void
	{
		if (energy >= Fighter.SHIP_SHOT_COST && shotTimer >= Fighter.SHIP_SHOT_TIMER)
		{
			energy -= Fighter.SHIP_SHOT_COST;
			shotTimer = 0;
			
			_direction.normalize(Fighter.SHOT_SPEED);
			var s:Shot = new Shot(x, y);
			s.velocity.x = _direction.x;
			s.velocity.y = _direction.y;
			
			FlxG.state.add(s);
			
			if (_team & 1 == 1) GlobalGroups.goodShots.add(s);
			if (_team & 2 == 2) GlobalGroups.badShots.add(s);
			
			s.team = _team;
		}
	}
	
	public function setController(_controller):Void
	{
		controller = _controller;
	}
	
	public function getClosestShotManhatten():Shot
	{
		var s:Shot;
		var cs:Shot = null;
		var i:Int = GlobalGroups.goodShots.members.length;
		while (i-->0)
		{
			s = cast GlobalGroups.goodShots.members[i];
			var dx = Math.abs(s.x - x);
			var dy = Math.abs(s.y - y);
			if (cs == null)
				cs = s;
			else 
			{
				var cdx = Math.abs(cs.x - x);
				var cdy = Math.abs(cs.y - y);
				if (dx + dy < cdx + cdy)
				{
					cs = s;
				}
			}
		}
		return cs;
	}
	
	override public function kill():Void 
	{
		controller.unload(this);
		super.kill();
	}
	
	override public function update():Void 
	{
		timeSpentAlive += FlxG.elapsed;
		
		if (energy < Fighter.SHIP_MAX_ENERGY)
		{
			energy += Fighter.SHIP_ENERGY_REGEN * FlxG.elapsed;
		}
		if (energy > Fighter.SHIP_MAX_ENERGY)
		{
			energy = Fighter.SHIP_MAX_ENERGY;
		}
		if (shotTimer < Fighter.SHIP_SHOT_TIMER)
		{
			shotTimer += FlxG.elapsed;
		}
		
		move(new Point());
		
		if (controller != null)
		controller.update(this);
		
		velocity.x -= velocity.x * 0.05 * FlxG.elapsed * 60;
		velocity.y -= velocity.y * 0.05 * FlxG.elapsed * 60;
		super.update();
		
		if (x < 0) x = FlxG.width;
		if (x > FlxG.width) x = 0;
		
		if (y < 0) y = FlxG.height;
		if (y > FlxG.height) y = 0;
	}
}