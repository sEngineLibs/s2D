import kha.Image;
import kha.Color;
import kha.System;
import kha.Assets;
import kha.math.FastVector2;
// s2d
import s2d.S2D;
import s2d.objects.Sprite;
import s2d.objects.PointLight;

inline function pickClosest(x:Float, y:Float, sprites:Array<Sprite>):Sprite {
	var minDist = Math.POSITIVE_INFINITY;
	var closest = null;
	for (sprite in sprites) {
		var v = sprite.vertices;
		var cp:FastVector2 = {
			x: (v[0].x + v[1].x + v[2].x + v[3].x) / 4,
			y: (v[0].y + v[1].y + v[2].y + v[3].y) / 4
		};

		var dist = Math.sqrt((x - cp.x) * (x - cp.x) + (y - cp.y) * (y - cp.y));
		if (0.5 > dist && dist < minDist) {
			closest = sprite;
			minDist = dist;
		}
	}

	return closest;
}

class App extends sui.App {
	override inline function setup() {
		var stage = new S2D(scene);
		stage.anchors.fill(scene);

		var sprites = [];
		for (_ in 0...4) {
			var sprite = new Sprite(stage);
			sprite.blendMode = AlphaClip;
			sprite.vertices = [{x: -1, y: -1}, {x: -1, y: 0}, {x: 0, y: 0}, {x: 0, y: -1}];

			sprite.diffuseMap = Assets.images.get('diffuse');
			sprite.normalMap = Assets.images.get('normal');
			sprite.ormMap = Assets.images.get('orm');
			sprite.emissionColor = Color.fromFloats(0.025, 0.025, 0.025);

			sprites.push(sprite);
		}

		var light = new PointLight(stage);
		light.z = 0.1;

		var m = new MouseArea(scene);
		m.anchors.fill(scene);

		var moving = false;
		var movingSprite = sprites[0];

		m.notifyOnMove(function(x, y, mx, my) {
			if (!moving) {
				var mv = pickClosest(x / m.width * 2 - 1, y / m.height * 2 - 1, sprites);
				if (mv != movingSprite)
					movingSprite = mv;
			} else if (movingSprite != null)
				movingSprite.translate(mx / m.width * 2, my / m.height * 2);
		});
		m.notifyOnDown(function(button, x, y) {
			if (button == 0) {
				moving = true;
				if (movingSprite != null)
					movingSprite.scale(0.9, 0.9);
			} else if (button == 1)
				if (movingSprite != null)
					movingSprite.scale(1 / 0.9, 1 / 0.9);
		});
		m.notifyOnUp(function(button, x, y) {
			if (button == 0)
				moving = false;
		});

		SUI.notifyOnUpdate(function() {
			light.x = Math.sin(System.time) * 0.5 + 0.5;
			light.y = Math.cos(System.time) * 0.5 + 0.5;
		});
	}
}

class Main {
	public static function main() {
		var app = new App(756, 756);
		SUI.start(app);
	}
}
