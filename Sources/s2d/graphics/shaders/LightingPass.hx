package s2d.graphics.shaders;

import kha.Shaders;
import kha.graphics4.TextureUnit;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexStructure;
import kha.graphics4.ConstantLocation;

class LightingPass {
	public static var pipeline:PipelineState;

	public static var positionMapTU:TextureUnit;
	public static var colorMapTU:TextureUnit;
	public static var normalMapTU:TextureUnit;
	public static var ormMapTU:TextureUnit;
	public static var glowMapTU:TextureUnit;
	public static var stageScaleCL:ConstantLocation;
	public static var lightPosCL:ConstantLocation;
	public static var lightColorCL:ConstantLocation;
	public static var lightAttribCL:ConstantLocation;

	public static function compile() {
		var structure = new VertexStructure();
		structure.add("vertPos", Float32_2X);

		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = Shaders.s2d_2d_vert;
		pipeline.fragmentShader = Shaders.lighting_pass_frag;
		pipeline.blendSource = BlendOne;
		pipeline.blendDestination = BlendOne;
		pipeline.blendOperation = Add;
		pipeline.compile();

		positionMapTU = pipeline.getTextureUnit("positionMap");
		colorMapTU = pipeline.getTextureUnit("colorMap");
		normalMapTU = pipeline.getTextureUnit("normalMap");
		ormMapTU = pipeline.getTextureUnit("ormMap");
		glowMapTU = pipeline.getTextureUnit("glowMap");
		stageScaleCL = pipeline.getConstantLocation("stageScale");
		lightPosCL = pipeline.getConstantLocation("lightPos");
		lightColorCL = pipeline.getConstantLocation("lightColor");
		lightAttribCL = pipeline.getConstantLocation("lightAttrib");
	}
}
