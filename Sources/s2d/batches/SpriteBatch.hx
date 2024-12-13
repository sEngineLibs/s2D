package s2d.batches;

import kha.Canvas;
import kha.math.FastVector3;
import kha.arrays.Uint32Array;
import kha.arrays.Float32Array;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
// s2d
import sui.core.graphics.DeferredRenderer;
import s2d.graphics.MapBatch;
import s2d.objects.Sprite;
import s2d.objects.Light;

using sui.core.utils.ArrayExt;

@:allow(s2d.S2D, s2d.objects.Sprite, s2d.graphics.RenderPath)
class SpriteBatch {
	#if S2D_BATCHING
	@readonly public var sprites:Array<Sprite> = [];
	public var shadowVerts(get, never):Array<FastVector3>;
	@readonly public var gbuffer:MapBatch = new MapBatch(512, 4);

	inline function get_shadowVerts():Array<FastVector3> {
		var sv:Array<FastVector3> = [];
		for (sprite in sprites) {
			if (!sprite.shadowCasting)
				continue;
			for (sVert in sprite.shadowVerts)
				sv.push({x: sVert.x, y: sVert.y, z: sprite.shadowOpacity});
		}
		return sv;
	}

	@readonly var blendModeArr:Uint32Array = new Uint32Array(64);

	@readonly var vertices:VertexBuffer;
	@readonly var indices:IndexBuffer;

	public function new() {}

	inline function add(sprite:Sprite) {
		var vertCount = 0;
		var vertData:Float32Array = null;
		var indData:Uint32Array = null;

		if (vertices != null) {
			vertCount = vertices.count();
			vertData = vertices.lock();
			vertices.delete();
		}
		var indCount = 0;
		if (indices != null) {
			indCount = indices.count();
			indData = indices.lock();
			indices.delete();
		}
		var vertOffset = vertCount * DeferredRenderer.geometry.structSize;
		sprite.vertOffset = vertOffset;

		vertices = new VertexBuffer(vertCount + 4, DeferredRenderer.geometry.structure, StaticUsage);
		indices = new IndexBuffer(indCount + 6, StaticUsage);

		var vert = vertices.lock();
		for (i in 0...vertData?.length)
			vert[i] = vertData[i];

		// init sprite UV
		for (i in 0...4) {
			var offset = vertOffset + i * DeferredRenderer.geometry.structSize;

			vert[offset + 0] = 0; // X
			vert[offset + 1] = 0; // Y
			vert[offset + 2] = 0; // Z
			vert[offset + 3] = 0; // I
			vert[offset + 4] = i == 2 || i == 3 ? 1 : 0; // U
			vert[offset + 5] = i == 1 || i == 2 ? 1 : 0; // V
		}

		var ind = indices.lock();
		for (i in 0...indData?.length)
			ind[i] = indData[i];

		ind[indCount + 0] = vertCount + 0;
		ind[indCount + 1] = vertCount + 1;
		ind[indCount + 2] = vertCount + 2;
		ind[indCount + 3] = vertCount + 0;
		ind[indCount + 4] = vertCount + 2;
		ind[indCount + 5] = vertCount + 3;
		indices.unlock();

		sprite.batch = this;
		sprites.push(sprite);
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
	#end
}
