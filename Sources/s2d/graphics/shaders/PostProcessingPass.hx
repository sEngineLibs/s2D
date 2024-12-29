package s2d.graphics.shaders;

import kha.Shaders;
import kha.graphics4.TextureUnit;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexStructure;
import kha.graphics4.ConstantLocation;

class PostProcessingPass {
	public static var pipeline:PipelineState;

	public static var textureMapTU:TextureUnit;
	public static var positionMapTU:TextureUnit;
	public static var invVPCL:ConstantLocation;
	public static var cameraPosCL:ConstantLocation;
	public static var paramsCL:ConstantLocation;

	public static function compile() {
		var structure = new VertexStructure();
		structure.add("vertCoord", Float32_2X);

		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = Shaders.s2d_2d_vert;
		pipeline.fragmentShader = Shaders.postprocessing_pass_frag;
		pipeline.alphaBlendSource = SourceAlpha;
		pipeline.alphaBlendDestination = InverseSourceAlpha;
		pipeline.blendSource = SourceAlpha;
		pipeline.blendDestination = InverseSourceAlpha;
		pipeline.compile();

		textureMapTU = pipeline.getTextureUnit("textureMap");
		positionMapTU = pipeline.getTextureUnit("positionMap");
		paramsCL = pipeline.getConstantLocation("Params");
		invVPCL = pipeline.getConstantLocation("InvVP");
		cameraPosCL = pipeline.getConstantLocation("cameraPos");
	}
}
