package s2d.graphics.shaders;

import kha.Shaders;
import kha.graphics4.TextureUnit;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexStructure;
import kha.graphics4.ConstantLocation;

class GeometryPass {
	public static var pipeline:PipelineState;

	public static var modelCL:ConstantLocation;
	public static var viewProjectionCL:ConstantLocation;
	public static var colorMapTU:TextureUnit;
	public static var normalMapTU:TextureUnit;
	public static var ormMapTU:TextureUnit;
	public static var glowMapTU:TextureUnit;
	public static var paramsCL:ConstantLocation;

	public static function compile() {
		var structure = new VertexStructure();
		structure.add("vertPos", Float32_3X);
		structure.add("vertUV", Float32_2X);

		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.alphaBlendSource = SourceAlpha;
		pipeline.alphaBlendDestination = InverseSourceAlpha;
		pipeline.blendSource = BlendOne;
		pipeline.blendDestination = InverseSourceAlpha;
		pipeline.vertexShader = Shaders.geometry_pass_vert;
		pipeline.fragmentShader = Shaders.geometry_pass_frag;
		pipeline.compile();

		modelCL = pipeline.getConstantLocation("model");
		viewProjectionCL = pipeline.getConstantLocation("viewProjection");
		colorMapTU = pipeline.getTextureUnit("colorMap");
		normalMapTU = pipeline.getTextureUnit("normalMap");
		ormMapTU = pipeline.getTextureUnit("ormMap");
		glowMapTU = pipeline.getTextureUnit("glowMap");
		paramsCL = pipeline.getConstantLocation("Params");
	}
}
