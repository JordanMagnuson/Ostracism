package loneliness.game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.tweens.motion.CircularMotion;
	import net.flashpunk.FP;
	import loneliness.rooms.MainWorld;

	public class Orbiter extends Other
	{
		
		public var orbitCenter:Entity;
		public var clockWise:Boolean;
		
		public var motionTween:CircularMotion = new CircularMotion(continueOrbit);
		
		public function Orbiter(x:Number = 0, y:Number = 0, mode:String = '') 
		{
			super(x, y, mode);
			setSpdMax();
			speed = (spdMax / 2) + (FP.random * spdMax / 2);	
		}
		
		override public function added():void
		{
			// Can't do this in the constructor, because there are no center guides yet			
			if (mode == 'smothering') {
				orbitCenter = MainWorld.player;
				this.clockWise = FP.choose(true, false);
			}
			else {
				orbitCenter = (FP.world.nearestToEntity('orbiter_center', this) as Entity);		
				this.clockWise = (orbitCenter as OrbiterCenter).clockWise;
			}
			
			motionTween.setMotionSpeed(orbitCenter.x, orbitCenter.y, distanceFrom(orbitCenter), getAngle(), this.clockWise, speed);
			FP.world.addTween(motionTween, true);
		}
		
		override public function update():void 
		{
			super.update();
			
			x = motionTween.x;
			y = motionTween.y;				
		}
		
		public function continueOrbit():void
		{
			motionTween.setMotionSpeed(orbitCenter.x, orbitCenter.y, distanceFrom(orbitCenter), getAngle(), this.clockWise, speed);
		}	
		
		public function getAngle():Number
		{
			return pointDirection(orbitCenter.x, orbitCenter.y, x, y);
		}
	}

}