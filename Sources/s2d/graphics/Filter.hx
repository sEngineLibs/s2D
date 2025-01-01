package s2d.graphics;

import kha.math.FastMatrix3;

abstract Filter(FastMatrix3) to FastMatrix3 {
	public static var NoFilter = new FastMatrix3(0, 0, 0, 0, 1, 0, 0, 0, 0);
	public static var Sharpen = new FastMatrix3(-0.0023, -0.0432, -0.0023, -0.0432, 1.182, -0.0432, -0.0023, -0.0432, -0.0023);
	public static var Blur = new FastMatrix3(0.111, 0.111, 0.111, 0.112, 0.111, 0.111, 0.111, 0.111, 0.111);
	public static var GaussianBlur = new FastMatrix3(0.0625, 0.125, 0.0625, 0.125, 0.25, 0.125, 0.0625, 0.125, 0.0625);
	public static var EdgeDetectionVertical = new FastMatrix3(-1, 0, 1, -2, 0, 2, -1, 0, 1);
	public static var EdgeDetectionHorizontal = new FastMatrix3(-1, -2, -1, 0, 0, 0, 1, 2, 1);
	public static var EdgeDetectionDiagonal1 = new FastMatrix3(0, -1, -1, -1, 4, -1, -1, -1, 0);
	public static var EdgeDetectionDiagonal2 = new FastMatrix3(-1, -1, 0, -1, 4, -1, 0, -1, -1);
	public static var Emboss = new FastMatrix3(-2, -1, 0, -1, 1, 1, 0, 1, 2);
}
