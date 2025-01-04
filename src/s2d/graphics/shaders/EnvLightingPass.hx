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

@:allow(s2d.graphics.RenderPath)
class EnvLightingPass implements Shader {
	var pipeline:PipelineState;

	var glowMapTU:TextureUnit;
	#if S2D_RP_ENV_LIGHTING
	var colorMapTU:TextureUnit;
	var normalMapTU:TextureUnit;
	var ormMapTU:TextureUnit;
	var envMapTU:TextureUnit;
	#end

	public inline function new() {}

	inline function setUniforms(g:Graphics, ?uniforms:Array<Dynamic>) {}

	inline function getUniforms() {}

	inline function compile(frag:FragmentShader, ?vert:VertexShader) {
		var structure = new VertexStructure();
		structure.add("vertCoord", Float32_2X);

		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = vert;
		pipeline.fragmentShader = frag;
		pipeline.blendSource = BlendOne;
		pipeline.blendDestination = BlendOne;
		pipeline.blendOperation = Add;
		pipeline.compile();

		glowMapTU = pipeline.getTextureUnit("glowMap");
		#if S2D_RP_ENV_LIGHTING
		colorMapTU = pipeline.getTextureUnit("colorMap");
		normalMapTU = pipeline.getTextureUnit("normalMap");
		ormMapTU = pipeline.getTextureUnit("ormMap");
		envMapTU = pipeline.getTextureUnit("envMap");
		#end
	}

	inline function render(target:Canvas, indices:IndexBuffer, vertices:VertexBuffer, ?uniforms:Array<Dynamic>):Void {}
}
