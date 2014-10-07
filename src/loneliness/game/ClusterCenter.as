package loneliness.game 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	public class ClusterCenter extends CenterGuide
	{
		//public var clockWise:Boolean = FP.choose(true, false);
		
		//public var debug_image:Image = Image.createRect(12, 12, Colors.GREEN);
		
		public function ClusterCenter(x:Number, y:Number) 
		{
			super(x, y);
			type = 'cluster_center';		
			//graphic = debug_image;
		}
		
	}

}