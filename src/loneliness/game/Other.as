package loneliness.game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import loneliness.rooms.MainWorld;
	
	public class Other extends PolarMover
	{
		public static const SCARE_RADIUS:Number = 100;	// 40
		public static const INFLUENCE_RADIUS:Number = 100; // 40 If a wanderer gets within this distance of another type, it will become that type		
		
		
		public static const SHOULD_SMOTHER_RADIUS:Number = 200;
		public static const SMOTHER_MIN_RADIUS:Number = 100;
		public static const SMOTHER_MAX_RADIUS:Number = 200;
		
		/**
		 * Movement constants.
		 */
		public static const SPEED_MAX:Number = 200;	//140
		
		/**
		 * Movement properties.
		 */
		public var spdMax:Number = 0;	
		public var speed:Number = 0; 
		public var direction:int = 0;		
		
		/**
		 * OstracismCondition properties
		 */
		public var shouldSmother:Boolean = false;
		public var smothering:Boolean = false;
		public var chasing:Boolean = false;
		
		
		/**
		 * Graphic
		 */
		//[Embed(source='../../../assets/loneliness/gfx/other.png')] private const S_OTHER:Class;
		//public var image:Image = new Image(S_OTHER);			
		public var image:Image = Image.createRect(12, 12, Colors.BLACK);
		
		public function Other(x:Number = 0, y:Number = 0) 
		{
			super(x, y);
			
			type = 'other';
			layer = 0;
			
			graphic = image;			
			
			//image.originX = image.width / 2;
			//image.originY = image.height / 2;
			//image.x = -image.originX;
			//image.y = -image.originY;	
			
			image.centerOO();
			setHitbox(image.width, image.height, image.originX, image.originY);	
			
			setSpdMax();
		}
		
		/**
		 * Update the other.
		 */		
		override public function update():void 
		{
			if (offScreen())
				FP.world.remove(this);
				
			switch (SuperGlobal.ostracismCondition) {
				
				// Ostracism
				case 1:
					if (distanceFrom(MainWorld.player) <= SCARE_RADIUS) {
						leave();
					}
					break;
					
				// Indifference
				case 2:
					break;
					
				// Smothering
				case 4:
					if (distanceFrom(MainWorld.player) <= SHOULD_SMOTHER_RADIUS && !this.shouldSmother) {
						this.shouldSmother = true;
						this.tellNearbyToSmother();
					}		
					if (distanceFrom(MainWorld.player) <= SMOTHER_MIN_RADIUS) {
						this.smothering = true;					
					}
					else if (distanceFrom(MainWorld.player) > SMOTHER_MAX_RADIUS) {
						this.smothering = false;
					}
					//else if (FP.random < 0.02) {
						//this.smothering = false;
					//}
					break;
			}

			move(speed * FP.elapsed, direction);	
		}				
		
		public function setSpdMax():void
		{
			spdMax = ((y / MainWorld.height) * (SPEED_MAX * (2 / 3))) + (SPEED_MAX * (1 / 3));
		}		
		
		public function tellNearbyToSmother():void {
			var toInfluence:Array = [];
			FP.world.collideRectInto('other', x - SMOTHER_MAX_RADIUS, y - SMOTHER_MAX_RADIUS, SMOTHER_MAX_RADIUS * 2, SMOTHER_MAX_RADIUS * 2, toInfluence);

			for each (var other:Other in toInfluence) {
				other.shouldSmother = true;			
			}
		}
		
		public function smother():void {
			
		}
		
		public function leave():void
		{
			trace('leave');
			this.type = 'to_leave';
			FP.world.remove(this);
			FP.world.add(new Leaving(this.x, this.y));
		}
		
		public function offScreen():Boolean
		{
			if (y  > MainWorld.height + height / 2 || y  < -height / 2)
				return true;
			else if (x  > MainWorld.width + width / 2 || x  < -width / 2)
				return true;
			else
				return false;
		}
		
		public function destroy():void
		{
			FP.world.remove(this);
		}	
		
	}

}