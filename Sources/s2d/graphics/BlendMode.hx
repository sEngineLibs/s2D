package s2d.graphics;

enum abstract BlendMode(Int) to Int {
	var Opaque = 0;
	var AlphaClip = 1;
	#if (S2D_SHADING_FORWARD || S2D_SHADING_MIXED)
	var AlphaBlend = 2;
	#end
}
