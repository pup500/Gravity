import com.itechnica.svg.Math2;
import com.itechnica.svg.String2;

/**
* @class PathToArray
* @author Helen Triolo (with contributions from many people)
* @version 1.01 
* @description  Takes as input an SVG Path node (eg, from Illustrator 10, SVG Factory, etc, but must
*			not contain any CRLF characters), and an empty array. 
*			Parses the path node to make an array of drawing commands, which include cubic bezier 
*			draw commands.  Converts the cubic beziers to an array of equivalent quad beziers, 
*			using Robert Penner's code to convert with accuracy within 1 pixel.  
*			Drawing commands are produced in the format originally devised by Peter Hall
*           in his ASVDrawing class.  These are the possible elements in array dCmds (and the 
*			corresponding Flash drawing API commands to apply them):
*				['M',[x,y]]					moveTo(x,y)
*				['L',[x,y]]					lineTo(x,y)
*				['C',[cx,cy,ax,ay]]			moveTo(cx,cy,ax,ay)
*				['S',[width,color,alpha]]	lineStyle(widtb,color,alpha)
*				['F',[color,alpha]]			beginFill(color,alpha)
*				['EF']						endFill()
* History:
*	v1.00		2005/11/13	Original release
*	v1.01		2006/05/06	Stroke corrected to stroke, line 250 (thanks Gábor Szabó)
*
* @param svgnode (XMLNode) Path node from SVG file
* @param dCmds (Array) Empty array to write commands to
*/

class com.itechnica.svg.PathToArray {

	private var drawCmds:Array;
	private var fill:Object;
	private var stroke:Object;
		
