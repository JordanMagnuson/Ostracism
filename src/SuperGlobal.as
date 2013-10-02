package  
{
	import flash.utils.Dictionary;
	import net.flashpunk.utils.Key;
	import punk.transition.effects.BlurOut;
	import punk.transition.effects.Effect;
	import punk.transition.effects.BlurIn;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SuperGlobal 
	{
		// Platform specifics
		public static const SCREEN_WIDTH:Number = 700;
		public static const SCREEN_HEIGHT:Number = 500;
		public static const FRAME_RATE:Number = 60;
		public static const FULL_SCREEN:Boolean = false;
		
		public static const RETURN_KEY:int = Key.ESCAPE;
		public static const FULLSCREEN_KEY:int = Key.F;
		
		public static const TRANS_OUT:Class = BlurOut;
		public static const TRANS_IN:Class = BlurIn;
		public static const TRANS_OUT_OPTIONS:Object = { duration: 0.5 }
		public static const TRANS_IN_OPTIONS:Object = { duration: 0.5 }			
		
		public static var soundsPlaying:Dictionary = new Dictionary();
		
		public static var ostracismCondition:Number = 3; // 1 = Ostracism, 2 = Indifference, 3 = Inclusion, 4 = Smothering
		
		
		
		public static const CHANCE_OF_FOLLOWING_INITIAL:Number = 0.15;
		public static const CHANCE_OF_FOLLOWING_CHANGE:Number = 0.015;
		public static const MAX_FOLLOWERS:Number = 5;
		public static var inclusionFollowers:Number = 0;
		public static var inclusionChaserChanceOfFollowing:Number = CHANCE_OF_FOLLOWING_INITIAL;
		
		
		public static function reset():void
		{
			SuperGlobal.inclusionChaserChanceOfFollowing = SuperGlobal.CHANCE_OF_FOLLOWING_INITIAL;
			SuperGlobal.inclusionFollowers = 0;					
		}		
	}

}