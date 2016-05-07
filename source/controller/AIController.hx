package controller;
import controller.AIController.AIEntry;
import flash.geom.Point;
import flash.Vector;
import flixel.util.FlxMath;

/**
 * ...
 * @author q
 */

class AIEntry
{
	public var id:String;
	public var dna:Vector<Float>;
	public var fitness:Float;
	
	public function new(_dna:Vector<Float>, _id:String = "_")
	{
		id = _id + AIController.AIID;
		AIController.AIID++;
		dna = _dna;
		fitness = 0;
	}
}
 
class AIController extends Controller
{

	/////////////
	// Genetic AI
	
	public static var AIID:Int;
	public static var database:Map<String, AIEntry>;
	
	public static function init()
	{
		AIID = 0;
		database = new Map<String, AIEntry>();
	}
	
	public static function randRange(_a:Float, _b:Float):Float
	{
		return _a + Math.random() * (_b - _a);
	}
	
	public static function getAI():Vector<Float>
	{
		var ret:Vector<Float> = new Vector<Float>(28);
		//c1~c12;
		var i:Int = 12;
		while (i-->0)
		{
			ret[i] = randRange( -2, 2);
		}
		//e1~e12
		i = 12;
		while (i-->0)
		{
			ret[i + 12] = randRange(0.1, 2);
		}
		
		//extra sensitive to shots
		ret[4] *= 3;
		ret[5] *= 3;
		
		return ret;
	}
	
	public static function generateAIEntry():AIEntry
	{
		var ai:AIEntry = new AIEntry(getAI());
		database.set(ai.id, ai);
		return ai;
	}
	
	
	
	////////////////
	// AI Controller
	
	public var target:Fighter;
	private var mAIEnt:AIEntry;
	private var mAI:Vector<Float>;
	
	public function new() 
	{
		super();
	}
	
	public function setTarget(_target:Fighter):Void
	{
		target = _target;
	}
	
	override public function unload(ene:Fighter):Void 
	{
		AIController.database.get(mAIEnt.id).fitness = ene.timeSpentAlive;
	}
	
	override public function update(ene:Fighter):Void 
	{
		if (target == null)
		return;
		
		var mv:Point = new Point();
		
		var dx:Float = target.x - ene.x;
		var dy:Float = target.y - ene.y;
		var sdx = FlxMath.signOf(dx);
		var sdy = FlxMath.signOf(dy);
		dx = Math.abs(dx);
		dy = Math.abs(dy);
		var svx = FlxMath.signOf(target.velocity.x);
		var svy = FlxMath.signOf(target.velocity.y);
		
		mv.x += mAI[0] * sdx * Math.pow(dx, mAI[0 + 12]);
		mv.x += mAI[1] * sdy * Math.pow(dy, mAI[1 + 12]);
		mv.x += mAI[2] * svx * Math.pow(Math.abs(target.velocity.x), mAI[2 + 12]);
		mv.x += mAI[3] * svy * Math.pow(Math.abs(target.velocity.y), mAI[3 + 12]);
		
		mv.y += mAI[5] * sdx * Math.pow(dx, mAI[5 + 12]);
		mv.y += mAI[6] * sdy * Math.pow(dy, mAI[6 + 12]);
		mv.y += mAI[7] * svx * Math.pow(Math.abs(target.velocity.x), mAI[7 + 12]);
		mv.y += mAI[8] * svy * Math.pow(Math.abs(target.velocity.y), mAI[8 + 12]);
		
		var s:Shot = ene.getClosestShotManhatten();
		if (s != null)
		{
			var shdx:Float = s.x - ene.x;
			var shdy:Float = s.y - ene.y;
			var sshdx = FlxMath.signOf(shdx);
			var sshdy = FlxMath.signOf(shdy);
			shdx = Math.abs(shdx);
			shdy = Math.abs(shdy);
			mv.x += mAI[4] * sshdx * Math.pow(shdx, mAI[4 + 12]);
			mv.x += mAI[5] * sshdy * Math.pow(shdy, mAI[5 + 12]);
			mv.y += mAI[10] * sshdx * Math.pow(shdx, mAI[10 + 12]);
			mv.y += mAI[11] * sshdy * Math.pow(shdy, mAI[11 + 12]);
		}
		
		ene.move(mv);
	}
	
	public function setAI(generateAIEntry:AIEntry) 
	{
		mAIEnt = generateAIEntry;
		mAI = mAIEnt.dna;
	}
	
}