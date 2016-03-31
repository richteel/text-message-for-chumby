/*
* Useful XML functions
*/

class XmlUtil
{	
	public static function childrenOfType(x:XMLNode, s:String) :Array
	{
		var a:Array = new Array();
		var n:XMLNode = x.firstChild;
		while (n) {
			if (n.nodeName==s) {
				a.push(n);
			}
			n = n.nextSibling;
		}
		return a;
	}

	public static function childrenThat(x:XMLNode, f:Function) :Array
	{
		var a:Array = new Array();
		var n:XMLNode = x.firstChild;
		while (n) {
			if (f(n)) {
				a.push(n);
			}
			n = n.nextSibling;
		}
		return a;
	}

	public static function firstChildOfType(x:XMLNode, s:String) :XMLNode
	{
		//trace("firstChildOfType: " + s);
		var n:XMLNode = x.firstChild;
		while (n) {
			//trace(n.nodeName);
			if (n.nodeName==s) {
				//trace("---");
				return n;
			}
			n = n.nextSibling;
		}
		return null;
	}

	public static function firstChildThat(x:XMLNode, f:Function) :XMLNode
	{
		var n:XMLNode = x.firstChild;
		while (n) {
			if (f(n)) {
				return n;
			}
			n = n.nextSibling;
		}
		return null;
	}

	public static function firstDescendantOfType(x:XMLNode, s:String) :XMLNode
	{
		var n:XMLNode = firstChildOfType(x,s);
		if (n) return n;
		n = x.firstChild;
		while (n) {
			var k:XMLNode = firstDescendantOfType(n, s);
			if (k) return k;
			n = n.nextSibling;
		}
		return null;
	}

	// returns the text of first child item of an element with the given tag
	public static function firstValueOfType(x:XMLNode, s:String) :String
	{
		var n:XMLNode = x.firstChild;
		while (n) {
			if (n.nodeName==s) {
				return n.firstChild.nodeValue;
			}
			n = n.nextSibling;
		}
		return null;
	}
}