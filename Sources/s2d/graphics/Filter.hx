package s2d.graphics;

import kha.FastFloat;
import kha.math.FastMatrix3;

abstract Filter(FastMatrix3) from FastMatrix3 to FastMatrix3 {
	public static var Identity = new Filter(0, 0, 0, 0, 1, 0, 0, 0, 0);
	public static var Sharpen = new Filter(-0.0023, -0.0432, -0.0023, -0.0432, 1.182, -0.0432, -0.0023, -0.0432, -0.0023);
	public static var BoxBlur = new Filter(0.111, 0.111, 0.111, 0.112, 0.111, 0.111, 0.111, 0.111, 0.111);
	public static var GaussianBlur = new Filter(0.0625, 0.125, 0.0625, 0.125, 0.25, 0.125, 0.0625, 0.125, 0.0625);
	public static var EdgeDetectionVertical = new Filter(-1, 0, 1, -2, 0, 2, -1, 0, 1);
	public static var EdgeDetectionHorizontal = new Filter(-1, -2, -1, 0, 0, 0, 1, 2, 1);
	public static var EdgeDetectionDiagonal1 = new Filter(0, -1, -1, -1, 4, -1, -1, -1, 0);
	public static var EdgeDetectionDiagonal2 = new Filter(-1, -1, 0, -1, 4, -1, 0, -1, -1);
	public static var Emboss = new Filter(-2, -1, 0, -1, 1, 1, 0, 1, 2);
	public static var Laplacian = new Filter(0, -1, 0, -1, 4, -1, 0, -1, 0);
	public static var SobelVertical = new Filter(-1, 0, 1, -2, 0, 2, -1, 0, 1);
	public static var SobelHorizontal = new Filter(-1, -2, -1, 0, 0, 0, 1, 2, 1);
	public static var Outline = new Filter(-1, -1, -1, -1, 8, -1, -1, -1, -1);
	public static var HighPass = new Filter(-1, -1, -1, -1, 9, -1, -1, -1, -1);
	public static var RidgeDetection = new Filter(-2, -1, 0, -1, 1, 1, 0, 1, 2);
	public static var DepthEnhance = new Filter(1, 1, 1, 1, -7, 1, 1, 1, 1);
	public static var PrewittHorizontal = new Filter(-1, -1, -1, 0, 0, 0, 1, 1, 1);
	public static var PrewittVertical = new Filter(-1, 0, 1, -1, 0, 1, -1, 0, 1);

	inline function new(_00:FastFloat, _10:FastFloat, _20:FastFloat, _01:FastFloat, _11:FastFloat, _21:FastFloat, _02:FastFloat, _12:FastFloat, _22:FastFloat) {
		this = new FastMatrix3(_00, _10, _20, _01, _11, _21, _02, _12, _22);
	}

	public static inline function combine(filter1:Filter, filter2:Filter):Filter {
		var f1:FastMatrix3 = filter1;
		var f2:FastMatrix3 = filter2;
		return f1.add(f2).mult(0.5);
	}

	public inline function add(filter:Filter):Filter {
		return Filter.combine(this, filter);
	}
}
