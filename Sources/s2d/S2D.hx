package s2d;

import kha.Image;
import kha.System;
import kha.Assets;
import kha.Window;
import kha.FastFloat;
import kha.Framebuffer;
import kha.math.FastVector3;
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

using s2d.utils.FastMatrix4Ext;

class S2D {
	public static var projection:FastMatrix4;
	public static var gbuffer:Array<Image> = [];
	public static var WIDTH:Int;
	public static var HEIGHT:Int;
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

			WIDTH = window.width;
			HEIGHT = window.height;
			aspectRatio = window.width / window.height;
			// [position, normal, color, orm, glow, postprocessing, compositing]
			for (i in 0...7)
				gbuffer.push(Image.createRenderTarget(window.width, window.height));

			window.notifyOnResize(resize);

			setup();

			System.notifyOnFrames(render);
		});
	}

	public static inline function resize(width:Int, height:Int) {
		WIDTH = width;
		HEIGHT = height;
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

	public static inline function local2WorldSpace(point:FastVector3):FastVector3 {
		return {
			x: (point.x * 2.0 - 1.0) / projection.getScaleX(),
			y: (point.y * 2.0 - 1.0) / projection.getScaleY(),
			z: (point.z * 2.0 - 1.0) / projection.getScaleZ()
		};
	}

	public static inline function world2LocalSpace(point:FastVector3):FastVector3 {
		return {
			x: point.x * projection.getScaleX() * 0.5 + 0.5,
			y: point.y * projection.getScaleY() * 0.5 + 0.5,
			z: point.z * projection.getScaleZ() * 0.5 + 0.5
		};
	}

	public static inline function screen2LocalSpace(point:FastVector3):FastVector3 {
		return {
			x: point.x / WIDTH,
			y: point.y / HEIGHT
		};
	}

	public static inline function local2ScreenSpace(point:FastVector3):FastVector3 {
		return {
			x: point.x * WIDTH,
			y: point.y * HEIGHT
		};
	}

	public static inline function screen2WorldSpace(point:FastVector3):FastVector3 {
		return local2WorldSpace(screen2LocalSpace(point));
	}

	public static inline function world2ScreenSpace(point:FastVector3):FastVector3 {
		return local2ScreenSpace(world2LocalSpace(point));
	}

	public static inline function render(frames:Array<Framebuffer>):Void {
		RenderPath.render(frames[0], stage);
	}
}
