package loneliness.game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.utils.Input;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import loneliness.rooms.MainWorld;
	import loneliness.rooms.MessageScreen;

	public class Player extends Moveable
	{
		
		/**
		 * Movement constants.
		 */
		public const SPEED_MAX:Number = 100;	//70 100
		public const ACCEL:Number = 800;
		public const DRAG:Number = 800;
		
		// Inclusion
		public const INCLUSION_MIN_DISTANCE_TO_JOIN:Number = 100;
		
		/**
		 * Movement properties.
		 */
		public var spdMax:Number = 0;
		public var spdX:Number = 0;
		public var spdY:Number = 0;		
		
		/**
		 * Player graphic
		 */
		//[Embed(source='../../../assets/loneliness/gfx/player.png')] private const S_PLAYER:Class;
		//public var image:Image = new Image(S_PLAYER);	
		public var image:Image = Image.createRect(12, 12, Colors.BLACK);
		public var colorNum:Number = 0;
		
		public function Player(x:Number = 0, y:Number = 0) 
		{
			this.x = x;
			this.y = y;
			//y = MainWorld.height - 700;
			
			type = "player";
			graphic = image;
			layer = 0;
			this.image.color = Colors.BLACK;
			
			//image.originX = image.width / 2;
			//image.originY = image.height / 2;
			//image.x = -image.originX;
			//image.y = -image.originY;	
			
			image.centerOO();
			
			setHitbox(image.width, image.height, image.originX, image.originY);	
		}
		
		/**
		 * Update the player.
		 */		
		override public function update():void 
		{
			// Inclusion condition
			if (SuperGlobal.ostracismCondition ==  3) {
				checkInclusion();
			}
			setSpdMax();
			acceleration();
			move(spdX * FP.elapsed, spdY * FP.elapsed);	
			if (y <= 400)
			{
				FP.world.remove(this);
				//FP.world.add(new ChildrenAndText);
				FP.world = new MessageScreen;
			}
			
			if (Input.pressed(Key.R)) 
			{
				switch(colorNum) {
					case 0:
						this.image.color = Colors.BLOOD_RED;
						colorNum++;
						break;
					case 1: 
						this.image.color = Colors.DARK_BROWN;
						colorNum++;
						break;
					default:
						this.image.color = Colors.BLACK;
						colorNum = 0;
						break;
				}
				//this.image.color = Colors.BLOOD_RED;
			}		
			if (Input.pressed(Key.B)) 
			{
				this.image.color = Colors.BLACK;
			}	
			if (Input.pressed(Key.E)) 
			{
				this.image.color = Colors.FOREST_BROWN;
			}	
		}		
		
		public function checkInclusion():void {
			if (Input.check("U") || Input.check("D") || Input.check("L") || Input.check("R")) {
				return;		
			}
			
			var nearestOther:Other = (FP.world.nearestNotFollowing('other', this) as Other);
			if (distanceFrom(nearestOther) <= INCLUSION_MIN_DISTANCE_TO_JOIN) {
				var transformInto:Class = nearestOther.getClass();
				trace('nearest other: ' + nearestOther);
				FP.world.add(MainWorld.player = new transformInto(x, y, 'player') as Other);
				FP.world.remove(this);
			}
		}	
		
		/**
		 * Speed
		 */
		private function setSpdMax():void
		{
			//spdMax = ((y / MainWorld.height) * (SPEED_MAX * (2 / 3))) + (SPEED_MAX * (1 / 3));
			spdMax = ((y / MainWorld.height) * (SPEED_MAX * (1 / 3))) + (SPEED_MAX * (2 / 3));
		}
		
		/**
		 * Accelerates the player based on input.
		 */
		private function acceleration():void
		{
			// evaluate input
			var accelX:Number = 0;
			var accelY:Number = 0;
			if (y <= FP.screen.height * 2.5)	// Force player up at end of game
			{
				accelY -= ACCEL;
			}
			else
			{
				if (Input.check("U")) accelY -= ACCEL;
				if (Input.check("D")) accelY += ACCEL;
				if (Input.check("L")) accelX -= ACCEL;				
				if (Input.check("R")) accelX += ACCEL;		
			}
			
			// handle acceleration
			if (accelX != 0)
			{
				if (accelX > 0)
				{
					// accelerate right
					if (spdX < spdMax)
					{
						spdX += accelX * FP.elapsed;
						if (spdX > spdMax) spdX = spdMax;
					}
					else accelX = 0;
				}
				else
				{
					// accelerate left
					if (spdX > -spdMax)
					{
						spdX += accelX * FP.elapsed;
						if (spdX < -spdMax) spdX = -spdMax;
					}
					else accelX = 0;
				}
			}
			if (accelY != 0)
			{
				if (accelY > 0)
				{
					// accelerate right
					if (spdY < spdMax)
					{
						spdY += accelY * FP.elapsed;
						if (spdY > spdMax) spdY = spdMax;
					}
					else accelY = 0;
				}
				else
				{
					// accelerate left
					if (spdY > -spdMax)
					{
						spdY += accelY * FP.elapsed;
						if (spdY < -spdMax) spdY = -spdMax;
					}
					else accelY = 0;
				}
			}		
			
			// handle decelleration
			if (accelX == 0)
			{
				if (spdX > 0)
				{
					spdX -= DRAG * FP.elapsed;
					if (spdX < 0) spdX = 0;
				}
				else
				{
					spdX += DRAG * FP.elapsed;
					if (spdX > 0) spdX = 0;
				}
			}
			if (accelY == 0)
			{
				if (spdY > 0)
				{
					spdY -= DRAG * FP.elapsed;
					if (spdY < 0) spdY = 0;
				}
				else
				{
					spdY += DRAG * FP.elapsed;
					if (spdY > 0) spdY = 0;
				}
			}			
		}			
		
	}

}