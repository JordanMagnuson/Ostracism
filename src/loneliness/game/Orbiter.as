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
		
		public function Orbiter(x:Number, y:Number) 
		{
			super(x, y);
			setSpdMax();
			speed = (spdMax / 2) + (FP.random * spdMax / 2);	
		}
		
		override public function added():void
		{
			// Can't do this in the constructor, because there are no center guides yet
			orbitCenter = (FP.world.nearestToEntity('orbiter_center', this) as Entity);		
			this.clockWise = (orbitCenter as OrbiterCenter).clockWise;
			
			
			motionTween.setMotionSpeed(orbitCenter.x, orbitCenter.y, distanceFrom(orbitCenter), getAngle(), this.clockWise, speed);
			FP.world.addTween(motionTween, true);
		}
		
		override public function update():void 
		{
			super.update();
			
			// Smothering condition
			if (this.shouldSmother && !this.smothering && !this.chasing) {
				trace('boop');
				direction = pointDirection(x, y, MainWorld.player.x, MainWorld.player.y);	
				setSpdMax();
				speed = (spdMax / 2) + (FP.random * spdMax / 2);
				this.chasing = true;
				//FP.world.removeTween(motionTween);
			}			
			else if (this.smothering && this.chasing && FP.random < 0.1) {
				trace('beep');
				orbitCenter = (FP.world.nearestToEntity('player', this) as Entity);
				motionTween.setMotionSpeed(orbitCenter.x, orbitCenter.y, distanceFrom(orbitCenter), getAngle(), this.clockWise, speed);
				//FP.world.addTween(motionTween, true);
				this.chasing = false;
			}
			else if (this.chasing) {
				direction = pointDirection(x, y, MainWorld.player.x, MainWorld.player.y);	
				setSpdMax();
				speed = (spdMax / 2) + (FP.random * spdMax / 2);				
			}
			else {
				x = motionTween.x;
				y = motionTween.y;				
			}
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