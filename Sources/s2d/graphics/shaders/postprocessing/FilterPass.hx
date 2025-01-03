package s2d.graphics.shaders.postprocessing;

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
