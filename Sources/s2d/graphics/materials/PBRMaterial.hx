package s2d.graphics.materials;

import kha.Image;
import kha.Color;
import kha.Canvas;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
// s2d
import s2d.graphics.shaders.PBRShader;

class PBRMaterial implements Material {
	#if S2D_BATCHING
	@readonly var batch:PBRMaterialBatch;
	@readonly var instanceID:Int;

	public var diffuseMap(get, set):Image;
	public var emissionMap(get, set):Image;
	public var normalMap(get, set):Image;
	public var ormMap(get, set):Image;
	@:isVar public var diffuseColor(default, set):Color;
	@:isVar public var emissionColor(default, set):Color;
	@:isVar public var normalColor(default, set):Color;
	@:isVar public var ormColor(default, set):Color;
	public var blendMode(get, set):BlendMode;

	public inline function new(stage:S2D) {
		super(stage);
	}

	public inline function set_blendMode(value:BlendMode):BlendMode {
		batch.blendModeArr[instanceID] = value;
		return value;
	}

	inline function set_diffuseMap(value:Image):Image {
		batch.setMapInstance(0, instanceID, value);
		return value;
	}

	inline function set_emissionMap(value:Image):Image {
		batch.setMapInstance(1, instanceID, value);
		return value;
	}

	inline function set_normalMap(value:Image):Image {
		batch.setMapInstance(2, instanceID, value);
		return value;
	}

	inline function set_ormMap(value:Image):Image {
		batch.setMapInstance(3, instanceID, value);
		return value;
	}

	function set_diffuseColor(value:Color):Color {
		diffuseColor = value;
		batch.setMapInstanceColor(0, instanceID, value);
		return value;
	}

	function set_emissionColor(value:Color):Color {
		emissionColor = value;
		batch.setMapInstanceColor(1, instanceID, value);
		return value;
	}

	function set_normalColor(value:Color):Color {
		normalColor = value;
		batch.setMapInstanceColor(2, instanceID, value);
		return value;
	}

	function set_ormColor(value:Color):Color {
		ormColor = value;
		batch.setMapInstanceColor(3, instanceID, value);
		return value;
	}
	#else
	public var diffuseMap:Image;
	public var emissionMap:Image;
	public var normalMap:Image;
	public var ormMap:Image;
	@:isVar public var diffuseColor(default, set):Color;
	@:isVar public var emissionColor(default, set):Color;
	@:isVar public var normalColor(default, set):Color;
	@:isVar public var ormColor(default, set):Color;
	public var blendMode:BlendMode;

	inline function setMapColor(map:Image, color:Color) {
		map.g2.begin(true, color);
		map.g2.end();
	}

	function set_diffuseColor(value:Color):Color {
		diffuseColor = value;
		setMapColor(diffuseMap, value);
		return value;
	}

	function set_emissionColor(value:Color):Color {
		emissionColor = value;
		setMapColor(emissionMap, value);
		return value;
	}

	function set_normalColor(value:Color):Color {
		normalColor = value;
		setMapColor(normalMap, value);
		return value;
	}

	function set_ormColor(value:Color):Color {
		ormColor = value;
		setMapColor(ormMap, value);
		return value;
	}

	public function render(target:Canvas, vertices:VertexBuffer, indices:IndexBuffer, lights:Array<Light>) {
		for (light in lights)
			PBRShader.lighting.draw(target, vertices, indices, diffuseMap, emissionMap, normalMap, ormMap, light.x, light.y, light.z, light.color.R,
				light.color.G, light.color.B, light.power, light.radius);
	};
	}
