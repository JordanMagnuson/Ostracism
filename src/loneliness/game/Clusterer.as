package loneliness.game 
{
	import loneliness.rooms.MainWorld;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.tweens.misc.Alarm;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Clusterer extends Other
	{
		public const TRANSFORM_BACK_TIME:Number = 0.75;
		
		public var clusterCenter:Entity;
		public var transformInto:Class;
		public var transformBackAlarm:Alarm = new Alarm(TRANSFORM_BACK_TIME, transformBack);
		
		public function Clusterer(x:Number = 0, y:Number = 0, transformInto:Class = null) 
		{
			super(x, y);
			type = 'clusterer';
			clusterCenter = (FP.world.nearestToEntity('cluster_center', this) as ClusterCenter);
			
			direction = pointDirection(x, y, clusterCenter.x, clusterCenter.y);	
			setSpdMax();
			speed = (spdMax / 2) + (FP.random * spdMax / 2);
			speed = speed / 2;
			this.transformInto = transformInto;
		}
		
		override public function added():void 
		{
			addTween(transformBackAlarm, true);
			tellNearbyToCluster();
		}
		
		override public function update():void
		{	
			move(speed * FP.elapsed, direction);
		}		
		
		public function transformBack():void 
		{
			FP.world.remove(this);
			FP.world.add(new transformInto(x, y, 'clustered'));
		}
		
		public function tellNearbyToCluster():void 
		{
			var toInfluence:Array = [];
			FP.world.collideRectInto('other', x - CLUSTER_RADIUS, y - CLUSTER_RADIUS, CLUSTER_RADIUS * 2, CLUSTER_RADIUS * 2, toInfluence);

			for each (var other:Other in toInfluence) {
				if (other.mode != 'clustered') {
					other.cluster();
				}
			}
		}		
		
	}

}