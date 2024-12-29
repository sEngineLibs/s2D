package s2d.graphics.shaders;

import kha.Shaders;
import kha.graphics4.TextureUnit;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexStructure;
import kha.graphics4.ConstantLocation;

class PostProcessingPass {
	public static var pipeline:PipelineState;

	public static var positionMapTU:TextureUnit;
	public static var resolutionCL:ConstantLocation;
	public static var paramsCL:ConstantLocation;

	public static function compile() {
		var structure = new VertexStructure();
		structure.add("vertexPosition", Float32_3X);
		structure.add("vertexUV", Float32_2X);
		structure.add("vertexColor", UInt8_4X_Normalized);

		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = Shaders.painter_image_vert;
		pipeline.fragmentShader = Shaders.postprocessing_pass_frag;
		pipeline.compile();

		positionMapTU = pipeline.getTextureUnit("positionMap");
		resolutionCL = pipeline.getConstantLocation("resolution");
		paramsCL = pipeline.getConstantLocation("Params");
	}
}
