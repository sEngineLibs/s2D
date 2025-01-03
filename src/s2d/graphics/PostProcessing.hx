package s2d.graphics;

#if S2D_PP
import kha.Color;
import kha.math.FastMatrix3;
// s2d
#if S2D_PP_DOF
import s2d.graphics.shaders.postprocessing.DOFPass;
#end
#if S2D_PP_MIST
import s2d.graphics.shaders.postprocessing.MistPass;
#end
#if S2D_PP_FILTER
import s2d.graphics.shaders.postprocessing.FilterPass;
#end
#if S2D_PP_FISHEYE
import s2d.graphics.shaders.postprocessing.FisheyePass;
#end
#if S2D_PP_COMPOSITOR
import s2d.graphics.shaders.postprocessing.CompositorPass;
#end

@:allow(s2d.graphics.RenderPath)
class PostProcessing {
	#if S2D_PP_DOF
	static var dofPass:DOFPass = new DOFPass();
	@:isVar public static var dof(default, never) = {
		focusDistance: 0.5,
		blurSize: 0.0
	};
	#end
	#if S2D_PP_MIST
	static var mistPass:MistPass = new MistPass();
	@:isVar public static var mist(default, never) = {
		near: 0.0,
		far: 1.0,
		color: Color.fromFloats(0.0, 0.0, 0.0, 0.0)
	};
	#end
	#if S2D_PP_FILTER
	static var filterPass:FilterPass = new FilterPass();
	@:isVar public static var filters(default, never):Array<FastMatrix3> = [];
	#end
	#if S2D_PP_FISHEYE
	static var fisheyePass:FisheyePass = new FisheyePass();
	@:isVar public static var fisheye(default, never) = {
		position: {x: 0.5, y: 0.5},
		strength: 0.0
	};
	#end
	#if S2D_PP_COMPOSITOR
	static var compositorPass:CompositorPass = new CompositorPass();
	@:isVar public static var compositor(default, never) = new Compositor();
	#end
}
#end
