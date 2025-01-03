package s2d.objects;

import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexStructure;
// s2d
import s2d.graphics.materials.Material;

class Sprite extends Object {
	public static var indices:IndexBuffer;
	public static var vertices:VertexBuffer;

	public static inline function init() {
		// init indices
		indices = new IndexBuffer(6, StaticUsage);
		var ind = indices.lock();
		ind[0] = 0;
		ind[1] = 1;
		ind[2] = 2;
		ind[3] = 3;
		ind[4] = 2;
		ind[5] = 0;
		indices.unlock();

		// init structure
		var structure = new VertexStructure();
		structure.add("vertPos", Float32_3X);
		structure.add("vertUV", Float32_2X);
		var structSize = 5;

		// init vertices
		vertices = new VertexBuffer(4, structure, StaticUsage);
		var vert = vertices.lock();
		for (i in 0...4) {
			vert[i * structSize + 0] = i == 0 || i == 1 ? -1.0 : 1.0;
			vert[i * structSize + 1] = i == 0 || i == 3 ? -1.0 : 1.0;
			vert[i * structSize + 2] = 0.0;
			vert[i * structSize + 3] = i == 0 || i == 1 ? 0.0 : 1.0;
			vert[i * structSize + 4] = i == 0 || i == 3 ? 0.0 : 1.0;
		}
		vertices.unlock();
	}

	public var material:Material = new Material();

	public inline function new() {
		super();
		S2D.stage.sprites.push(this);
	}
}
