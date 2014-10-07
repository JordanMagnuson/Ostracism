package loneliness.game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import loneliness.rooms.MainWorld;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.utils.Input;
	
	public class Other extends PolarMover
	{
		public static const SCARE_RADIUS:Number = 100;	// 40
		public static const INFLUENCE_RADIUS:Number = 100; // 40 If a wanderer gets within this distance of another type, it will become that type		
		public static const FREEZE_RADIUS:Number = 150;	// Like SCARE_RADIUS, but for alienation condition (5)
		public static const CLUSTER_RADIUS:Number = 150; // Like SCARE_RADIUS, but For 'circle the wagons' condition (6).
		
		// Smothering
		public static const SHOULD_SMOTHER_RADIUS:Number = 150;
		public static const SMOTHER_MIN_RADIUS:Number = 100;
		public static const SMOTHER_MAX_RADIUS:Number = 150;
		
		// Inclusion
		public static const SHOULD_INCLUDE_RADIUS:Number = 100;
		public static const INCLUDE_INFLUENCE_RADIUS:Number = 0;
		//public static const INCLUDE_MOVE_WAIT:Number = FP.random * 0.1;
		//public var includeAlarm:Alarm = new Alarm(INCLUDE_MOVE_WAIT, includePlayer);
		
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
		public var mode:String = '';
		
		
		/**
		 * Graphic
		 */
		//[Embed(source='../../../assets/loneliness/gfx/other.png')] private const S_OTHER:Class;
		//public var image:Image = new Image(S_OTHER);			
		public var image:Image = Image.createRect(12, 12, Colors.BLACK);
		
		public function Other(x:Number = 0, y:Number = 0, mode:String = '') 
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
			this.mode = mode;
		}
		
		override public function added():void {
			//if (SuperGlobal.ostracismCondition == 3) {
				//addTween(includeAlarm, true);
			//}
		}
		
		/**
		 * Update the other.
		 */		
		override public function update():void 
		{
			if (offScreen())
				FP.world.remove(this);
				
			if (this.mode == 'player') {
				if (Input.check("U") || Input.check("D") || Input.check("L") || Input.check("R")) {
					FP.world.add(MainWorld.player = new Player(x, y));
					FP.world.remove(this);
				}
			}
				
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
				
				// Inclusion
				case 3:
					if (distanceFrom(MainWorld.player) <= SHOULD_INCLUDE_RADIUS && this.mode != 'including' && this.mode != 'player' && this.mode != 'smothering') {
						this.mode = 'including';
						includePlayer();
					}			
					break;
				// Smothering
				case 4:
					if (distanceFrom(MainWorld.player) <= SHOULD_SMOTHER_RADIUS && this.mode != 'smothering') {
						smother();
					}		
					break;
				// Alienation
				case 5:
					if (distanceFrom(MainWorld.player) <= FREEZE_RADIUS && this.type != 'frozen') {
						freeze();
					}
					break;		
				// Circle the wagons
				case 6:
					if (distanceFrom(MainWorld.player) <= CLUSTER_RADIUS && this.mode != 'clustered') {
						cluster();
					}
					break;							
			}

			if (this.mode == 'smothering' && distanceFrom(MainWorld.player) > SMOTHER_MAX_RADIUS) {
				smother();
			}			
			
			move(speed * FP.elapsed, direction);	
		}				
		
		public function setSpdMax():void
		{
			spdMax = ((y / MainWorld.height) * (SPEED_MAX * (2 / 3))) + (SPEED_MAX * (1 / 3));
		}		
		
		//public function tellNearbyToSmother():void {
			//var toInfluence:Array = [];
			//FP.world.collideRectInto('other', x - SMOTHER_MAX_RADIUS, y - SMOTHER_MAX_RADIUS, SMOTHER_MAX_RADIUS * 2, SMOTHER_MAX_RADIUS * 2, toInfluence);
//
			//for each (var other:Other in toInfluence) {
				//other.shouldSmother = true;			
			//}
		//}
		
		public function smother():void {
			this.type = 'to_smother';
			FP.world.remove(this);
			FP.world.add(new SmotherChaser(this.x, this.y, this.getClass()));			
		}
		
		public function includePlayer():void {
			if (this.mode == 'including') {
				this.type = 'to_include';
				FP.world.remove(this);
				FP.world.add(new InclusionChaser(this.x, this.y, this.getClass()));
			}
		}
		
		public function cluster():void {
			this.type = 'to_cluster';
			FP.world.remove(this);
			FP.world.add(new Clusterer(this.x, this.y, this.getClass()));				
		}
		
		public function leave():void
		{
			this.type = 'to_leave';
			FP.world.remove(this);
			FP.world.add(new Leaving(this.x, this.y));
		}
		
		public function freeze():void
		{
			this.type = 'to_freeze';
			FP.world.remove(this);
			FP.world.add(new Frozen(this.x, this.y));
			freezeNearby();
		}		
		
		public function freezeNearby():void
		{
			trace('freeze nearby');
			var toFreeze:Array = [];
			FP.world.collideRectInto('other', x - FREEZE_RADIUS, y - FREEZE_RADIUS, FREEZE_RADIUS * 2, FREEZE_RADIUS * 2, toFreeze);

			for each (var other:Other in toFreeze)
				other.freeze();
		}				
		
		public function loseInterest():void 
		{
			// LostInterest = same as Leaver, except does not scare nearby.
			this.type = 'to_lose_interest';
			FP.world.remove(this);
			FP.world.add(new LostInterest(this.x, this.y));			
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