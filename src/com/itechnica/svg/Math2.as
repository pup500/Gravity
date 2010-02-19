class com.itechnica.svg.Math2 {
	
/**
* @class Math2
* @author Helen Triolo, with inclusions from Robert Penner, Tim Groleau
* @description Math functions not included in Math needed for path->array conversion
*/

/**
* @method ratioTo (Groleau)
* @description Returns the point on segment [p1,p2] which is ratio times the total distance 
*				between p1 and p2 away from p1
* @param p1 (Object) x and y values of point p1
* @param p2 (Object) x and y values of point p2
* @param ratio (Number) real
* @returns Object
*/
	public static function ratioTo(p1:Object, p2:Object, ratio:Number):Object {
		return {x:p1.x + (p2.x - p1.x) * ratio, y:p1.y + (p2.y - p1.y) * ratio };
	}
/**
* @method intersect2Lines (Penner)
* @description Returns the point of intersection between two lines
* @param p1, p2 (Objects) points on line 1
* @param p3, p4 (Objects) points on line 2
* @returns Object (point of intersection)
*/

	public static function intersect2Lines (p1, p2, p3, p4):Object {
		var x1 = p1.x; var y1 = p1.y;
		var x4 = p4.x; var y4 = p4.y;
	    var dx1 = p2.x - x1;
	    var dx2 = p3.x - x4;

	   if (!(dx1 || dx2)) return NaN;
	   var m1 = (p2.y - y1) / dx1;
	   var m2 = (p3.y - y4) / dx2;
	   if (!dx1) {
	      return { x:x1, y:m2 * (x1 - x4) + y4 };
	   } else if (!dx2) {
	      return { x:x4, y:m1 * (x4 - x1) + y1 };
	   }
	   var xInt = (-m2 * x4 + y4 + m1 * x1 - y1) / (m1 - m2);
	   var yInt = m1 * (xInt - x1) + y1;
	   return { x:xInt,y:yInt };
	}

/**
* @method rotation
* @description Returns the angle in degrees from the horizontal to a point dy up and dx over
* @param dy (Number) pixels
* @param dx (Number) pixels
* @returns Number (angle, degrees)
*/
	public static function rotation(dy, dx):Number {
		return Math.atan2(dy, dx) * 180/Math.PI;
	}

/**
* @method midPt
* @description Returns the midpoint (x/y) of a line segment from p1x/p1y to p2x/p2y
* @param p1x (Number) pixels
* @param p1y (Number) pixels
* @param p2x (Number) pixels
* @param p2y (Number) pixels
* @returns Object (midpoint)
*/
	public static function midPt(p1x, p1y, p2x, p2y) {
		return {x:(p1x + p2x)/2, y:(p1y + p2y)/2};
	}

/**
* @method getQuadBez_RP (Penner)
* @description  Approximates a cubic bezier with as many quadratic bezier segments (n) as required 
*			to achieve a specified tolerance
* @param p1 (Object) endpoint
* @param c1 (Object) 1st control point
* @param c2 (Object) 2nd control point
* @param p2 (Object) endpoint
* @param k: tolerance (low number = most accurate result)
* @param qcurves (Array) will contain array of quadratic bezier curves, each element containing
*		p1x, p1y, cx, cy, p2x, p2y
*/
 	public static function getQuadBez_RP(p1, c1, c2, p2, k, qcurves) {
		// find intersection between bezier arms
		var s:Object = Math2.intersect2Lines (p1, c1, c2, p2);
		// find distance between the midpoints
		var dx = (p1.x + p2.x + s.x * 4 - (c1.x + c2.x) * 3) * .125;
		var dy = (p1.y + p2.y + s.y * 4 - (c1.y + c2.y) * 3) * .125;
		// split curve if the quadratic isn't close enough
		if (dx*dx + dy*dy > k) {
			var halves = Math2.bezierSplit (p1.x, p1.y, c1.x, c1.y, c2.x, c2.y, p2.x, p2.y);
			var b0 = halves.b0; var b1 = halves.b1;
			// recursive call to subdivide curve
			getQuadBez_RP (p1,     b0.c1, b0.c2, b0.p2, k, qcurves);
			getQuadBez_RP (b1.p1,  b1.c1, b1.c2, p2,    k, qcurves);
		} else {
			// end recursion by saving points
			qcurves.push({p1x:p1.x, p1y:p1.y, cx:s.x, cy:s.y, p2x:p2.x, p2y:p2.y});
		}
	}
		
/**
* @method bezierSplit (Penner)
* @description    Divides a cubic bezier curve into two halves (each also cubic beziers)
* @param p1x (Number) pixels, endpoint 1
* @param p1y (Number) pixels
* @param c1x (Number) pixels, control point 1
* @param c1y (Number) pixels
* @param c2x (Number) pixels, control point 2
* @param c2y (Number) pixels
* @param p2x (Number) pixels, endpoint 2
* @param p2y (Number) pixels
* @returns Object (object with two cubic bezier definitions, b0 and b1)
*/
	public static function bezierSplit(p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y):Object {
	    var m = Math2.midPt;
		var p1:Object = {x:p1x, y:p1y};
		var p2:Object = {x:p2x, y:p2y};
	    var p01:Object = m (p1x, p1y, c1x, c1y);
	    var p12:Object = m (c1x, c1y, c2x, c2y);
	    var p23:Object = m (c2x, c2y, p2x, p2y);
	    var p02:Object = m (p01.x, p01.y, p12.x, p12.y);
	    var p13:Object = m (p12.x, p12.y, p23.x, p23.y);
	    var p03:Object = m (p02.x, p02.y, p13.x, p13.y);

		/*
        b0:{a:p0,  b:p01, c:p02, d:p03},
        b1:{a:p03, b:p13, c:p23, d:p3 }  
		*/

		return { b0:{p1:p1, c1:p01, c2:p02, p2:p03}, b1:{p1:p03, c1:p13, c2:p23, p2:p2} };
	}

/**
* @method pointOnCurve (Penner)
* @description Returns a point on a quadratic bezier curve with Robert Penner's optimization 
*				of the standard equation:
*					{x:p1x * (1-t) * (1-t) + 2 * cx * t * (1-t) + p2x * t * t,
*		             y:p1y * (1-t) * (1-t) + 2 * cy * t * (1-t) + p2y * t * t }
* @param p1x (Number) pixels, endpoint 1
* @param p1y (Number) pixels
* @param cx (Number) pixels, control point 
* @param cy (Number) pixels
* @param p2x (Number) pixels, endpoint 2
* @param p2y (Number) pixels
* @param t (Number) if time is 0-1 along curve, value of t to find point at
* @returns Object (point at time t)
*/
	public static function pointOnCurve(p1x, p1y, cx, cy, p2x, p2y, t):Object {
		var o:Object = new Object();
		o.x = p1x + t*(2*(1-t)*(cx-p1x) + t*(p2x - p1x));
		o.y = p1y + t*(2*(1-t)*(cy-p1y) + t*(p2y - p1y));
		return o;
	}

/**
* @method pointsOnCurve (Penner)
* @description Returns an array of objects defining points on a quadratic bezier curve, each of which
*				includes:
*					x,y = location of point defining start of segment
*					r = rotation of segment (last entry has none because it's just a point)
*					n = number of subdivisions into which curve will be divided (pts = n+1)
* @param p1x (Number) pixels, endpoint 1
* @param p1y (Number) pixels
* @param cx (Number) pixels, control point 
* @param cy (Number) pixels
* @param p2x (Number) pixels, endpoint 2
* @param p2y (Number) pixels
* @param n (Number) number of points to return
* @returns Array
*/
	public static function pointsOnCurve(p1x, p1y, cx, cy, p2x, p2y, n):Array {
		var pts:Array = [];
		for (var i=0; i <= n; i++) {
		   pts.push(Math2.pointOnCurve(p1x, p1y, cx, cy, p2x, p2y, i/n));
		   if (i > 0) {
			   pts[i].r = Math2.rotation(pts[i].y-pts[(i-1)].y, pts[i].x-pts[(i-1)].x);
		   }
		}
		pts.splice(0,1);  // remove 1st element to return 1/n, 2/n,... n
		return pts;
	}

/**
* @method pointsOnLine (Penner)
* @description Returns an array of point positions and rotations for n evenly spaced points 
*					along a line segment
*					x,y = location of point defining start of segment
*					r = rotation of segment (last entry has none because it's just a point)
*					n = number of subdivisions into which curve will be divided (pts = n+1)
* @param p1x (Number) pixels, endpoint 1
* @param p1y (Number) pixels
* @param p2x (Number) pixels, endpoint 2
* @param p2y (Number) pixels
* @param n (Number) number of points to return
* @returns Array
*//* ....................................................................
   Returns an array of point positions and rotation for n evenly spaced points along a line segment
*/
	public static function pointsOnLine(p1x, p1y, p2x, p2y, n):Array {
		var pts:Array = [];
		if (p2x != p1x) {
			var m = (p2y-p1y)/(p2x-p1x);
			var b = p1y - p1x * m;
			for (var i=0; i <= n; i++) {
				var x = p1x + ((p2x-p1x)/n) * i;
				pts.push({x:x, y:m*x+b});
				if (i > 0) {
					pts[i].r = Math2.rotation(pts[i].y-pts[(i-1)].y, pts[i].x-pts[(i-1)].x);
				}
			}
		// vertical segment
		} else {
			for (var i=0; i<=n; i++) {
				pts.push({x:p1x, y:p1y + ((p2y-p1y)/n) * i, r:90});
			}
		}			
		pts.splice(0,1);  // remove 1st element to return 1/n, 2/n,... n
		return pts;
	}

/**
* @method curveApproxLen
* @description Returns the approximate length of a curved segment, found by dividing it 
*				into two segments at t=0.5
* @param p1x (Number) pixels, endpoint 1
* @param p1y (Number) pixels
* @param cx (Number) pixels, control point 
* @param cy (Number) pixels
* @param p2x (Number) pixels, endpoint 2
* @param p2y (Number) pixels
* @returns Number
*/
	public static function curveApproxLen(p1x, p1y, cx, cy, p2x, p2y):Number {
		var mp:Object = Math2.pointOnCurve(p1x, p1y, cx, cy, p2x, p2y, 0.5);
		var len1:Number = Math.sqrt((mp.x - p1x) * (mp.x - p1x) + (mp.y - p1y) * (mp.y - p1y));
		var len2:Number = Math.sqrt((mp.x - p2x) * (mp.x - p2x) + (mp.y - p2y) * (mp.y - p2y));
		return len1+len2;
	}

/**
* @method lineLen
* @description Returns the length of a line segment
* @param p1x (Number) pixels, endpoint 1
* @param p1y (Number) pixels
* @param p2x (Number) pixels, endpoint 2
* @param p2y (Number) pixels
* @returns Number
*/
	public static function lineLen(p1x, p1y, p2x, p2y):Number {
		return Math.sqrt((p2x - p1x) * (p2x - p1x) + (p2y - p1y) * (p2y - p1y));
	}

/**
* @method roundTo
* @description Returns a number rounded to specified number of decimals 
* @param n (Number) 
* @param ndec (Number) number of decimals to round to
* @returns Number
*/
	public static function roundTo(n:Number, ndec:Number):Number {
		var multiplier:Number = Math.pow(10, ndec);
		return Math.round(n*multiplier)/multiplier;
	}
}