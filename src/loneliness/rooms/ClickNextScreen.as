package loneliness.rooms 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ClickNextScreen extends World
	{
		[Embed(source="../../../assets/click_next_to_continue.png")] private const TEXT:Class;
		public var image:Image = new Image(TEXT);		
		
		public function ClickNextScreen() 
		{
			trace('constructor');
			FP.screen.color = Colors.BLACK;
			image.centerOrigin();
		}
		
		override public function begin():void 
		{
			trace('begin');
			add(new Entity(FP.halfWidth, FP.halfHeight, image));
		}
		
	}

}