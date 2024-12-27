package s2d.graphics;

import kha.FastFloat;

private typedef Distortion = {
	var x:FastFloat;
	var y:FastFloat;
	var strength:FastFloat;
}

class Compositor {
	public static var distortion:Distortion = {
		x: 0.5,
		y: 0.5,
		strength: 1.0
	};
}
