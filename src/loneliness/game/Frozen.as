package loneliness.game 
{
	import loneliness.rooms.MainWorld;
	import net.flashpunk.FP;
	
	public class Frozen extends Other
	{
		
		public function Frozen(x:Number = 0, y:Number = 0, mode:String = '') 
		{
			super(x, y, mode);
			type = 'frozen';
		}
		
		override public function update():void
		{
			super.update();

			//if (this.shouldSmother && !this.smothering) {
				//direction = pointDirection(x, y, MainWorld.player.x, MainWorld.player.y)	
				//setSpdMax();
				//speed = (spdMax / 2) + (FP.random * spdMax / 2);
			//}
			//else if (this.smothering && SMOTHER_MIN_RADIUS * FP.random > distanceFrom(MainWorld.player)) {
			//else if (this.smothering && FP.random < 0.02) {
				//speed = 0;
			//}
		}		
		
	}

}