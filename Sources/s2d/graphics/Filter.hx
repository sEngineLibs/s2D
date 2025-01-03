package s2d.graphics;

import kha.math.FastMatrix3;

abstract Filter(FastMatrix3) from FastMatrix3 to FastMatrix3 {
	public static var Identity = new FastMatrix3(0, 0, 0, 0, 1, 0, 0, 0, 0);
	public static var Sharpen = new FastMatrix3(0, -1, 0, -1, 5, -1, 0, -1, 0);
	public static var BoxBlur = new FastMatrix3(0.111, 0.111, 0.111, 0.112, 0.111, 0.111, 0.111, 0.111, 0.111);
	public static var GaussianBlur = new FastMatrix3(0.0625, 0.125, 0.0625, 0.125, 0.25, 0.125, 0.0625, 0.125, 0.0625);
	public static var EdgeDetectionVertical = new FastMatrix3(-1, 0, 1, -2, 0, 2, -1, 0, 1);
	public static var EdgeDetectionHorizontal = new FastMatrix3(-1, -2, -1, 0, 0, 0, 1, 2, 1);
	public static var EdgeDetectionDiagonal1 = new FastMatrix3(0, -1, -1, -1, 4, -1, -1, -1, 0);
	public static var EdgeDetectionDiagonal2 = new FastMatrix3(-1, -1, 0, -1, 4, -1, 0, -1, -1);
	public static var Emboss = new FastMatrix3(-2, -1, 0, -1, 1, 1, 0, 1, 2);
	public static var Laplacian = new FastMatrix3(0, -1, 0, -1, 4, -1, 0, -1, 0);
	public static var SobelVertical = new FastMatrix3(-1, 0, 1, -2, 0, 2, -1, 0, 1);
	public static var SobelHorizontal = new FastMatrix3(-1, -2, -1, 0, 0, 0, 1, 2, 1);
	public static var Outline = new FastMatrix3(-1, -1, -1, -1, 8, -1, -1, -1, -1);
	public static var HighPass = new FastMatrix3(-1, -1, -1, -1, 9, -1, -1, -1, -1);
	public static var RidgeDetection = new FastMatrix3(-2, -1, 0, -1, 1, 1, 0, 1, 2);
	public static var DepthEnhance = new FastMatrix3(1, 1, 1, 1, -7, 1, 1, 1, 1);
	public static var PrewittHorizontal = new FastMatrix3(-1, -1, -1, 0, 0, 0, 1, 1, 1);
	public static var PrewittVertical = new FastMatrix3(-1, 0, 1, -1, 0, 1, -1, 0, 1);
}
