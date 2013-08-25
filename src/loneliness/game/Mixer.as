package loneliness.game 
{
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import loneliness.rooms.MainWorld;

	public class Mixer extends Other
	{
		public static const MIN_RADIUS:Number = 50;
		public static const MAX_RADIUS:Number = 200;
		
		public var mixCenter:Entity;
		public var radius:Number;
		
		public function Mixer(x:Number, y:Number, mode:String = '') 
		{
			super(x, y, mode);
			direction = FP.rand(360);
			setSpdMax();
			speed = (spdMax / 2) + (FP.random * spdMax / 2);
		}
		
		override public function added():void
		{
			// Can't do this in the constructor, because there are no center guides yet
			if (mode == 'smothering') {
				//mixCenter = FP.world.add(new MixerCenter(MainWorld.player.x, MainWorld.player.y));
				mixCenter = MainWorld.player;
				radius = MIN_RADIUS + FP.random * (MAX_RADIUS - MIN_RADIUS);
			}
			else {
				mixCenter = (FP.world.nearestToEntity('mixer_center', this) as MixerCenter);
				radius = distanceFrom(mixCenter);
			}
		}
		
		override public function update():void
		{
			super.update();
			if (distanceFrom(mixCenter) >= radius)
			{
				direction = pointDirection(x, y, mixCenter.x, mixCenter.y);
			}
			
			// Smothering condition
			//if (this.shouldSmother && !this.smothering) {
				//mixCenter = (FP.world.nearestToEntity('player', this) as Entity);
			//}
			//else if (FP.random < 0.02) {
				//setSpdMax();
				//speed = (spdMax / 2) + (FP.random * spdMax / 2);
				//mixCenter = FP.world.add(new MixerCenter(MainWorld.player.x, MainWorld.player.y));
				//mixCenter = (FP.world.nearestToEntity('player', this) as Entity);
				//radius = distanceFrom(mixCenter);				
			//}			
		}
	}

}