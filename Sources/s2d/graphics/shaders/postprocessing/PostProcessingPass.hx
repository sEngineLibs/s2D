package s2d.graphics.shaders.postprocessing;

#if S2D_PP
import kha.Image;
import kha.Canvas;
import kha.Shaders;
import kha.graphics4.Graphics;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.FragmentShader;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexStructure;
import kha.graphics4.TextureUnit;
import kha.graphics4.ConstantLocation;

@:allow(s2d.graphics.RenderPath)
class PostProcessingPass implements Shader {
	var pipeline:PipelineState;

	var textureMapTU:TextureUnit;
	var resolutionCL:ConstantLocation;

	public inline function new() {}

	function getUniforms():Void {}

	function setUniforms(g:Graphics, ?uniforms:Array<Dynamic>):Void {}

	inline function compile(frag:FragmentShader, ?vert:VertexShader):Void {
		var structure = new VertexStructure();
		structure.add("vertCoord", Float32_2X);

		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = Shaders.s2d_2d_vert;
		pipeline.fragmentShader = frag;
		pipeline.compile();

		textureMapTU = pipeline.getTextureUnit("textureMap");
		resolutionCL = pipeline.getConstantLocation("resolution");
		getUniforms();
	}

	inline function render(target:Canvas, indices:IndexBuffer, vertices:VertexBuffer, ?uniforms:Array<Dynamic>):Void {
		var g2 = target.g2;
		var g4 = target.g4;

		var textureMap:Image = cast uniforms[0];

		g2.begin();
		g4.setPipeline(pipeline);
		g4.setIndexBuffer(indices);
		g4.setVertexBuffer(vertices);
		g4.setTexture(textureMapTU, textureMap);
		g4.setFloat2(resolutionCL, textureMap.width, textureMap.height);
		setUniforms(g4, uniforms.slice(1));
		g4.drawIndexedVertices();
		g2.end();
	}
}
#end
