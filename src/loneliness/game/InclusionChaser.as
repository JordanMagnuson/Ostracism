package loneliness.game 
{
	import loneliness.rooms.MainWorld;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.tweens.misc.Alarm;
	import Math;
	
	/**
	 * ...
	 * @author ...
	 */
	public class InclusionChaser extends Other
	{
		public static const TRANSFORM_BACK_TIME:Number = 2;
		public static const SIT_TIME:Number = 0.3;
		
		public var sitting:Boolean = false;
		public var transformInto:Class;
		public var transformBackAlarm:Alarm = new Alarm(TRANSFORM_BACK_TIME, transformBack);
		public var sitAlarm:Alarm = new Alarm(SIT_TIME, sit);
		
		public function InclusionChaser(x:Number = 0, y:Number = 0, transformInto:Class = null) 
		{
			super(x, y);
			type = 'inclusion_chaser';
			direction = pointDirection(x, y, MainWorld.player.x, MainWorld.player.y);	
			setSpdMax();
			speed = (spdMax / 2) + (FP.random * spdMax / 2) / 10;
			this.transformInto = transformInto;
		}
		
		override public function added():void 
		{
			// Chance of including, or just ignoring
			if (FP.random < 0.8) {
				tellNearbyToInclude();
				addTween(sitAlarm, true);
			}
			else {
				sit();
			}
		}
		
		override public function update():void
		{
			if (sitting) {
				speed = 0;
			}
			move(speed * FP.elapsed, direction);
		}		
		
		public function transformBack():void {
			trace('chance of following: ' + SuperGlobal.inclusionChaserChanceOfFollowing);
			if (SuperGlobal.inclusionFollowers < SuperGlobal.MAX_FOLLOWERS && FP.random <= SuperGlobal.inclusionChaserChanceOfFollowing) {
				this.type = 'to_smother';
				FP.world.remove(this);
				FP.world.add(new SmotherChaser(this.x, this.y, this.transformInto));		
				SuperGlobal.inclusionChaserChanceOfFollowing -= SuperGlobal.CHANCE_OF_FOLLOWING_CHANGE;
				SuperGlobal.inclusionFollowers++;
				trace('followers: ' + SuperGlobal.inclusionFollowers);
			}
			else {
				FP.world.remove(this);
				var newMode:String = FP.choose('', '', 'including');
				FP.world.add(new transformInto(x, y, newMode));
			}
		}
		
		public function sit():void {
			sitting = true;
			addTween(transformBackAlarm, true);
		}
		
		//public function turnToPlayer():void 
		//{
			//if (distanceFrom(MainWorld.player) > SMOTHER_MIN_RADIUS) {
				//direction = pointDirection(x, y, MainWorld.player.x, MainWorld.player.y);
			//}
			//turnToPlayerAlarm.reset(TURN_TO_PLAYER_TIME);
		//}
		
		public function tellNearbyToInclude():void 
		{
			var toInfluence:Array = [];
			FP.world.collideRectInto('other', x - INCLUDE_INFLUENCE_RADIUS, y - INCLUDE_INFLUENCE_RADIUS, INCLUDE_INFLUENCE_RADIUS * 2, INCLUDE_INFLUENCE_RADIUS * 2, toInfluence);

			//var other:Other = (FP.world.nearestToEntity('other', this as Entity) as Other);
			//if (other.mode != 'including')
				//other.includePlayer();
			
			for each (var other:Other in toInfluence) {
				if (other.mode != 'including' && other.mode != 'player' && Math.random() < 0.5) {
					other.mode = 'including';
					other.includePlayer();
					//other.addTween(includeAlarm, true);
				}
			}
		}		
		
	}

}