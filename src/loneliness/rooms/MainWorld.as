package loneliness.rooms 
{
	import flash.utils.Dictionary;
	import loneliness.game.Background;
	import loneliness.game.FadeOut;
	import loneliness.game.InclusionChaser;
	import loneliness.game.Jumper;
	import loneliness.game.Marcher;
	import loneliness.game.Mixer;
	import loneliness.game.MixerCenter;
	import loneliness.game.Moveable;
	import loneliness.game.Orbiter;
	import loneliness.game.OrbiterCenter;
	import loneliness.game.Other;
	import loneliness.game.Player;
	import loneliness.game.Sitter;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Input;
	import flash.ui.Mouse;
	import punk.transition.Transition;
	import net.flashpunk.utils.Key;
	
	public class MainWorld extends World
	{
		/**
		 * Size of the level (so it knows where to keep the player + camera in).
		 */
		public static var width:uint;
		public static var height:uint;		
		
		public static var player:Entity;	
		
		public static var timer:Alarm;
		
		/**
		 * This variable keeps track of the target ostracism condition, if we set START_INCLUSION_FOR_15_SECONDS.
		 */
		public static var targetOstracismCondition:Number;
		public static var conditionChangeTimer:Alarm;
		
		/**
		 * The loading XML file.
		 */
		public var level:XML;		
		
		/**
		 * Level XML.
		 */
		[Embed(source='../../../assets/loneliness/levels/MainLevel2.oel', mimeType='application/octet-stream')] private static const LEVEL:Class;		
		
		/**
		 * Camera following information.
		 */
		public const FOLLOW_TRAIL:Number = 0;
		public const FOLLOW_RATE:Number = 1;	
		
		/**
		 * Sound
		 */
		[Embed(source='../../../assets/loneliness/sound/Sounds.swf', symbol='blue_paint_loop.mp3')] public static const MUSIC:Class;
		public static var music:Sfx = new Sfx(MUSIC);				
		
		public function MainWorld() 
		{			
			width = FP.width;
			height = 16000;	
			loadLevel(LEVEL);		
			
			Input.define("U", Key.UP, Key.W);
			Input.define("D", Key.DOWN, Key.S);			
			Input.define("L", Key.LEFT, Key.A);	
			Input.define("R", Key.RIGHT, Key.D);				
		}
		
		override public function begin():void
		{
			var playerX:Number = FP.screen.width / 2;
			var playerY:Number = MainWorld.height - 50;	
			//playerY = MainWorld.height - 1000;
			add(player = new Player(playerX, playerY));
			
			if (SuperGlobal.MUSIC) {
				music.loop();
			}
			
			//FP.world = new MessageScreen;
			
			Mouse.hide();
			
			// Fade out timer
			if (SuperGlobal.FADE_OUT_TIME > 0) {
				timer = new Alarm(SuperGlobal.FADE_OUT_TIME, fadeOut);
				addTween(timer, true);
			}
			
			// Inclusion condition timer.
			if (SuperGlobal.START_INCLUSION_FOR_X_SECONDS > 0) {
				targetOstracismCondition = SuperGlobal.ostracismCondition;
				trace('yep want change to ' + targetOstracismCondition);
				SuperGlobal.ostracismCondition = 3;
				conditionChangeTimer = new Alarm(SuperGlobal.START_INCLUSION_FOR_X_SECONDS, changeConditionToTarget);
				addTween(conditionChangeTimer, true);
			}
			
			// Background
			if (SuperGlobal.SHOW_BACKGROUND) {
				add(new Background(0, 0));
			}
			
			//player.y = FP.height - FP.screen.height * 5;
			//player.y = 1300;
		}
		
		/**
		 * Update the world.
		 */
		override public function update():void 
		{			
			// Start Over
			//if (Input.pressed(SuperGlobal.RETURN_KEY)) 
			//{
				// Clear tweens (eg fading sounds, FP.alarm, etc.)
				//FP.tweener.clearTweens();
				//SuperGlobal.reset();
				//FP.world = new MainWorld;
			//}			
			
			if (SuperGlobal.ALLOW_ADMIN_KEYS) {
				// Change ostracism conditon and restart
				if (Input.pressed(Key.DIGIT_1)) 
				{
					// Clear tweens (eg fading sounds, FP.alarm, etc.)
					FP.tweener.clearTweens();
					SuperGlobal.inclusionChaserChanceOfFollowing = SuperGlobal.CHANCE_OF_FOLLOWING_INITIAL;
					SuperGlobal.inclusionFollowers = 0;
					SuperGlobal.ostracismCondition = 1;
					FP.world = new MainWorld;
				}					
				else if (Input.pressed(Key.DIGIT_2)) 
				{
					// Clear tweens (eg fading sounds, FP.alarm, etc.)
					FP.tweener.clearTweens();
					SuperGlobal.inclusionChaserChanceOfFollowing = SuperGlobal.CHANCE_OF_FOLLOWING_INITIAL;
					SuperGlobal.inclusionFollowers = 0;
					SuperGlobal.ostracismCondition = 2;
					FP.world = new MainWorld;
				}			
				else if (Input.pressed(Key.DIGIT_3)) 
				{
					// Clear tweens (eg fading sounds, FP.alarm, etc.)
					FP.tweener.clearTweens();
					SuperGlobal.inclusionChaserChanceOfFollowing = SuperGlobal.CHANCE_OF_FOLLOWING_INITIAL;
					SuperGlobal.inclusionFollowers = 0;
					SuperGlobal.ostracismCondition = 3;
					FP.world = new MainWorld;
				}		
				else if (Input.pressed(Key.DIGIT_4)) 
				{
					// Clear tweens (eg fading sounds, FP.alarm, etc.)
					FP.tweener.clearTweens();
					SuperGlobal.inclusionChaserChanceOfFollowing = SuperGlobal.CHANCE_OF_FOLLOWING_INITIAL;
					SuperGlobal.inclusionFollowers = 0;
					SuperGlobal.ostracismCondition = 4;
					FP.world = new MainWorld;
				}			
			}
			
			// update entities
			super.update();
			
			// Camera
			cameraFollow();
			
			// camera following
			//if (classCount(Player) > 0)
			//{
				//trace('not finished');
				//cameraFollow();
			//}
			//else
				//trace('finished');
		}		
		
		public function changeConditionToTarget():void
		{
			trace('yep changing to target');
			SuperGlobal.ostracismCondition = targetOstracismCondition;
			if (SuperGlobal.ostracismCondition != 3 && SuperGlobal.ostracismCondition != 4) {
				// Don't remove followers if we are switching to inclusion or smothering.
				removeFollowers();
			}
		}
		
		/**
		 * Removes followers (mode = 'smothering') from player.
		 */
		public function removeFollowers():void 
		{
			var others:Array = [];
			FP.world.getType('other', others);
			FP.world.getType('to_smother', others);
			FP.world.getType('smother_chaser', others);
			for each (var other:Other in others)
			{
				// Mode is used to tell what the other is actually up to (since they switch backa and forth between type: eg inclusionChaser to sitter).
				// "Friends" that are following the player (inclusion condition) actually have mode = smothering.
				if (other.type == 'smother_chaser' || other.mode == 'smothering') {
					//trace('telling to leave');				
					switch (SuperGlobal.ostracismCondition) {
						// Ostracism
						case 1:
							other.leave();
							break;	
						// Indifference
						case 2:
							other.loseInterest();
							break;
					}
				}
			}
		}
		
		public function fadeOut():void
		{
			add(new FadeOut(ClickNextScreen, Colors.BLACK, 3));
		}
		
		public function endGame():void
		{
			FP.tweener.clearTweens();
			SuperGlobal.reset();
			FP.world = new MessageScreen;
		}
		
		/**
		 * Render the world.
		 */
		override public function render():void 
		{
			// render the backdrops
			//FP.buffer.draw(BG);
			
			// render the world
			super.render();
		}				
		
		/**
		 * Makes the camera follow the player object.
		 */
		private function cameraFollow():void
		{
			// make camera follow the player
			FP.point.x = FP.camera.x - targetX;
			FP.point.y = FP.camera.y - targetY;
			var dist:Number = FP.point.length;
			if (dist > FOLLOW_TRAIL) dist = FOLLOW_TRAIL;
			FP.point.normalize(dist * FOLLOW_RATE);
			FP.camera.x = int(targetX + FP.point.x);
			FP.camera.y = int(targetY + FP.point.y);
			
			// keep camera in room bounds
			FP.camera.x = FP.clamp(FP.camera.x, 0, width - FP.width);
			FP.camera.y = FP.clamp(FP.camera.y, 0, height - FP.height);
		}
		
		/**
		 * Getter functions used to get the position to place the camera when following the player.
		 */
		private function get targetX():Number { return player.x - FP.width / 2; }
		private function get targetY():Number { return player.y - FP.height / 2 - 100; }		
		
		
		public function loadLevel(file:Class):void
		{
			// load the level xml
			var bytes:ByteArray = new file;
			level = new XML(bytes.readUTFBytes(bytes.length));

			// load level information
			//width = level.width;
			//height = level.height;

			// load sitters
			for each (var o:XML in level.actors.sitter)
				add(new Sitter(FP.scale(o.@x, 0, level.width, 0, width), FP.scale(o.@y, 0, level.height, 0, height)));
				
			// load mixers
			for each (o in level.actors.mixer_center)
				add(new MixerCenter(FP.scale(o.@x, 0, level.width, 0, width), FP.scale(o.@y, 0, level.height, 0, height)));				
			for each (o in level.actors.mixer)
				add(new Mixer(FP.scale(o.@x, 0, level.width, 0, width), FP.scale(o.@y, 0, level.height, 0, height)));			
				
			// load orbiters
			for each (o in level.actors.orbiter_center)
				add(new OrbiterCenter(FP.scale(o.@x, 0, level.width, 0, width), FP.scale(o.@y, 0, level.height, 0, height)));				
			for each (o in level.actors.orbiter)
				add(new Orbiter(FP.scale(o.@x, 0, level.width, 0, width), FP.scale(o.@y, 0, level.height, 0, height)));		
				
			// load jumpers			
			for each (o in level.actors.jumper)
				add(new Jumper(FP.scale(o.@x, 0, level.width, 0, width), FP.scale(o.@y, 0, level.height, 0, height)));
				
			// load marchers			
			for each (o in level.actors.marcher)
				add(new Marcher(FP.scale(o.@x, 0, level.width, 0, width), FP.scale(o.@y, 0, level.height, 0, height)));					
		}
		
	}

}