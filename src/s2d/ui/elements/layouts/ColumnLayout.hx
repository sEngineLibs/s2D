package s2d.ui.elements.layouts;

import kha.Canvas;
// s2d
import s2d.math.VectorMath;
import s2d.ui.positioning.Alignment;

class ColumnLayout extends UIElement {
	public var spacing:Float = 0.0;

	override function render(target:Canvas) {
		final g2 = target.g2;

		g2.transformation = finalModel;
		#if (S2D_UI_DEBUG_ELEMENT_BOUNDS == 1)
		g2.color = White;
		g2.opacity = 0.75;
		g2.drawRect(x, y, width, height, 2.0);
		#end
		g2.opacity = finalOpacity;

		var cells = [];
		var cellsHeight = 0.0;
		var fillCellCount = 0;
		for (child in children) {
			if (child.visible) {
				var cell = {
					element: child,
					height: null
				}
				if (child.layout.fillHeight)
					++fillCellCount;
				else {
					var h = child.height - child.layout.topMargin - child.layout.bottomMargin;
					cell.height = h;
					cellsHeight += h;
				}
				cells.push(cell);
			}
		}

		var fillCellHeight = 1 / fillCellCount * (availableHeight - (cells.length - 1) * spacing - cellsHeight);

		var _y = y + top.padding;
		for (c in cells) {
			final e = c.element;

			var _x = x + left.padding;
			var _w, _h;

			// x offset
			var xo = e.layout.leftMargin;
			// y offset
			var yo = e.layout.topMargin;
			// cell width
			if (!e.layout.fillWidth) {
				_w = clamp(e.width, 0.0, availableWidth);
				if (e.layout.alignment & Alignment.HCenter != 0)
					xo += (availableWidth - _w) / 2;
				else if (e.layout.alignment & Alignment.Right != 0)
					xo += availableWidth - _w;
			} else
				_w = availableWidth - e.layout.leftMargin - e.layout.rightMargin;
			// cell height
			if (e.layout.fillHeight)
				_h = fillCellHeight;
			else
				_h = c.height;

			e.setPosition(_x + xo, _y + yo);
			e.setSize(_w, _h);
			e.render(target);

			_y += _h + spacing;
		}
	}
}
