package s2d.graphics.shaders;

import kha.Shaders;
import kha.graphics4.TextureUnit;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexStructure;
import kha.graphics4.ConstantLocation;

class CompositorPass {
	public static var pipeline:PipelineState;

	public static var textureMapTU:TextureUnit;
	public static var resolutionCL:ConstantLocation;
	public static var paramsCL:ConstantLocation;

	public static function compile() {
		var structure = new VertexStructure();
		structure.add("vertCoord", Float32_2X);

		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = Shaders.s2d_2d_vert;
		pipeline.fragmentShader = Shaders.compositor_pass_frag;
		pipeline.compile();

		textureMapTU = pipeline.getTextureUnit("textureMap");
		resolutionCL = pipeline.getConstantLocation("resolution");
		paramsCL = pipeline.getConstantLocation("Params");
	}
}
