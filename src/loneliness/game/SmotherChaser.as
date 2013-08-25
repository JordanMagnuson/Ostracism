package loneliness.game 
{
	import loneliness.rooms.MainWorld;
	import net.flashpunk.FP;
	import net.flashpunk.tweens.misc.Alarm;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SmotherChaser extends Other
	{
		public const TURN_TO_PLAYER_TIME:Number = 1 + (FP.random * 2);
		
		public var transformInto:Class;
		public var turnToPlayerAlarm:Alarm = new Alarm(TURN_TO_PLAYER_TIME, turnToPlayer);
		
		public function SmotherChaser(x:Number = 0, y:Number = 0, transformInto:Class = null) 
		{
			super(x, y);
			type = 'smother_chaser';
			direction = pointDirection(x, y, MainWorld.player.x, MainWorld.player.y);	
			setSpdMax();
			speed = (spdMax / 2) + (FP.random * spdMax / 2);
			this.transformInto = transformInto;
		}
		
		override public function added():void 
		{
			tellNearbyToSmother();
			addTween(turnToPlayerAlarm, true);
		}
		
		override public function update():void
		{
			if (distanceFrom(MainWorld.player) <= SMOTHER_MIN_RADIUS && FP.random < 0.02) {
				FP.world.remove(this);
				FP.world.add(new transformInto(x, y, 'smothering'));
			}					
			
			move(speed * FP.elapsed, direction);
		}		
		
		public function turnToPlayer():void 
		{
			direction = pointDirection(x, y, MainWorld.player.x, MainWorld.player.y);
			turnToPlayerAlarm.reset(TURN_TO_PLAYER_TIME);
		}
		
		public function tellNearbyToSmother():void 
		{
			var toInfluence:Array = [];
			FP.world.collideRectInto('other', x - SMOTHER_MIN_RADIUS, y - SMOTHER_MIN_RADIUS, SMOTHER_MIN_RADIUS * 2, SMOTHER_MIN_RADIUS * 2, toInfluence);

			for each (var other:Other in toInfluence) {
				if (other.mode != 'smothering') {
					other.smother();
				}
			}
		}		
		
	}

}