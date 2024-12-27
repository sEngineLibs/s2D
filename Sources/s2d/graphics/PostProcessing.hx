package s2d.graphics;

import kha.FastFloat;

private typedef DOF = {
	var distance:FastFloat;
	var size:FastFloat;
}

class PostProcessing {
	public static var dof:DOF = {
		distance: 0.5,
		size: 0.05
	};
}
