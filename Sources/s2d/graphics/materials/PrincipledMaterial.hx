package s2d.graphics.materials;

import kha.Image;
import kha.Assets;
import kha.FastFloat;

class PrincipledMaterial extends Material {
	public var depthScale:FastFloat = 0.0;
	public var colorMap:Image;
	public var normalMap:Image;
	public var ormMap:Image;
	public var emissionMap:Image;

	public inline function new() {
		super();

		colorMap = Assets.images.get("color_default");
		normalMap = Assets.images.get("normal_default");
		ormMap = Assets.images.get("orm_default");
		emissionMap = Assets.images.get("emission_default");
	}
}
