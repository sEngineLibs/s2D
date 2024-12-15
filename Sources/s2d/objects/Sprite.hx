package s2d.objects;

import kha.Canvas;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexStructure;
// s2d
import s2d.graphics.materials.Material;

@:structInit
class Sprite extends Object {
	var structSize:Int;
	var vertices:VertexBuffer;
	var indices:IndexBuffer;

	public var material:Material;

	public inline function new(stage:S2D) {
		super(stage);

		var struct = new VertexStructure();
		struct.add("vertPos", Float32_3X);
		struct.add("vertUV", Float32_2X);
		structSize = 5;

		vertices = new VertexBuffer(4, struct, StaticUsage);

		var vertData = vertices.lock();
		for (i in 0...4) {
			var offset = i * structSize;
			vertData[offset + 0] = 0; // X
			vertData[offset + 1] = 0; // Y
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

	public inline function draw(target:Canvas) {
		material.draw(target, vertices, indices);
	}
}
