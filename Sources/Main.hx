package;

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

class Main {
	public static function main() {
		S2D.scale = 1.0;
		S2D.distance = 2.0;

		S2D.setup = function() {
			var sprite = new Sprite();
			sprite.material.depthScale = 1.0;
			sprite.material.normalMap = Assets.images.get("normal");

			var light = new Light();
			light.z = 1.0;
			light.power = 25;

			Mouse.get().notify(null, null, function(x, y, xm, ym) {
				PostProcessing.dof.distance = 1.0 - x / 1024;
				var p = S2D.mapToProjection({x: x / 1024, y: y / 1024});
				light.x = p.x;
				light.y = p.y;
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
