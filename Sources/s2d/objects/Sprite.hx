package s2d.objects;

import kha.Image;
import kha.Color;
import kha.FastFloat;
import kha.math.FastVector2;
import kha.Canvas;
import kha.arrays.Float32Array;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
// s2d
import s2d.graphics.BlendMode;
import s2d.batches.SpriteBatch;
import s2d.graphics.MapPack;

@:structInit
@:allow(s2d.S2D, s2d.batches.SpriteBatch)
class Sprite extends Object {
	public var shadowVerts:Array<FastVector2> = [];
	public var shadowOpacity:FastFloat = 1.0;
	public var shadowCasting:Bool = true;

	public var vertices(get, set):Array<FastVector2>;
	public var centerPoint(get, never):FastVector2;

	inline function get_centerPoint():FastVector2 {
		var c:FastVector2 = {};

		for (vert in vertices) {
			c.x += vert.x;
			c.y += vert.y;
		}
		c.x /= vertices.length;
		c.y /= vertices.length;
		return c;
	}

	var vertBuffer:VertexBuffer;
	var indBuffer:IndexBuffer;

	public inline function new(stage:S2D) {
		super(stage);

		vertBuffer = new VertexBuffer(4, DeferredRenderer.geometry.structure, StaticUsage);

		var vertData = vertBuffer.lock();
		for (i in 0...4) {
			var offset = i * DeferredRenderer.geometry.structSize;

			vertData[offset + 0] = 0; // X
			vertData[offset + 1] = 0; // Y
			vertData[offset + 2] = 0; // Z
			vertData[offset + 3] = i == 2 || i == 3 ? 1 : 0; // U
			vertData[offset + 4] = i == 1 || i == 2 ? 1 : 0; // V
		}
		vertBuffer.unlock();

		indBuffer = new IndexBuffer(6, StaticUsage);
		var ind = indBuffer.lock();
		ind[0] = 0;
		ind[1] = 1;
		ind[2] = 2;
		ind[3] = 3;
		ind[4] = 2;
		ind[5] = 0;
		indBuffer.unlock();

		gbuffer = new MapPack(512, 512, 4);
	}

	public inline function get_vertices():Array<FastVector2> {
		var v = new Array<FastVector2>();
		var vertData = vertBuffer.lock();
		for (i in 0...4) {
			var offset = i * DeferredRenderer.geometry.structSize;
			v.push({
				x: vertData[offset + 0],
				y: vertData[offset + 1],
			});
		}
		vertBuffer.unlock();
		return v;
	}

	public inline function set_vertices(v:Array<FastVector2>):Array<FastVector2> {
		var vertData = vertBuffer.lock();
		if (v.length == 4)
			for (i in 0...4) {
				var offset = i * DeferredRenderer.geometry.structSize;
				vertData[offset + 0] = v[i].x;
				vertData[offset + 1] = v[i].y;
			}
		vertBuffer.unlock();
		return v;
	}

	override inline function scale(x:FastFloat, y:FastFloat) {
		var vertData = vertBuffer.lock();
		var c = centerPoint;
		for (i in 0...4) {
			var offset = i * DeferredRenderer.geometry.structSize;
			vertData[offset + 0] = (vertData[offset + 0] - c.x) * x + c.x;
			vertData[offset + 1] = (vertData[offset + 1] - c.y) * y + c.y;
		}
		vertBuffer.unlock();
	}

	override inline function translate(x:FastFloat, y:FastFloat) {
		var vertData = vertBuffer.lock();
		for (i in 0...4) {
			var offset = i * DeferredRenderer.geometry.structSize;
			vertData[offset + 0] += x;
			vertData[offset + 1] += y;
		}
		vertBuffer.unlock();
	}

	#if (S2D_SHADING_DEFERRED || S2D_SHADING_MIXED)
	public inline function drawGeometry(target:Canvas) {
		DeferredRenderer.geometry.draw(target, vertBuffer, indBuffer, [gbuffer[0], gbuffer[1], gbuffer[2], gbuffer[3], blendMode]);
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
