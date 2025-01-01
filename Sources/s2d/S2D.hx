package s2d;

import kha.Image;
import kha.System;
import kha.FastFloat;
import kha.Framebuffer;
import kha.math.FastVector3;
import kha.math.FastMatrix4;
// s2d
import s2d.Stage;
import s2d.objects.Sprite;
import s2d.graphics.RenderPath;
import s2d.graphics.Compositor;
import s2d.graphics.PostProcessing;
import s2d.graphics.shaders.GeometryPass;
import s2d.graphics.shaders.LightingPass;
import s2d.graphics.shaders.CompositorPass;
import s2d.graphics.shaders.PostProcessingPass;

using s2d.utils.FastMatrix4Ext;

class S2D {
	public static var projection:FastMatrix4;
	public static var gbuffer:Array<Image> = [];

	public static var width:Int;
	public static var height:Int;
	public static var realWidth(get, set):Int;
	public static var realHeight(get, set):Int;
	@:isVar public static var resolutionScale(default, set):FastFloat = 1.0;

	@:isVar public static var scale(default, set):FastFloat = 1.0;
	@:isVar public static var aspectRatio(default, set):FastFloat = 1.0;

	public static var stage:Stage = new Stage();
	public static var postProcessing:PostProcessing = new PostProcessing();
	public static var compositor:Compositor = new Compositor();
	public static var setup:Void->Void;

	static inline function get_realWidth():Int {
		return Std.int(width / resolutionScale);
	}

	static inline function set_realWidth(value:Int):Int {
		width = Std.int(value * resolutionScale);
		return value;
	}

	static inline function get_realHeight():Int {
		return Std.int(height / resolutionScale);
	}

	static inline function set_realHeight(value:Int):Int {
		height = Std.int(value * resolutionScale);
		return value;
	}

	static inline function set_resolutionScale(value:FastFloat):FastFloat {
		width = Std.int(width * resolutionScale / value);
		height = Std.int(height * resolutionScale / value);
		resolutionScale = value;

		return value;
	}

	public static inline function ready(w:Int, h:Int) {
		Sprite.init();
		realWidth = w;
		realHeight = h;

		aspectRatio = width / height;
		// position
		gbuffer.push(Image.createRenderTarget(width, height, RGBA128, DepthOnly));
		// normal
		gbuffer.push(Image.createRenderTarget(width, height, RGBA32, DepthOnly));
		// color
		gbuffer.push(Image.createRenderTarget(width, height, RGBA32, DepthOnly));
		// [occlusion, roughness, metallness]
		gbuffer.push(Image.createRenderTarget(width, height, RGBA32, DepthOnly));
		// glow
		gbuffer.push(Image.createRenderTarget(width, height, RGBA32, DepthOnly));
		// post processing
		gbuffer.push(Image.createRenderTarget(width, height, RGBA32, NoDepthAndStencil));
		// compositor
		gbuffer.push(Image.createRenderTarget(width, height, RGBA32, NoDepthAndStencil));
	}

	public static inline function set() {
		GeometryPass.compile();
		LightingPass.compile();
		CompositorPass.compile();
		PostProcessingPass.compile();
		setup();
	}

	public static inline function go() {
		System.notifyOnFrames(render);
	}

	public static inline function resize(w:Int, h:Int) {
		realWidth = w;
		realHeight = h;

		aspectRatio = width / height;
		// position
		gbuffer[0] = Image.createRenderTarget(width, height, RGBA128, DepthOnly);
		// normal
		gbuffer[1] = Image.createRenderTarget(width, height, RGBA32, DepthOnly);
		// color
		gbuffer[2] = Image.createRenderTarget(width, height, RGBA32, DepthOnly);
		// [occlusion, roughness, metallness]
		gbuffer[3] = Image.createRenderTarget(width, height, RGBA32, DepthOnly);
		// glow
		gbuffer[4] = Image.createRenderTarget(width, height, RGBA32, DepthOnly);
		// post processing
		gbuffer[5] = Image.createRenderTarget(width, height, RGBA32, NoDepthAndStencil);
		// compositor
		gbuffer[6] = Image.createRenderTarget(width, height, RGBA32, NoDepthAndStencil);
	}

	static inline function set_scale(value:FastFloat):FastFloat {
		scale = value;
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
			projection = FastMatrix4.orthogonalProjection(-scale * aspectRatio, scale * aspectRatio, -scale, scale, 0.0, scale);
		else
			projection = FastMatrix4.orthogonalProjection(-scale, scale, -scale / aspectRatio, scale / aspectRatio, 0.0, scale);

		projection = projection.multmat(FastMatrix4.lookAt({x: 0.0, y: 0.0, z: 0.0}, {x: 0.0, y: 0.0, z: -1.0}, {x: 0.0, y: 1.0, z: 0.0}));
	}

	public static inline function local2WorldSpace(point:FastVector3):FastVector3 {
		var wsp = stage.viewProjection.inverse().multvec({
			x: point.x * 2.0 - 1.0,
			y: point.y * 2.0 - 1.0,
			z: point.z * 2.0 - 1.0,
			w: 1.0
		});

		return {
			x: wsp.x,
			y: wsp.y,
			z: wsp.z
		};
	}

	public static inline function world2LocalSpace(point:FastVector3):FastVector3 {
		var ncp = stage.viewProjection.multvec({
			x: point.x,
			y: point.y,
			z: point.z,
			w: 1.0
		});

		return {
			x: ncp.x * 0.5 + 0.5,
			y: ncp.y * 0.5 + 0.5,
			z: ncp.z * 0.5 + 0.5
		};
	}

	public static inline function screen2LocalSpace(point:FastVector3):FastVector3 {
		return {
			x: point.x / realWidth,
			y: point.y / realHeight
		};
	}

	public static inline function local2ScreenSpace(point:FastVector3):FastVector3 {
		return {
			x: point.x * realWidth,
			y: point.y * realHeight
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
