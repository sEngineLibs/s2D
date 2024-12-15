package s2d.graphics.materials;

import kha.Canvas;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;

interface Material {
	public function draw(target:Canvas, vertices:VertexBuffer, indices:IndexBuffer):Void;
}
