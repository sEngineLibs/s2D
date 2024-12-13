package s2d.graphics.materials;

import kha.Canvas;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
// s2d
import sui.core.graphics.shaders.Shader;

interface Material {
	public function render(target:Canvas, vertices:VertexBuffer, indices:IndexBuffer, ?uniforms:Dynamic):Void;
}
