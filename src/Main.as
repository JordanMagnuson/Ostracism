package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import loneliness.rooms.ClickNextScreen;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import flash.ui.Mouse;	
	import loneliness.rooms.MainWorld;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import flash.events.KeyboardEvent;
	
	[SWF(width=SuperGlobal.SCREEN_WIDTH,height=SuperGlobal.SCREEN_HEIGHT,backgroundColor='#000000',frameRate=SuperGlobal.FRAME_RATE)]
	
	public class Main extends Engine
	{
		public function Main() 
		{
			super(SuperGlobal.SCREEN_WIDTH, SuperGlobal.SCREEN_HEIGHT, SuperGlobal.FRAME_RATE);
			FP.screen.color = Colors.WHITE;
			//FP.screen.color = Colors.WHITE;
			
			// Console for debugging
			//FP.console.enable();		
			
			FP.world = new MainWorld;
			
			//Mouse.hide();
		}
		
		public function reset(width:uint, height:uint, frameRate:Number = 30, fixed:Boolean = false):void
		{
			FP.frameRate = SuperGlobal.FRAME_RATE;
			// First, black out current screen
			//FP.screen = new Screen;
		
			// See net.flashpunk.Engine constructor
			
			// global game properties
			if (FP.width != width || FP.height != height) 
				FP.resize(width, height);
			//FP.width = width;
			//FP.height = height;
			//FP.halfWidth = width/2;
			//FP.halfHeight = height/2;
			
			FP.assignedFrameRate = frameRate;
			FP.fixed = fixed;
			FP.timeInFrames = fixed;
			
			// global game objects
			//FP.engine = this;
			//FP.screen = new Screen;
			//FP.bounds = new Rectangle(0, 0, width, height);
			//FP._world = new World;
			//FP.camera = FP._world.camera;
			//Draw.resetTarget();
			
			// miscellaneous startup stuff
			//if (FP.randomSeed == 0) FP.randomizeSeed();
			//FP.entity = new Entity;
			//FP._time = getTimer();
			
			// Additional touches that are not part of engine constructor
			FP.screen.color = Colors.BLACK;
			FP.screen.x = 0;
			FP.screen.y = 0;
			FP.screen.scale = 1;
			FP.rate = 1;
			FP.screen.smoothing = false;
		
		}
		
		override public function init():void
		{
			// Full screen
			if (SuperGlobal.FULL_SCREEN) {
				FP.stage.scaleMode = StageScaleMode.SHOW_ALL;
				FP.stage.fullScreenSourceRect = new Rectangle(0, 0, SuperGlobal.SCREEN_WIDTH, SuperGlobal.SCREEN_HEIGHT);
				FP.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;	
				
				// Listen for Esc key, prevent exiting full screen
				//FP.stage.addEventListener(KeyboardEvent.KEY_DOWN, preventEsc);
			}
			
			// Super
			super.init();
		}			
	}
}