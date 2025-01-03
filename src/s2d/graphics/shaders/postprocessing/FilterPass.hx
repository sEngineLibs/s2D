package s2d.graphics.shaders.postprocessing;

#if S2D_PP_FILTER
import kha.graphics4.Graphics;
import kha.graphics4.ConstantLocation;

@:allow(s2d.graphics.RenderPath)
class FilterPass extends PostProcessingPass {
	var kernelCL:ConstantLocation;

	override inline function getUniforms() {
		kernelCL = pipeline.getConstantLocation("kernel");
	}

	override inline function setUniforms(g:Graphics, ?uniforms:Array<Dynamic>) {
		g.setMatrix3(kernelCL, uniforms[0]);
	}
}
#end
