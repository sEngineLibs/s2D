package s2d;

import kha.Color;
import kha.Image;
import kha.Canvas;
import kha.FastFloat;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
// sui
import s2d.graphics.MapPack;
import s2d.objects.Object;
import s2d.objects.Sprite;
import s2d.objects.Light;
import s2d.batches.SpriteBatch;
import s2d.graphics.RenderPath;
import s2d.graphics.RenderPathDeffered;

using sui.core.utils.ArrayExt;

@:allow(s2d.graphics.RenderPath)
class S2D {
	var backbuffer:Image;
	var indices:IndexBuffer;
	var vertices:VertexBuffer;

	var renderPath:RenderPath;
	var lights:Array<Light> = [];
	#if S2D_BATCHING
	var batches:Array<SpriteBatch> = [];
	#else
	var sprites:Array<Sprite> = [];
	#end

	public function new(scene:Scene) {
		super(scene);

		backbuffer = Image.createRenderTarget(1, 1, RGBA32, DepthOnly);
		renderPath = new RenderPathDeffered(this);
		vertices = new VertexBuffer(4, DeferredRenderer.lighting.structure, StaticUsage);

		var vert = vertices.lock();
		vert[0] = -1;
		vert[1] = -1;
		vert[2] = -1;
		vert[3] = 1;
		vert[4] = 1;
		vert[5] = 1;
		vert[6] = 1;
		vert[7] = -1;
		vertices.unlock();

		indices = new IndexBuffer(6, StaticUsage);
		var ind = indices.lock();
		ind[0] = 0;
		ind[1] = 1;
		ind[2] = 2;
		ind[3] = 3;
		ind[4] = 2;
		ind[5] = 0;
		indices.unlock();

		left.addPositionListener(setLeft);
		top.addPositionListener(setTop);
		right.addPositionListener(setRight);
		bottom.addPositionListener(setBottom);
	}

	override inline function resize(width:FastFloat, height:FastFloat) {
		var w = Std.int(width);
		var h = Std.int(height);

		backbuffer = Image.createRenderTarget(w, h);
		renderPath.resize(w, h);
	}

	inline function setLeft(value:FastFloat) {
		resize(width, height);
	}

	inline function setTop(value:FastFloat) {
		resize(width, height);
	}

	inline function setRight(value:FastFloat) {
		resize(width, height);
	}

	inline function setBottom(value:FastFloat) {
		resize(width, height);
	}

	public inline function add(object:Object) {
		if (object is Sprite) {
			var sprite:Sprite = cast object;
			#if S2D_BATCHING
			var lb = batches.last();
			if (lb is SpriteBatch && lb.gbuffer.packsCount < lb.gbuffer.packsCapacity) {
				lb.add(sprite);
			} else {
				var b = new SpriteBatch();
				b.add(sprite);
				batches.push(b);
			}
			#else
			sprites.push(sprite);
			#end
		} else if (object is Light)
			lights.push(cast object);
	}

	override inline function draw(target:Canvas) {
		target.g2.end();
		renderPath.render(backbuffer);
		target.g2.begin(false);
		target.g2.drawScaledImage(backbuffer, x, y, width, height);
	}
}
