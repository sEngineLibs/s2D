package s2d.graphics;

import kha.Color;
import kha.FastFloat;
import kha.math.FastVector2;
import kha.math.FastMatrix3;
// s2d
import s2d.graphics.shaders.postprocessing.DOFPass;
import s2d.graphics.shaders.postprocessing.MistPass;
import s2d.graphics.shaders.postprocessing.FilterPass;
import s2d.graphics.shaders.postprocessing.FisheyePass;
import s2d.graphics.shaders.postprocessing.CompositorPass;

@:allow(s2d.graphics.RenderPath)
class PostProcessing {
	static var dofPass:DOFPass = new DOFPass();
	static var mistPass:MistPass = new MistPass();
	static var filterPass:FilterPass = new FilterPass();
	static var fisheyePass:FisheyePass = new FisheyePass();
	static var compositorPass:CompositorPass = new CompositorPass();

	public static var dof:DOF = {
		focusDistance: 0.5,
		blurSize: 0.01
	};
	public static var mist:Mist = {
		near: 0.0,
		far: 1.0,
		color: White
	};
	public static var fisheye:Fisheye = {
		position: {x: 0.5, y: 0.5},
		strength: 0.0
	};
	public static var filters:Array<FastMatrix3> = [];
	public static var compositor:Compositor = new Compositor();
}

private typedef DOF = {
	var focusDistance:FastFloat;
	var blurSize:FastFloat;
}

private typedef Mist = {
	var near:FastFloat;
	var far:FastFloat;
	var color:Color;
}

private typedef Fisheye = {
	var position:FastVector2;
	var strength:FastFloat;
}
