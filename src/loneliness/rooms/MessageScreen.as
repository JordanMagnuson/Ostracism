package loneliness.rooms 
{
	import loneliness.game.ChildrenAndText;
	//import menu.KoreaLanding;
	import net.flashpunk.Sfx;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.Screen;
	import flash.geom.Rectangle;
	import net.flashpunk.utils.Input;
	//import menu.Global;
	import punk.transition.Transition;
	import flash.utils.Dictionary;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author Jordan Magnuson
	 */
	public class MessageScreen extends World
	{
		
		public function MessageScreen() 
		{
			
		}
		
		override public function begin():void
		{
			// Change screen size for this room, instead of upscaling, for clearer text
			//FP.width = 600;
			//FP.height = 450;
			//FP.screen = new Screen();	
			FP.screen.color = Colors.BLACK;
			//FP.bounds = new Rectangle(0, 0, FP.width, FP.height);
			FP.camera.x = 0;
			FP.camera.y = 0;			
			
			// Text
			//add(new ChildrenAndText);
		}
		
		override public function update():void
		{
			// Start Over
			if (Input.pressed(SuperGlobal.RETURN_KEY)) 
			{
				// Clear tweens (eg fading sounds, FP.alarm, etc.)
				FP.tweener.clearTweens();
				
				FP.world = new MainWorld;
			}			
			
			// Change ostracism conditon and restart
			if (Input.pressed(Key.DIGIT_1)) 
			{
				// Clear tweens (eg fading sounds, FP.alarm, etc.)
				FP.tweener.clearTweens();
				
				SuperGlobal.ostracismCondition = 1;
				FP.world = new MainWorld;
			}					
			else if (Input.pressed(Key.DIGIT_2)) 
			{
				// Clear tweens (eg fading sounds, FP.alarm, etc.)
				FP.tweener.clearTweens();
				
				SuperGlobal.ostracismCondition = 2;
				FP.world = new MainWorld;
			}	
			
			super.update();
		}
		
	}

}