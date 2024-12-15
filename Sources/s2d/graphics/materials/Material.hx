package s2d.graphics.materials;

import kha.Canvas;
import kha.math.FastVector2;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;

interface Material {
	public var blendMode:BlendMode;
	public var shadowCast:Bool;
	public var shadowMode:BlendMode;
	public var shadowVerts:Array<FastVector2>;

	public function draw(target:Canvas, vertices:VertexBuffer, indices:IndexBuffer, ?uniforms:Array<Dynamic>):Void;
}
