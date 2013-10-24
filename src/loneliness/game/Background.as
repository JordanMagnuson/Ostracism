package loneliness.game 
{
	import flash.display.BitmapData;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Background extends Entity
	{
		public var bgCanvas:Canvas;
		public var bgBitmapData:BitmapData;	
		
		public function Background(x:Number = 0, y:Number = 0, graphic:Graphic=null) 
		{
			trace('yep here');
			super(x, y);
			if (SuperGlobal.BACKGROUND_IMAGE) {
				bgBitmapData = FP.getBitmap(SuperGlobal.BACKGROUND_IMAGE);
				bgCanvas = new Canvas(FP.width, bgBitmapData.height);
				bgCanvas.draw(0, 0, bgBitmapData);					
				this.graphic = bgCanvas;
			}
			this.layer = 900;
		}
		
	}

}