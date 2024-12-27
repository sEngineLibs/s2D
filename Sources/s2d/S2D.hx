package s2d;

import kha.math.FastVector2;
import kha.Image;
import kha.System;
import kha.Assets;
import kha.Window;
import kha.FastFloat;
import kha.Framebuffer;
import kha.math.FastMatrix4;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexStructure;
// s2d
import s2d.Stage;
import s2d.objects.Sprite;
import s2d.graphics.RenderPath;
import s2d.graphics.shaders.GeometryPass;
import s2d.graphics.shaders.LightingPass;
import s2d.graphics.shaders.CompositorPass;
import s2d.graphics.shaders.PostProcessingPass;

class S2D {
	public static var indices:IndexBuffer;
	public static var vertices:VertexBuffer;
	public static var projection:FastMatrix4;
	public static var gbuffer:Array<Image> = [];
	@:isVar public static var scale(default, set):FastFloat = 1.0;
	@:isVar public static var distance(default, set):FastFloat = 1.0;
	@:isVar public static var aspectRatio(default, set):FastFloat = 1.0;

	public static var stage:Stage = new Stage();
	public static var setup:Void->Void;

	public static inline function init(window:Window) {
		Assets.loadEverything(function() {
			GeometryPass.compile();
			LightingPass.compile();
			CompositorPass.compile();
			PostProcessingPass.compile();
			Sprite.init();

			// init indices
			indices = new IndexBuffer(6, StaticUsage);
			var ind = indices.lock();
			ind[0] = 0;
			ind[1] = 1;
			ind[2] = 2;
			ind[3] = 3;
			ind[4] = 2;
			ind[5] = 0;
			indices.unlock();

			// init structure
			var structure = new VertexStructure();
			structure.add("vertCoord", Float32_2X);
			var structSize = 2;

			// init vertices
			vertices = new VertexBuffer(4, structure, StaticUsage);
			var vert = vertices.lock();
			for (i in 0...4) {
				vert[i * structSize + 0] = i == 0 || i == 1 ? -1.0 : 1.0;
				vert[i * structSize + 1] = i == 0 || i == 3 ? -1.0 : 1.0;
			}
			vertices.unlock();

			aspectRatio = window.width / window.height;
			// [position, normal, color, orm, emission, postprocessing, compositing]
			for (i in 0...7)
				gbuffer.push(Image.createRenderTarget(window.width, window.height));

			window.notifyOnResize(resize);

			setup();

			System.notifyOnFrames(render);
		});
	}

	public static inline function resize(width:Int, height:Int) {
		aspectRatio = width / height;
		for (i in 0...gbuffer.length)
			gbuffer[i] = Image.createRenderTarget(width, height);
	}

	static inline function set_scale(value:FastFloat):FastFloat {
		scale = value;
		updateProjection();
		return value;
	}

	static inline function set_distance(value:FastFloat):FastFloat {
		distance = value;
		updateProjection();
		return value;
	}

	static inline function set_aspectRatio(value:FastFloat):FastFloat {
		aspectRatio = value;
		updateProjection();
		return value;
	}

	static inline function updateProjection() {
		if (aspectRatio >= 1)
			projection = FastMatrix4.orthogonalProjection(-scale * aspectRatio, scale * aspectRatio, -scale, scale, 0.0, distance);
		else
			projection = FastMatrix4.orthogonalProjection(-scale, scale, -scale / aspectRatio, scale / aspectRatio, 0.0, distance);
	}

	public static inline function mapToProjection(point:FastVector2):FastVector2 {
		return {
			x: (point.x * 2.0 - 1.0) * Math.sqrt(projection._00 * projection._00 + projection._10 * projection._10),
			y: -(point.y * 2.0 - 1.0) * Math.sqrt(projection._01 * projection._01 + projection._11 * projection._11)
		};
	}

	public static inline function render(frames:Array<Framebuffer>):Void {
		RenderPath.render(frames[0], stage);
	}
}
