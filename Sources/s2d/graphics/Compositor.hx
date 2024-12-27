package s2d.graphics;

import kha.FastFloat;

private typedef DOF = {
	var focusDistance:FastFloat;
	var fStop:FastFloat;
	var blades:Int;
}

private typedef Fisheye = {
	var power:FastFloat;
}

class Compositor {
	public static var dof:DOF = {
		focusDistance: 0.5,
		fStop: 16.0,
		blades: 16
	};
	public static var fisheye:Fisheye = {
		power: 0.0
	};
}
