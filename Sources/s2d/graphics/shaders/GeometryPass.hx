package s2d.graphics.shaders;

import kha.Canvas;
import kha.graphics4.Graphics;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexShader;
import kha.graphics4.FragmentShader;
import kha.graphics4.TextureUnit;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexStructure;
import kha.graphics4.ConstantLocation;

@:allow(s2d.graphics.RenderPath)
class GeometryPass implements Shader {
	var pipeline:PipelineState;
	var modelCL:ConstantLocation;
	var viewProjectionCL:ConstantLocation;
	var colorMapTU:TextureUnit;
	var normalMapTU:TextureUnit;
	var ormMapTU:TextureUnit;
	var glowMapTU:TextureUnit;
	var paramsCL:ConstantLocation;

	public inline function new() {}

	inline function setUniforms(g:Graphics, ?uniforms:Array<Dynamic>) {}

	inline function getUniforms() {}

	inline function compile(frag:FragmentShader, ?vert:VertexShader) {
		var structure = new VertexStructure();
		structure.add("vertPos", Float32_3X);
		structure.add("vertUV", Float32_2X);

		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = vert;
		pipeline.fragmentShader = frag;
		pipeline.alphaBlendSource = SourceAlpha;
		pipeline.alphaBlendDestination = InverseSourceAlpha;
		pipeline.blendSource = BlendOne;
		pipeline.blendDestination = InverseSourceAlpha;
		pipeline.compile();

		modelCL = pipeline.getConstantLocation("model");
		viewProjectionCL = pipeline.getConstantLocation("viewProjection");
		colorMapTU = pipeline.getTextureUnit("colorMap");
		normalMapTU = pipeline.getTextureUnit("normalMap");
		ormMapTU = pipeline.getTextureUnit("ormMap");
		glowMapTU = pipeline.getTextureUnit("glowMap");
		paramsCL = pipeline.getConstantLocation("Params");
	}

	inline function render(target:Canvas, indices:IndexBuffer, vertices:VertexBuffer, ?uniforms:Array<Dynamic>):Void {}
}
