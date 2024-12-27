package;

import kha.math.FastMatrix4;
import s2d.graphics.PostProcessing;
import kha.input.Mouse;
import s2d.graphics.Compositor;
import s2d.objects.Light;
import kha.System;
import kha.Assets;
import kha.Scheduler;
// s2d
import s2d.S2D;
import s2d.objects.Sprite;

using s2d.utils.FastMatrix4Ext;

class Main {
	public static function main() {
		S2D.setup = function() {
			var sprite = new Sprite();
			sprite.material.colorMap = Assets.images.get("color");
			var light = new Light();
			light.location.z = 0.1;
			light.power = 25;

			Compositor.distortion.strength = 0.5;

			Mouse.get().notify(null, null, function(x, y, xm, ym) {
				var p = S2D.screen2LocalSpace({x: x, y: y});
				Compositor.distortion.x = p.x;
				Compositor.distortion.y = p.y;

				var p = S2D.screen2WorldSpace({x: x, y: y});
				light.location.x = p.x;
				light.location.y = p.y;
			}, function(delta:Int) {
				S2D.scale += delta * 0.1;
			});
		}

		System.start({
			title: "Project",
			width: 1024,
			height: 1024,
			framebuffer: {samplesPerPixel: 8}
		}, S2D.init);
	}
}
