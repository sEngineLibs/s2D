package s2d;

import kha.Image;
import kha.arrays.Float32Array;
import kha.math.FastMatrix4;
// s2d
import s2d.objects.Light;
import s2d.objects.Sprite;

@:allow(s2d.graphics.RenderPath)
class Stage {
	public var sprites:Array<Sprite> = [];
	public var lights:Array<Light> = [];
	public var camera:FastMatrix4;
	public var viewProjection(get, null):FastMatrix4;
	@:isVar public var environmentMap(default, set):Image;

	final maxLights:Int = 16;
	final lightStructSize:Int = 8;
	@:isVar var lightsData(get, null):Float32Array;

	inline function get_viewProjection() {
		return S2D.projection.multmat(camera);
	}

	public inline function new() {
		camera = FastMatrix4.lookAt({x: 0.0, y: 0.0, z: 0.0}, {x: 0.0, y: 0.0, z: -1.0}, {x: 0.0, y: 1.0, z: 0.0});
		lightsData = new Float32Array(1 * maxLights * lightStructSize);
	}

	inline function get_lightsData():Float32Array {
		lightsData[0] = lights.length;

		for (i in 0...lights.length) {
			var ind = 1 + i * lightStructSize;
			var light = lights[i];

			lightsData[ind + 0] = light.location.x;
			lightsData[ind + 1] = light.location.y;
			lightsData[ind + 2] = light.location.z;
			lightsData[ind + 3] = light.color.R;
			lightsData[ind + 4] = light.color.G;
			lightsData[ind + 5] = light.color.B;
			lightsData[ind + 6] = light.power;
			lightsData[ind + 7] = light.radius;
		}
		return lightsData;
	}

	inline function set_environmentMap(value:Image):Image {
		value.generateMipmaps(1);
		environmentMap = value;
		return value;
	}
}
