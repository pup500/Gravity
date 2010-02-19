class com.itechnica.svg.String2 {
	
/**
* @class String2
* @author Helen Triolo, with inclusions from Tim Groleau
* @description String functions not included in String needed for path->array conversion
*/

/**
* @method replace ()
* @description Replaces sFind in s with sReplace
* @param s (String) original string
* @param sFind (String) part to be replaced
* @param sReplace (String) string to replace it with
* @returns (String) string with replacement
*/
	public static function replace(s:String, sFind:String, sReplace:String):String {
	  return s.split(sFind).join(sReplace);
	}
	
/**
* @method shrinkSequencesOf (Groleau)
* @description Shrinks all sequences of a given character in a string to one
* @param s (String) original string
* @param ch (String) character to be found
* @returns (String) string with sequences shrunk
*/
	public static function shrinkSequencesOf(s:String, ch:String):String {
		var len = s.length;
		var idx = 0;
		var idx2 = 0;
		var rs = "";
		
		while ((idx2 = s.indexOf(ch, idx) + 1) != 0) {
			// include string up to first character in sequence
			rs += s.substring(idx, idx2);
			idx = idx2;
			
			// remove all subsequent characters in sequence
			while ((s.charAt(idx) == ch) && (idx < len)) idx++;
		}
		return rs + s.substring(idx, len);	
	}
}