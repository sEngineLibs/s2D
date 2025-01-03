package s2d.graphics.shaders;

import kha.Canvas;
import kha.graphics4.Graphics;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.FragmentShader;
import kha.graphics4.VertexShader;

interface Shader {
	private var pipeline:PipelineState;

	private function getUniforms():Void;
	private function setUniforms(g:Graphics, ?uniforms:Array<Dynamic>):Void;
	private function compile(frag:FragmentShader, ?vert:VertexShader):Void;
	private function render(target:Canvas, indices:IndexBuffer, vertices:VertexBuffer, ?uniforms:Array<Dynamic>):Void;
}
