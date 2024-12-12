package s2d.graphics;

import kha.Color;
import kha.Canvas;

class RenderPathDeffered implements RenderPath {
	var stage:S2D;
	#if (S2D_SHADING_DEFERRED || S2D_SHADING_MIXED)
	var gbuffer:MapPack;
	#end

	public inline function new(stage:S2D) {
		this.stage = stage;

		#if (S2D_SHADING_DEFERRED || S2D_SHADING_MIXED)
		gbuffer = new MapPack(1, 1, 4);
		#end
	}

	inline function resize(width:Int, height:Int) {
		#if (S2D_SHADING_DEFERRED || S2D_SHADING_MIXED)
		gbuffer.resize(width, height);
		#end
	}

	inline function render(target:Canvas) {
		#if (S2D_SHADING_DEFERRED || S2D_SHADING_MIXED)
		gbuffer[0].g4.begin([gbuffer[1], gbuffer[2], gbuffer[3]]);
		gbuffer[0].g4.clear(Color.Transparent, 0.0);
		#if S2D_BATCHING
		for (batch in stage.batches)
			batch.drawGeometry(gbuffer[0]);
		#else
		for (sprite in stage.sprites)
			sprite.drawGeometry(gbuffer[0]);
		#end
		gbuffer[0].g4.end();

		target.g2.begin();
		for (light in stage.lights) {
			DeferredRenderer.lighting.draw(target, stage.vertices, stage.indices, [
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
		target.g2.end();
		#else
		target.g2.begin();
		#if S2D_BATCHING
		for (batch in stage.batches)
			batch.draw(target, stage.lights);
		#else
		for (sprite in stage.sprites)
			sprite.draw(target, stage.lights);
		target.g2.end();
		#end
		#end
	}
}