	public function PathToArray(svgNode:XMLNode, dCmds:Array) {
		drawCmds = dCmds;
		var svgCmds:Array = extractCmds(svgNode);
		makeDrawCmds(svgCmds);
	}

/**
* @method extractCmds ()
* @param node (XMLNode) SVG path node
* @description Parse path node and convert to array of SVG drawing commands and data
*			eg, M,250.8,33.8,c,-33.6,-9.7,-42,19.1,-48.2,22.6,s,-27.9,2.2,-33.3,5.8,
*				c,-5.3,3.5,-17.3,23.5,-8.4,41.6
* @returns (Array) array of drawing commands
*/	
	private function extractCmds(node:XMLNode):Array {
		var i:Number;
		var startColor:Number;
		var thisColor:Number;

		var hasFill:Boolean = false;
		var hasTransform:Boolean = false;
		var hasStroke:Boolean = false;
		var hasStrokeWidth:Boolean = false;
		var hasRotate:Boolean = false;
		var dstring:String = "";
		var rotation:Number;

		var colors:Object = {};
		colors.blue=0x0000ff;
		colors.green=0x008000;
		colors.red=0xff0000;
		colors.none=undefined;
		colors.aliceblue=0xf0f8ff;
		colors.antiquewhite=0xfaebd7;
		colors.aqua=0x00ffff;
		colors.aquamarine=0x7fffd4;
		colors.azure=0xf0ffff;
		colors.beige=0xf5f5dc;
		colors.bisque=0xffe4c4;
		colors.black=0x000000;
		colors.blanchedalmond=0xffebcd;
		colors.blueviolet=0x8a2be2;
		colors.brown= 0xa52a2a;
		colors.burlywood = 0xdeb887;
		colors.cadetblue = 0x5f9ea0;
		colors.chartreuse = 0x7fff00;
		colors.chocolate = 0xd2691e;
		colors.coral= 0xff7f50;
		colors.cornflowerblue = 0x6495ed;
		colors.cornsilk = 0xfff8dc;
		colors.crimson = 0xdc143c;
		colors.cyan = 0x00ffff;
		colors.darkblue = 0x00008b;
		colors.darkcyan = 0x008b8b;
		colors.darkgoldenrod = 0xb8860b;
		colors.darkgray = 0xa9a9a9;
		colors.darkgreen = 0x006400;
		colors.darkgrey = 0xa9a9a9;
		colors.darkkhaki = 0xbdb76b;
		colors.darkmagenta = 0x8b008b;
		colors.darkolivegreen = 0x556b2f;
		colors.darkorange = 0xff8c00;
		colors.darkorchid = 0x9932cc;
		colors.darkred = 0x8b0000;
		colors.darksalmon = 0xe9967a;
		colors.darkseagreen = 0x8fbc8f;
		colors.darkslateblue = 0x483d8b;
		colors.darkslategray = 0x2f4f4f;
		colors.darkslategrey = 0x2f4f4f;
		colors.darkturquoise = 0x00ced1;
		colors.darkviolet = 0x9400d3;
		colors.deeppink = 0xff1493;
		colors.deepskyblue = 0x00bfff;
		colors.dimgray = 0x696969;
		colors.dimgrey = 0x696969;
		colors.dodgerblue = 0x1e90ff;
		colors.firebrick = 0xb22222;
		colors.floralwhite = 0xfffaf0;
		colors.forestgreen = 0x228b22;
		colors.fuchsia = 0xff00ff;
		colors.gainsboro = 0xdcdcdc;
		colors.ghostwhite = 0xf8f8ff;
		colors.gold = 0xffd700;
		colors.goldenrod = 0xdaa520;
		colors.gray = 0x808080;
		colors.grey = 0x808080;
		colors.greenyellow = 0xadff2f;
		colors.honeydew = 0xf0fff0;
		colors.hotpink = 0xff69b4;
		colors.indianred = 0xcd5c5c;
		colors.indigo = 0x4b0082;
		colors.ivory = 0xfffff0;
		colors.khaki = 0xf0e68c;
		colors.lavender = 0xe6e6fa;
		colors.lavenderblush = 0xfff0f5;
		colors.lawngreen = 0x7cfc00;
		colors.lemonchiffon = 0xfffacd;
		colors.lightblue = 0xadd8e6;
		colors.lightcoral = 0xf08080;
		colors.lightcyan = 0xe0ffff;
		colors.lightgoldenrodyellow = 0xfafad2;
		colors.lightgray = 0xd3d3d3;
		colors.lightgreen = 0x90ee90;
		colors.lightgrey = 0xd3d3d3;
		colors.lightpink = 0xffb6c1;
		colors.lightsalmon = 0xffa07a;
		colors.lightseagreen = 0x20b2aa;
		colors.lightskyblue = 0x87cefa;
		colors.lightslategray = 0x778899;
		colors.lightslategrey = 0x778899;
		colors.lightsteelblue = 0xb0c4de;
		colors.lightyellow = 0xffffe0;
		colors.lime = 0x00ff00;
		colors.limegreen = 0x32cd32;
		colors.linen = 0xfaf0e6;
		colors.magenta = 0xff00ff;
		colors.maroon = 0x800000;
		colors.mediumaquamarine = 0x66cdaa;
		colors.mediumblue = 0x0000cd;
		colors.mediumorchid = 0xba55d3;
		colors.mediumpurple = 0x9370db;
		colors.mediumseagreen = 0x3cb371;
		colors.mediumslateblue = 0x7b68ee;
		colors.mediumspringgreen = 0x00fa9a;
		colors.mediumturquoise = 0x48d1cc;
		colors.mediumvioletred = 0xc71585;
		colors.midnightblue = 0x191970;
		colors.mintcream = 0xf5fffa;
		colors.mistyrose = 0xffe4e1;
		colors.moccasin = 0xffe4b5;
		colors.navajowhite = 0xffdead;
		colors.navy = 0x000080;
		colors.oldlace = 0xfdf5e6;
		colors.olive = 0x808000;
		colors.olivedrab = 0x6b8e23;
		colors.orange = 0xffa500;
		colors.orangered = 0xff4500;
		colors.orchid = 0xda70d6;
		colors.palegoldenrod = 0xeee8aa;
		colors.palegreen = 0x98fb98;
		colors.paleturquoise = 0xafeeee;
		colors.palevioletred = 0xdb7093;
		colors.papayawhip = 0xffefd5;
		colors.peachpuff = 0xffdab9;
		colors.peru = 0xcd853f;
		colors.pink = 0xffc0cb;
		colors.plum = 0xdda0dd;
		colors.powderblue = 0xb0e0e6;
		colors.purple = 0x800080;
		colors.rosybrown = 0xbc8f8f;
		colors.royalblue = 0x4169e1;
		colors.saddlebrown = 0x8b4513;
		colors.salmon = 0xfa8072;
		colors.sandybrown = 0xf4a460;
		colors.seagreen = 0x2e8b57;
		colors.seashell = 0xfff5ee;
		colors.sienna = 0xa0522d;
		colors.silver = 0xc0c0c0;
		colors.skyblue = 0x87ceeb;
		colors.slateblue = 0x6a5acd;
		colors.slategray = 0x708090;
		colors.slategrey = 0x708090;
		colors.snow = 0xfffafa;
		colors.springgreen = 0x00ff7f;
		colors.steelblue = 0x4682b4;
		colors.tan = 0xd2b48c;
		colors.teal = 0x008080;
		colors.thistle = 0xd8bfd8;
		colors.tomato = 0xff6347;
		colors.turquoise = 0x40e0d0;
		colors.violet = 0xee82ee;
		colors.wheat = 0xf5deb3;
		colors.white = 0xffffff;
		colors.whitesmoke = 0xf5f5f5;    
		colors.yellow = 0xffff00;
		colors.yellowgreen = 0x9acd32;

		// is there a fill attribute, a transform attribute, a stroke attribute?
		for (var a:String in node.attributes) {
			if (a == "fill") {
				hasFill = true;
			} else if (a == "transform") {
				hasTransform = true;
			} else if (a == "stroke") {
				hasStroke = true;
			} else if (a == "stroke-width") {
				hasStrokeWidth = true;
			}
		}
		if (hasFill) {
			// parse for fill color specification
			// if a hex number is specified, startColor will be > 0
			// if a color name is specified, startColor will be 0
			startColor = node.attributes.fill.indexOf("#")+1;
			if (startColor == 0) {   // name specified instead of color number
				thisColor = colors[node.attributes.fill];
				if (thisColor == undefined) {
					fill = {color:0, alpha:0};  // set invisible if undefined
				} else {
					fill = {color:thisColor, alpha:100};
				}
			} else {
				fill = {color:parseInt(node.attributes.fill.substr(startColor,6),16), alpha:100};
			}
		} else fill = {color:0xffffff, alpha:100}; 
		
		// stroke: color, width, alpha
		if (hasStroke) {
			// parse for stroke color specification
			startColor = node.attributes.stroke.indexOf("#")+1;		
			if (startColor == 0) {   // name specified instead of color number
				thisColor = colors[node.attributes.stroke];
				if (thisColor == undefined) {
					stroke = {color:0, width:0, alpha:0};
				} else {
					stroke = {color:colors[node.attributes.stroke], width:0, alpha:100};
				}
			} else {
				stroke = {color:parseInt(node.attributes.stroke.substr(startColor,6),16), width:0, alpha:100};
			}
		  // if stroke is undefined, use invisible stroke
		} else stroke = {color:0, width:0, alpha:0};
		
		if (hasStrokeWidth) stroke.width = Number(node.attributes["stroke-width"]);
	
		// if stroke and fill are both undefined, set fill to black 
		if (!hasFill && !hasStroke) {
			fill = {color:0, alpha:100};
		}
		
		if (hasTransform) {
			// parse for rotation specification
			hasRotate = node.attributes.transform.indexOf("rotate");
			if (hasRotate > -1) {
				var startRotate:Number = node.attributes.transform.indexOf("(");
				var endRotate:Number = node.attributes.transform.indexOf(")");
				rotation = parseInt(node.attributes.transform.substr(startRotate+1, endRotate-startRotate));
			} else {
				rotation = 0;
			}
	
		} else rotation = 0;
		
		// if commas included, is it Adobe Illustrator (no spaces) or SVG Factory/other?
		if (node.attributes.d.indexOf(",") > -1) {  // has commas?
			if (node.attributes.d.indexOf(" ") > -1) {  // yes, has spaces?
				// change spaces to commas, then deal as for Illustrator
				dstring = String2.replace(node.attributes.d," ",",");
			}  else {
				dstring = node.attributes.d;
			}
		} else {  // no commas
			// get rid of extra spaces and change rest to commas
			dstring = node.attributes.d;
			dstring = String2.shrinkSequencesOf(dstring, " ");
			dstring = String2.replace(node.attributes.d, " ",",");
		}		
		dstring = String2.replace(dstring, "c",",c,");
		dstring = String2.replace(dstring, "C",",C,");
		dstring = String2.replace(dstring, "S",",S,");
		dstring = String2.replace(dstring, "s",",s,");
		// separate the z from the last element
		dstring = String2.replace(dstring, "z",",z");
		// change the following if M can be mid-path
		dstring = String2.replace(dstring, "M","M,");
		dstring = String2.replace(dstring, "L",",L,");
		dstring = String2.replace(dstring, "l",",l,");
		dstring = String2.replace(dstring, "H",",H,");
		dstring = String2.replace(dstring, "h",",h,");
		dstring = String2.replace(dstring, "V",",V,");
		dstring = String2.replace(dstring, "v",",v,");
		dstring = String2.replace(dstring, "Q",",Q,");
		dstring = String2.replace(dstring, "q",",q,");
		dstring = String2.replace(dstring, "T",",T,");
		dstring = String2.replace(dstring, "t",",t,");
		// Adobe includes no delimiter before negative numbers
		dstring = String2.replace(dstring, "-",",-");
		// get rid of any dup commas we might have introduced
		dstring = String2.replace(dstring, ",,",",");
		// get rid of spaces
		// (cr/lf's have to be removed before the xml object can be created,
		//  so that is done in xml.onData method)
		dstring = String2.replace(dstring, " ","");
		dstring = String2.replace(dstring, "\t","");

		return dstring.split(",");	
	}

/**
* @method makeDrawCmds
* @param svgCmds (Array) array of svg draw commands (as output from extractCmds)
* @description Convert svg draw commands to array of ASVDrawing commands: drawCmds
*/	
	private function makeDrawCmds(svgCmds:Array) {
		var j:Number = 0;
		var qc:Array;
		var firstP:Object;
		var lastP:Object;
		var lastC:Object;
		var cmd:String;
		
		do {
			cmd = svgCmds[j++];
			switch (cmd) {
			case "M" :
				// moveTo point
				firstP = lastP = {x:Number(svgCmds[j]), y:Number(svgCmds[j+1])};
				drawCmds.push(['F', [fill.color, fill.alpha]]);
				drawCmds.push(['S', [stroke.width, stroke.color, stroke.alpha]]);
				drawCmds.push(['M', [firstP.x, firstP.y]]);
				j += 2;
				if (j < svgCmds.length && !isNaN(Number(svgCmds[j]))) {  
					do {
						// if multiple points listed, add the rest as lineTo points
						lastP = {x:Number(svgCmds[j]), y:Number(svgCmds[j+1])};
						drawCmds.push(['L', [lastP.x, lastP.y]]);
						firstP = lastP;
						j += 2;
					} while (j < svgCmds.length && !isNaN(Number(svgCmds[j])));
				}
				break;
				
			case "l" :
				do {
					lastP = {x:lastP.x+Number(svgCmds[j]), y:lastP.y+Number(svgCmds[j+1])};
					drawCmds.push(['L', [lastP.x, lastP.y]]);
					firstP = lastP;
					j += 2;
				} while (j < svgCmds.length && !isNaN(Number(svgCmds[j])));
				break;
				
			case "L" :
				do {
					lastP = {x:Number(svgCmds[j]), y:Number(svgCmds[j+1])};
					drawCmds.push(['L', [lastP.x, lastP.y]]);					
					firstP = lastP;
					j += 2;
				} while (j < svgCmds.length && !isNaN(Number(svgCmds[j])));
				break;
				
			case "h" :
				do {
					lastP = {x:lastP.x+Number(svgCmds[j]), y:lastP.y};
					drawCmds.push(['L', [lastP.x, lastP.y]]);
					firstP = lastP;
					j += 1;
				} while (j < svgCmds.length && !isNaN(Number(svgCmds[j])));
				break;
				
			case "H" :
				do {
					lastP = {x:Number(svgCmds[j]), y:lastP.y};
					drawCmds.push(['L', [lastP.x, lastP.y]]);
					firstP = lastP;
					j += 1;
				} while (j < svgCmds.length && !isNaN(Number(svgCmds[j])));
				break;
				
			case "v" :
				do {
					lastP = {x:lastP.x, y:lastP.y+Number(svgCmds[j])};
					drawCmds.push(['L', [lastP.x, lastP.y]]);
					firstP = lastP;
					j += 1;
				} while (j < svgCmds.length && !isNaN(Number(svgCmds[j])));
				break;
				
			case "V" :
				do {
					lastP = {x:lastP.x, y:Number(svgCmds[j])};
					drawCmds.push(['L', [lastP.x, lastP.y]]);
					firstP = lastP;
					j += 1;
				} while (j < svgCmds.length && !isNaN(Number(svgCmds[j])));
				break;
	
			case "q" :
				do {
					// control is relative to lastP, not lastC
					lastC = {x:lastP.x+Number(svgCmds[j]), y:lastP.y+Number(svgCmds[j+1])};
					lastP = {x:lastP.x+Number(svgCmds[j+2]), y:lastP.y+Number(svgCmds[j+3])};
					drawCmds.push(['C', [lastC.x, lastC.y, lastP.x, lastP.y]]);
					firstP = lastP;
					j += 4;
				} while (j < svgCmds.length && !isNaN(Number(svgCmds[j])));
				break;
				
			case "Q" :
				do {
					lastC = {x:Number(svgCmds[j]), y:Number(svgCmds[j+1])};					
					lastP = {x:Number(svgCmds[j+2]), y:Number(svgCmds[j+3])};
					drawCmds.push(['C', [lastC.x, lastC.y, lastP.x, lastP.y]]);
					firstP = lastP;
					j += 4;
				} while (j < svgCmds.length && !isNaN(Number(svgCmds[j])));
				break;
				
			case "c" :
				do {
				// don't save if c1.x=c1.y=c2.x=c2.y=0 
					if (!Number(svgCmds[j]) && !Number(svgCmds[j+1]) && !Number(svgCmds[j+2]) && !Number(svgCmds[j+3])) {
					} else {
						qc = [];
						Math2.getQuadBez_RP(
							{x:lastP.x, y:lastP.y},   
							{x:lastP.x+Number(svgCmds[j]), y:lastP.y+Number(svgCmds[j+1])},
							{x:lastP.x+Number(svgCmds[j+2]), y:lastP.y+Number(svgCmds[j+3])},
							{x:lastP.x+Number(svgCmds[j+4]), y:lastP.y+Number(svgCmds[j+5])},
						    1, qc);
						for (var ii=0; ii<qc.length; ii++) {
							drawCmds.push(['C', [qc[ii].cx, qc[ii].cy, qc[ii].p2x, qc[ii].p2y]]);
						}
						lastC = {x:lastP.x+Number(svgCmds[j+2]), y:lastP.y+Number(svgCmds[j+3])}
						lastP = {x:lastP.x+Number(svgCmds[j+4]), y:lastP.y+Number(svgCmds[j+5])};
						firstP = lastP;
					}
					j += 6;
				} while (j < svgCmds.length && !isNaN(Number(svgCmds[j])));
				break;
	
			case "C" :
				do {
				// don't save if c1.x=c1.y=c2.x=c2.y=0 
					if (!Number(svgCmds[j]) && !Number(svgCmds[j+1]) && !Number(svgCmds[j+2]) && !Number(svgCmds[j+3])) {
					} else {
						qc = [];
						Math2.getQuadBez_RP(
							{x:firstP.x, y:firstP.y},   
							{x:Number(svgCmds[j]), y:Number(svgCmds[j+1])},
							{x:Number(svgCmds[j+2]), y:Number(svgCmds[j+3])},
							{x:Number(svgCmds[j+4]), y:Number(svgCmds[j+5])},
							1, qc);
						for (var ii=0; ii<qc.length; ii++) {
							drawCmds.push(['C', [qc[ii].cx, qc[ii].cy, qc[ii].p2x, qc[ii].p2y]]);
						}


						lastC = {x:Number(svgCmds[j+2]), y:Number(svgCmds[j+3])}
						lastP = {x:Number(svgCmds[j+4]), y:Number(svgCmds[j+5])};
						firstP = lastP;
					}
					j += 6;
				} while (j < svgCmds.length && !isNaN(Number(svgCmds[j])));
				break;
				
			case "s" :
				do {
				// don't save if c1.x=c1.y=c2.x=c2.y=0 
					if (!Number(svgCmds[j]) && !Number(svgCmds[j+1]) && !Number(svgCmds[j+2]) && !Number(svgCmds[j+3])) {
					} else {
						qc = [];
						Math2.getQuadBez_RP(
							{x:firstP.x, y:firstP.y},   
							{x:lastP.x + (lastP.x - lastC.x), y:lastP.y + (lastP.y - lastC.y)},
							{x:lastP.x+Number(svgCmds[j]), y:lastP.y+Number(svgCmds[j+1])},
							{x:lastP.x+Number(svgCmds[j+2]), y:lastP.y+Number(svgCmds[j+3])},
							1, qc);
						for (var ii=0; ii<qc.length; ii++) {
							drawCmds.push(['C', [qc[ii].cx, qc[ii].cy, qc[ii].p2x, qc[ii].p2y]]);
						}

						lastC = {x:lastP.x+Number(svgCmds[j]), y:lastP.y+Number(svgCmds[j+1])};
						lastP = {x:lastP.x+Number(svgCmds[j+2]), y:lastP.y+Number(svgCmds[j+3])};
						firstP = lastP;
					}
					j += 4;
				} while (j < svgCmds.length && !isNaN(Number(svgCmds[j])));
				break;
				
			case "S" :
				do {
				// don't save if c1.x=c1.y=c2.x=c2.y=0 
					if (!Number(svgCmds[j]) && !Number(svgCmds[j+1]) && !Number(svgCmds[j+2]) && !Number(svgCmds[j+3])) {
					} else {
						qc = [];
						Math2.getQuadBez_RP(
							{x:firstP.x, y:firstP.y},   
							{x:lastP.x + (lastP.x - lastC.x), y:lastP.y + (lastP.y - lastC.y)},
							{x:Number(svgCmds[j]), y:Number(svgCmds[j+1])},
							{x:Number(svgCmds[j+2]), y:Number(svgCmds[j+3])}, 
							1, qc);
						for (var ii=0; ii<qc.length; ii++) {
							drawCmds.push(['C', [qc[ii].cx, qc[ii].cy, qc[ii].p2x, qc[ii].p2y]]);
						}

						lastC = {x:Number(svgCmds[j]), y:Number(svgCmds[j+1])};
						lastP = {x:Number(svgCmds[j+2]), y:Number(svgCmds[j+3])};
						firstP = lastP;
					}
					j += 4;
				} while (j < svgCmds.length && !isNaN(Number(svgCmds[j])));
				break;
				
			case "z" :
			case "Z" :
				if (firstP.x != lastP.x || firstP.y != lastP.y) {
					drawCmds.push(['L', [firstP.x, firstP.y]]);
				}
				j++;
				break;		
				
			} // end switch
		}  while (j < svgCmds.length);
	}
}

