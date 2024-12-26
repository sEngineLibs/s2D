package;

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
		S2D.scale = 2;
		S2D.distance = 2;

		S2D.setup = function() {
			var sprite1 = new Sprite();
			sprite1.material.depthScale = 0.5;
			sprite1.material.colorMap = Assets.images.get("color");
			// sprite1.material.normalMap = Assets.images.get("normal");
			// sprite1.transformation.translate(-0.5, -0.5);

			var sprite2 = new Sprite();
			sprite2.material.depthScale = 0.5;
			sprite2.material.colorMap = Assets.images.get("color");
			sprite2.material.normalMap = Assets.images.get("normal");
			sprite2.transformation.translate(0.5, 0.5);

			// sprite1.setParent(sprite2);

			var light1 = new Light();
			light1.z = 0.5;
			light1.power = 10;

			Compositor.dof.focusDistance = 0.5;
			Compositor.dof.fStop = 12.0;

			Scheduler.addTimeTask(function() {
				// var d = Math.sin(System.time) + 1.0;
				// light1.z = d;
				sprite1.transformation.rotate(0.1);
				sprite2.transformation.rotate(0.1);
			}, 0, 1 / 165);
		}

		System.start({
			title: "Project",
			width: 1024,
			height: 1024,
			framebuffer: {samplesPerPixel: 8}
		}, S2D.init);
	}
}
