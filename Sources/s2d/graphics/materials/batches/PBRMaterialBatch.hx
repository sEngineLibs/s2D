package s2d.graphics.materials.batches;

class PBRMaterialBatch {
	var gbuffer:MapBatch;

	public function new(mapWidth:Int, mapHeight:Int) {
		gbuffer = new MapBatch(mapWidth, mapHeight, 4);
	}

	#if (S2D_SHADING_DEFERRED || S2D_SHADING_MIXED)
	inline function drawGeometry(target:Canvas) {
		DeferredRenderer.geometry.draw(target, vertices, indices, [gbuffer[0], gbuffer[1], gbuffer[2], gbuffer[3], gbuffer.packsCount, blendModeArr]);
	}
	#else
	public inline function draw(target:Canvas, lights:Array<Light>) {
		for (light in lights) {
			DeferredRenderer.lighting.draw(target, vertices, indices, [
				gbuffer[0],
				gbuffer[1],
				gbuffer[2],
				gbuffer[3],
				light.x,
				light.y,
				light.z,
				light.color.R,
				light.color.G,
				light.color.B,
				light.power,
				light.radius
			]);
		}
	}
	#end
}
