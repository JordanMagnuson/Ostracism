package loneliness.game 
{
	import loneliness.rooms.MainWorld;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SmotherChaser extends Other
	{
		
		public function SmotherChaser(x:Number = 0, y:Number = 0, transformInto:Class) 
		{
			super(x, y);
			type = 'smother_chaser';
			direction = pointDirection(x, y, MainWorld.player.x, MainWorld.player.y)	
			setSpdMax();
			speed = (spdMax / 2) + (FP.random * spdMax / 2);
		}
		
		override public function update():void
		{
			
		}		
		
	}

}