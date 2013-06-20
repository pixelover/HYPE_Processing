/*
 * HYPE_Processing
 * http:
 * 
 * Copyright (c) 2013 Joshua Davis & James Cruz
 * 
 * Distributed under the BSD License. See LICENSE.txt for details.
 * 
 * All rights reserved.
 */
public static class HSphere extends HDrawable3D {
	/*
	 * radius(float)
	 * fix w/h/d
	 * FIXME
	 */
	public HDrawable createCopy() {
		HSphere copy = new HSphere();
		copy.copyPropertiesFrom(this);
		copy._depth = _depth;
		copy._anchorW = _anchorW;
		return this;
	}
	public void draw( PGraphics g, boolean usesZ,
		float drawX, float drawY, float currAlphaPc
	) {
		applyStyle(g, currAlphaPc);
		g.pushMatrix();
			g.translate(drawX, drawY, -anchorZ());
		g.popMatrix();
	}
}
