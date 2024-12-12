package s2d.graphics;

import kha.Canvas;

@:allow(s2d.S2D)
interface RenderPath {
	private var stage:S2D;

	private function resize(width:Int, height:Int):Void;
	private function render(target:Canvas):Void;
}
