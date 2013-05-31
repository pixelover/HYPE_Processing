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
public static class HVertexNEW implements HLocatable {
	private HPathNEW _parent;
	private float[] _cpts;
	private float _u, _v;
	public HVertexNEW(HPathNEW parent) {
		_parent = parent;
	}
	public HPathNEW parent() {
		return _parent;
	}
	public HVertexNEW createCopy() {
		HVertexNEW copy = new HVertexNEW(_parent);
		copy._u = _u;
		copy._v = _v;
		if(_cpts != null) {
			copy._cpts = new float[_cpts.length];
			for(int i=0; i<_cpts.length; ++i) copy._cpts[i] = _cpts[i];
		}
		return copy;
	}
	public boolean isCurved() {
		return (_cpts != null);
	}
	public boolean isQuadratic() {
		return (_cpts != null) && (_cpts.length == 2);
	}
	public boolean isCubic() {
		return (_cpts != null) && (_cpts.length >= 4);
	}
	private float x2u(float px) {
		return _parent.anchorPercX() + _parent.x2u(px);
	}
	private float y2v(float px) {
		return _parent.anchorPercY() + _parent.y2v(px);
	}
	private float u2x(float pc) {
		return _parent.u2x(pc-_parent.anchorPercX());
	}
	private float v2y(float pc) {
		return _parent.v2y(pc-_parent.anchorPercY());
	}
	public HVertexNEW set(float xpx, float ypx) {
		return setUV( x2u(xpx), y2v(ypx) );
	}
	public HVertexNEW set(float cx, float cy, float xpx, float ypx) {
		return setUV( x2u(cx),y2v(cy), x2u(xpx),y2v(ypx) );
	}
	public HVertexNEW set(
		float cx1,float cy1, float cx2,float cy2, float xpx,float ypx
	) {
		return setUV(
			x2u(cx1), y2v(cy1),  x2u(cx2), y2v(cy2),
			x2u(xpx), y2v(ypx));
	}
	public HVertexNEW setUV(float newU, float newV) {
		_u = newU;
		_v = newV;
		return this;
	}
	public HVertexNEW setUV(float cx1, float cy1, float xpc, float ypc) {
		if(_cpts==null || _cpts.length!=2) _cpts = new float[2];
		_cpts[0] = cx1;
		_cpts[1] = cy1;
		return setUV(xpc,ypc);
	}
	public HVertexNEW setUV(
		float cu1,float cv1, float cu2,float cv2, float newU,float newV
	) {
		if(_cpts==null || _cpts.length<4) _cpts = new float[4];
		_cpts[0] = cu1;
		_cpts[1] = cv1;
		_cpts[2] = cu2;
		_cpts[3] = cv2;
		return setUV(newU,newV);
	}
	public float cx1() {
		return (_cpts==null||_cpts.length<4)? 0 : u2x(_cpts[0]);
	}
	public float cy1() {
		return (_cpts==null||_cpts.length<4)? 0 : v2y(_cpts[1]);
	}
	public float cx2() {
		return (_cpts==null||_cpts.length<4)? 0 : u2x(_cpts[2]);
	}
	public float cy2() {
		return (_cpts==null||_cpts.length<4)? 0 : v2y(_cpts[3]);
	}
	public float cu1() {
		return (_cpts==null||_cpts.length<4)? 0 : _cpts[0];
	}
	public float cv1() {
		return (_cpts==null||_cpts.length<4)? 0 : _cpts[1];
	}
	public float cu2() {
		return (_cpts==null||_cpts.length<4)? 0 : _cpts[2];
	}
	public float cv2() {
		return (_cpts==null||_cpts.length<4)? 0 : _cpts[3];
	}
	public float x() {
		return u2x(_u);
	}
	public HVertexNEW x(float xpx) {
		_u = x2u(xpx);
		return this;
	}
	public float y() {
		return v2y(_v);
	}
	public HLocatable y(float ypx) {
		_v = y2v(ypx);
		return this;
	}
	public float u() {
		return _u;
	}
	public float v() {
		return _v;
	}
	public float z() {
		return 0;
	}
	public HVertexNEW z(float pxZ) {
		return this;
	}
	public void computeMinMax(float[] minmax) {
		if(_u < minmax[0]) minmax[0] = _u;
		else if(_u > minmax[2]) minmax[2] = _u;
		if(_v < minmax[1]) minmax[1] = _u;
		else if(_v > minmax[3]) minmax[3] = _u;
		if(_cpts == null) return;
		for(int i=0; i<4; ++i) {
			int min = (i&1)==0? 0 : 1;
			int max = min + 2;
			if(_cpts[i] < minmax[min]) minmax[min] = _cpts[i];
			else if(_cpts[i] > minmax[max]) minmax[max] = _cpts[i];
		}
	}
	public void adjust(float minx, float miny, float wpc, float hpc) {
		_u = (_u-minx) / wpc;
		_v = (_v-miny) / hpc;
		if(_cpts != null) for(int i=0; i<_cpts.length; ++i) {
			float min, pc;
			if((i&1)==0) {
				min = minx;
				pc = wpc;
			} else {
				min = miny;
				pc = hpc;
			}
			_cpts[i] = (_cpts[i]-min) / pc;
		}
	}
	public int getCrossings(HVertexNEW prev, float tx, float ty) {
		return 0; 
	}
	public void draw(PGraphics g, boolean isSimple) {
		if(_cpts==null || isSimple) {
			g.vertex(u2x(_u), v2y(_v));
		} else if(_cpts.length==2) {
			g.quadraticVertex(
				u2x(_cpts[0]), v2y(_cpts[1]),
				u2x(_u), v2y(_v));
		} else {
			g.bezierVertex(
				u2x(_cpts[0]), v2y(_cpts[1]),
				u2x(_cpts[2]), v2y(_cpts[3]),
				u2x(_u), v2y(_v));
		}
	}
}