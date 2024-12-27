package s2d.graphics.materials;

enum abstract BlendMode(Int) from Int to Int {
	var Opaque = 0;
	var AlphaClip = 1;
	var AlphaBlend = 2;
}
