package loneliness.game 
{
	import net.flashpunk.FP;
	import loneliness.rooms.MainWorld;

	public class Marcher extends Other
	{
		public var avoidingPlayer:Boolean = false;
		
		public function Marcher(x:Number, y:Number, mode:String = '') 
		{
			super(x, y, mode);
			direction = FP.choose(0, 180);
			setSpdMax();
			speed = (spdMax / 2) + (FP.random * spdMax / 2);
		}
		
		override public function update():void
		{
			super.update();
			
			// For 'circle the wagons' condition, we want these guys to keep going,
			// but avoid the player.
			if (SuperGlobal.ostracismCondition == 6) {
				if (distanceFrom(MainWorld.player) < CLUSTER_RADIUS) {
					if (x > CLUSTER_RADIUS && direction == 0 && x >= MainWorld.player.x - CLUSTER_RADIUS && !avoidingPlayer) {
						direction = 180;
						avoidingPlayer = true;
					}
					else if (x < MainWorld.width - CLUSTER_RADIUS && direction == 180 && x <= MainWorld.player.x + CLUSTER_RADIUS && !avoidingPlayer) {
						direction = 0;
						avoidingPlayer = true;
					}
				}
			}
			// Normal behavior for other conditions (only turn at sides of screen).
			if (x <= image.width / 2) {
				direction = 0;
				avoidingPlayer = false;
			}
			else if (x >= MainWorld.width - image.width / 2) {
				direction = 180;
				avoidingPlayer = false;
			}
				
			//if (this.shouldSmother && !this.smothering) {
				//direction = pointDirection(x, y, MainWorld.player.x, MainWorld.player.y)	
				//setSpdMax();
				//speed = (spdMax / 2) + (FP.random * spdMax / 2);				
			//}
		}
		
	}

}