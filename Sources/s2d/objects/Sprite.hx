package s2d.objects;

import kha.FastFloat;
import kha.math.FastMatrix4;
import kha.Canvas;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexStructure;
// s2d
import s2d.graphics.materials.Material;
import s2d.graphics.materials.PBRMaterial;

@:structInit
class Sprite extends Object {
	var vertices:VertexBuffer;
	var indices:IndexBuffer;
	var model:FastMatrix4 = FastMatrix4.identity();

	public var material:Material = new PBRMaterial();

	public inline function new(stage:S2D) {
		super(stage);

		var struct = new VertexStructure();
		struct.add("vertPos", Float32_3X);
		struct.add("vertUV", Float32_2X);
		var structSize = struct.byteSize() >> 2;

		vertices = new VertexBuffer(4, struct, StaticUsage);
		var vertData = vertices.lock();
		for (i in 0...4) {
			var offset = i * structSize;
			vertData[offset + 0] = i == 2 || i == 3 ? 1 : -1; // X
			vertData[offset + 1] = i == 1 || i == 2 ? 1 : -1; // Y
			vertData[offset + 2] = 0; // Z
			vertData[offset + 3] = i == 2 || i == 3 ? 1 : 0; // U
			vertData[offset + 4] = i == 1 || i == 2 ? 1 : 0; // V
		}
		vertices.unlock();

		indices = new IndexBuffer(6, StaticUsage);
		var ind = indices.lock();
		ind[0] = 0;
		ind[1] = 1;
		ind[2] = 2;
		ind[3] = 3;
		ind[4] = 2;
		ind[5] = 0;
		indices.unlock();
	}

	override inline function rotate(angle:FastFloat) {
		model = model.multmat(FastMatrix4.rotationZ(angle));
	}

	override inline function scale(x:FastFloat, y:FastFloat) {
		model = model.multmat(FastMatrix4.scale(x, y, 1));
	}

	override inline function translate(x:FastFloat, y:FastFloat) {
		model = model.multmat(FastMatrix4.translation(x, y, 0));
	}

	public inline function render(target:Canvas) {
		material.render(target, vertices, indices, model);
	}
}
