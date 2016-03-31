/*
 * With this file, you can create a Chumby configuration widget using the free
 * FlashDevelop tools which you can find out about here:
 * 
 * http://wiki.chumby.com/mediawiki/index.php/FlashDevelop
 * 
 * The templates by Raffaele Sena mentioned at the bottom of the page are a
 * great way to get started quickly.
 *
 * Many of the sample files on the Chumby site such as the sample banner here:
 * 
 * http://wiki.chumby.com/mediawiki/index.php/Sample_Banner_Widget
 * 
 * are geared for the $700 Adobe Flash tools. You can get a free 30 day trial of the
 * Flash Tools here (http://www.adobe.com/products/flash/), but if you would prefer
 * to use the free FlashDevelop, please join me in sharing Chumby example code that
 * doesn't require it.
 * 
 * Some of the code below originally came from the Flash Sample Banner code and I
 * reworked it heavily. I'm not sure of the licence rights of the parts I started
 * with, but you're certainly free to use my work for whatever purpose: 
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 ****
 * 
 * I attempted to make this widget work from the development debugging environment.
 * This is a challenge due to the need to access your Chumby URL from Chumby's
 * channel configuration web site. That variable doesn't exist in your debugging
 * environment. So I made the widget display the URL so you can get at it and stick
 * it into your code for debugging.
 * 
 * 1. Install FlashDevelop, Raff's templates, and this file.
 * 2. Compile the /bin/*.swf file using the Test Movie (F5) command. The first time
 *    you may have to make the /bin subdirectory by hand.
 * 3. Go to the Chumby widget upload site at http://www.chumby.com/widgets/upload
 * 4. Upload the swf file just created to the config slot. You'll also need
 *    a dummy widget file (perhaps the same one) and a logo file.
 * 5. Run the config widget by going here http://www.chumby.com/widgets/channels
 *    and hitting configure.
 * 6. Copy the value of the Chumby URL (spread over two lines)
 * 7. Paste the URL into the line of code below just after **HERE** below
 * 
 * Now when the routine runs in the debugger, it will use this hard coded URL
 * but when it runs on the Chumby site, it will fetch the URL from the web site
 * environment.
 * 
 * Now after all that, I still could not get this to work reliably in the test
 * environment. It seems to work all the time on the Chumby site. Sometimes I
 * can type in configuration parameters on the debug site and they will show
 * up on the Chumby site and vice versa, but I can't seem to make changes made
 * on the debug version show up on the next invocation of the debug version.
 * Perhaps someone smarter than I can figure out why. 
 * 
 * Its worth trying to make this work because you can see the output of the
 * trace commands in your debug environment. I don't know if that's possible
 * when your widget is running on Chumby's site.
 * 
 * The major difficulty in the code below is fighting with the scoping
 * problems related to passing callback functions around. Through a lot
 * of experimentation, I found a set of static and non-static functions
 * that work, although they make the code ugly as sin. Also, because
 * class-wide variables cannot be seen by these callback functions, I used
 * a lot of global variables. I'm not proud of that, but they are more
 * understandable to me than the Delegate.create functions that some
 * people use to try to finesses these problems. For more on scoping
 * problems, see http://timotheegroleau.com/Flash/articles/scope_chain.htm
 * 
 * If you make improvements to this template please post it back to the
 * Chumby site and drop me a line at john@tanner.com
 * 
 * John Tanner
 */

import XmlUtil.as;

class Main
{
	private static var FIELDHEIGHT:Number = 20;
	private static var FIELDSPACING:Number = 5;
	private static var FIELDLABELWIDTH:Number = 90;
	private static var FIELDLABELLEFT:Number = 5;
	private static var FIELDINPUTSTRINGWIDTH:Number = 150;
	private static var FIELDINPUTNUMBERWIDTH:Number = 25;
	private static var FIELDINPUTLEFT:Number = 100;
	
	// START: Parameter Names
	// These must match the same block in the application widget!
	private static var PARAMURL:String = "TxtMsgURL";
	private static var PARAMMAXMESSAGES:String = "TxtMsgMaxMessages";
	private static var PARAMMAXDAYS:String = "TxtMsgMaxDays";
	private static var PARAMUSERNAME:String = "_private_TxtMsgUserName";
	private static var PARAMPASSWORD:String = "_private_TxtMsgPassword";
	private static var PARAMPARAMETERS:String = "TxtMsgParameters";
	// END: Parameter Names
	
	private var parent:MovieClip;
	
	
	
	function Main(mc:MovieClip)
	{
		// change the following two lines
		// _global._showDebug - Set to "true" to view the Configuration URL
		// _global._configURL - **HERE** Otherwise, use the test url you found using the instructions above
		_global._showDebug = "false";
		_global._configURL = "http://www.chumby.com/xml/widgetinstances/6E2FB78E-D32A-11E0-B0DD-0021288E785A";
		// save reference to main movieclip
		_global.mc = mc;
		
		// set background and app title
//		UI.mainScreen(mc, UI.WHITE, "ClearSync Widget Configuration");
		var header:TextField = mc.createTextField("header", mc.getNextHighestDepth(), 5, 0, 310, 20);
		header.text = "TxtMsg Widget Configuration";
		header.autoSize = "center";
		var fmtHeader:TextFormat = new TextFormat();
		fmtHeader.size = 14;
		fmtHeader.bold = true;
		header.setTextFormat(fmtHeader);
		
		// If available, get the parameter storage URL from the Chumby web site that is running this configuration widget
		if (_root._chumby_instance_url != undefined) {
			_global._configURL = _root._chumby_instance_url;
			_global._runningWhere = "Chumby configuration web site";
		}
		// Otherwise, if available, get the parameter storage URL if this is running on the Chumby itself
		// Why you would run the configuration widget from the Chumby itself, I have no idea.
		else if (_root._chumby_widget_instance_href != undefined) {
			_global._configURL = _root._chumby_widget_instance_href;
			_global._runningWhere = "Chumby widget";
		}
		// **HERE** Otherwise, use the test url you found using the instructions above
		else {
			_global._runningWhere = "development debugger";
		}
		
		_chumby_get_widget_parameters(gotConfigParams);
	}
    
   	function gotConfigParams(p) {
		var mc:MovieClip = _global.mc;
		
		// Labels
		var lblURL:TextField = mc.createTextField("lblURL", mc.getNextHighestDepth(), FIELDLABELLEFT, 30, FIELDLABELWIDTH, FIELDHEIGHT);
		var lblMaxMessages:TextField = mc.createTextField("lblMaxMessages", mc.getNextHighestDepth(), FIELDLABELLEFT, lblURL._y + lblURL._height + FIELDSPACING, FIELDLABELWIDTH, FIELDHEIGHT);
		var lblMaxDays:TextField = mc.createTextField("lblMaxDays", mc.getNextHighestDepth(), FIELDLABELLEFT, lblMaxMessages._y + lblMaxMessages._height + FIELDSPACING, FIELDLABELWIDTH, FIELDHEIGHT);
		var lblUserName:TextField = mc.createTextField("lblUserName", mc.getNextHighestDepth(), FIELDLABELLEFT, lblMaxDays._y + lblMaxDays._height + FIELDSPACING, FIELDLABELWIDTH, FIELDHEIGHT);
		var lblPassword:TextField = mc.createTextField("lblPassword", mc.getNextHighestDepth(), FIELDLABELLEFT, lblUserName._y + lblUserName._height + FIELDSPACING, FIELDLABELWIDTH, FIELDHEIGHT);
		
		lblURL.text = "URL:";
		lblMaxMessages.text = "Max Messages:";
		lblMaxDays.text = "Max Days:";
		lblUserName.text = "Username:";
		lblPassword.text = "Password:";
		
		// Input Fields
		var txtURL:TextField = mc.createTextField("txtURL", mc.getNextHighestDepth(), FIELDINPUTLEFT, lblURL._y, FIELDINPUTSTRINGWIDTH, FIELDHEIGHT);
		var txtMaxMessages:TextField = mc.createTextField("txtMaxMessages", mc.getNextHighestDepth(), FIELDINPUTLEFT, lblMaxMessages._y, FIELDINPUTNUMBERWIDTH, FIELDHEIGHT);
		var txtMaxDays:TextField = mc.createTextField("txtMaxDays", mc.getNextHighestDepth(), FIELDINPUTLEFT, lblMaxDays._y, FIELDINPUTNUMBERWIDTH, FIELDHEIGHT);
		var txtUserName:TextField = mc.createTextField("txtUserName", mc.getNextHighestDepth(), FIELDINPUTLEFT, lblUserName._y, FIELDINPUTSTRINGWIDTH, FIELDHEIGHT);
		var txtPassword:TextField = mc.createTextField("txtPassword", mc.getNextHighestDepth(), FIELDINPUTLEFT, lblPassword._y, FIELDINPUTSTRINGWIDTH, FIELDHEIGHT);
		
		txtURL.type = "input";
		txtURL.border = true;
		txtMaxMessages.type = "input";
		txtMaxMessages.border = true;
		txtMaxDays.type = "input";
		txtMaxDays.border = true;
		txtUserName.type = "input";
		txtUserName.border = true;
		txtPassword.type = "input";
		txtPassword.border = true;
		txtPassword.password = true;
		
		var cmdDone:TextField = mc.createTextField("cmdDone", mc.getNextHighestDepth(), 110, lblPassword._y + lblPassword._height + FIELDSPACING, 100, 20);
		cmdDone.border = true;
		cmdDone.text = "       Done       ";
		cmdDone.autoSize = "center";
		cmdDone.background = true;
		cmdDone.backgroundColor = 0xd4d4d4;
		
		cmdDone.onSetFocus = function(oldFocus:Object) { Main.clickedOnDoneButton(Main._chumby_set_widget_parameters, Main.stopMe); }
		trace("tfDoneButton.onSetFocus: " + cmdDone.onSetFocus);
		var fmt:TextFormat = new TextFormat("_sans", 20, 0);
		fmt.align = "center";
        cmdDone.setNewTextFormat(fmt);
		
		// Display the Chumby parameter URL
		var txtDebug:TextField = mc.createTextField("txtDebug", mc.getNextHighestDepth(), FIELDLABELLEFT, cmdDone._y + cmdDone._height + FIELDSPACING, Stage.width - (2 * FIELDLABELLEFT), 60);
		//txtDebug.border = true;
		txtDebug.multiline = true;
		txtDebug.wordWrap = true;
		txtDebug.text = "Running on " + _global._runningWhere + ".\n"
			+ "URL: " + _global._configURL;
		var fmtDbg:TextFormat = new TextFormat("_sans", 11, 0);
		fmtDbg.align = "left";
		txtDebug.setTextFormat(fmtDbg);
		txtDebug._visible = false;
		
		if(_global._showDebug == "true") txtDebug._visible = true;
		
		// Add validation message area
		var txtMessage:TextField = mc.createTextField("txtMessage", mc.getNextHighestDepth(), FIELDLABELLEFT, cmdDone._y + cmdDone._height + FIELDSPACING, Stage.width - (2 * FIELDLABELLEFT), 60);
		//txtDebug.border = true;
		txtMessage.multiline = true;
		txtMessage.wordWrap = true;
		
		txtURL.text = (p[PARAMURL] != undefined ? p[PARAMURL] : "http://www.teelsys.com/chumby/ChumbyServer.aspx");
		txtMaxMessages.text = (p[PARAMMAXMESSAGES] != undefined ? p[PARAMMAXMESSAGES] : "20");
		txtMaxDays.text = (p[PARAMMAXDAYS] != undefined ? p[PARAMMAXDAYS] : "7");
		txtUserName.text = (p[PARAMUSERNAME] != undefined ? p[PARAMUSERNAME] : "");
		txtPassword.text = (p[PARAMPASSWORD] != undefined ? p[PARAMPASSWORD] : "");
	}
	
    static function clickedOnDoneButton(callback1,callback2) {
		trace("Clicked Done button.");
		trace(_global.mc.ClearSyncUserNameEditField.text + " " + _global.mc.ClearSyncPasswordEditField.text);
		var parameters:Object = new Object;
		parameters[PARAMURL] = _global.mc.txtURL.text;
		parameters[PARAMMAXMESSAGES] = _global.mc.txtMaxMessages.text;
		parameters[PARAMMAXDAYS] = _global.mc.txtMaxDays.text;
		parameters[PARAMUSERNAME] = _global.mc.txtUserName.text;
		parameters[PARAMPASSWORD] = _global.mc.txtPassword.text;
		
		var validateMsg:String = "";
		
		if (_global.mc.txtURL.text.length == 0 || _global.mc.txtMaxMessages.text.length == 0 || _global.mc.txtMaxDays.text.length == 0)
		{
			validateMsg = "URL, Max Messages, and Max Days are required.";
		}
		else if (isNaN(_global.mc.txtMaxMessages.text) || isNaN(_global.mc.txtMaxDays.text))
		{
			validateMsg = "Max Messages and Max Days must be a number.";
		}
		else if (parseInt(_global.mc.txtMaxMessages.text) <= 0 || parseInt(_global.mc.txtMaxDays.text) <= 0)
		{
			validateMsg = "Max Messages and Max Days must be greater than 0.";
		}
		
		var fmtMsg:TextFormat = new TextFormat("_sans", 11, 0);
		fmtMsg.align = "center";
		fmtMsg.color = 0x00ff00;
		
		if (validateMsg.length == 0)
		{
			_global.mc.txtMessage.text = "Configuration Saved";
			_global.mc.txtMessage.setTextFormat(fmtMsg);
			
			callback1(callback2, parameters); // Really ugly way to get around dang scoping problems.
		}
		else
		{
			fmtMsg.color = 0xff0000;
			_global.mc.txtMessage.text = validateMsg;
			_global.mc.txtMessage.setTextFormat(fmtMsg);
		}
	}
	
	static function stopMe () {
		trace("StopMe");
		if (_global._runningWhere == "Chumby configuration web site") getURL('javascript:dismiss()');
		// Would like to stop the debug version here, but how?
	}
	
	static function main(mc:MovieClip)
	{
		var app = new Main(mc);
	}

	// ******************************************************
	// The following code was recovered from an example provided by Chumby at
	// http://files.chumby.com/widgetexamples/simplebanner_config.fla
	// and then reworked extensively.
	//
	// Some helper functions to assist in managing the widget configuration
	//
	// Call this function to fetch the current values of the configuration.  You supply a callback with a
	// single parameter, which will be an Object with the key/value pairs already parsed out of the XML.
	//
	// The website will provide the value for "_chumby_instance_url", which is where you GET and POST the
	// values, when the configuration movie is launched.
	//
	// In the hash, the keys and values should be either strings or numbers - you cannot stored complex objects directly.
	// If you're adventurous, you *could* convert some structures to/from JSON or even XML and store them as text.
	//
	function _chumby_get_widget_parameters(callback) {
		var _chumby_xml:XML;
		var _chumby_result_xml:XML;
		_global._chumby_xml = new XML();
		_global._chumby_xml.onLoad = function(success) {
			trace("onLoad success: ", success.toString());
			trace("XML: >>"+_global._chumby_xml+"<<");
			Main._chumby_got_widget_parameters(callback,XmlUtil.firstChildOfType(_global._chumby_xml,'widget_instance'));
		}
		trace("load URL: "+_global._configURL);
		_global._chumby_xml.load(_global._configURL);
	}

	static function _chumby_got_widget_parameters(callback, x) {
		trace("Got to _chumby_got_widget_parameters");
		var widget_params = XmlUtil.firstChildOfType(x,'widget_parameters');
		widget_params = XmlUtil.childrenOfType(widget_params,'widget_parameter');
		var p = {}
		for (var i in widget_params) {
			var widget_param = widget_params[i];
			var key = XmlUtil.firstChildOfType(widget_param,'name').firstChild.nodeValue;
			var value = XmlUtil.firstChildOfType(widget_param,'value').firstChild.nodeValue;
			p[key] = value;
	//		trace(key + " " + value);
		}
		callback(p);
	}

	//
	// When you're done modifying the Object, call this function to upload the changes back to the
	// server.  Again, you supply a call back to be called when the upload is complete - typically
	// you'd just dismiss the dialog
	//
	static function _chumby_set_widget_parameters(callback,p) {
		var _chumby_xml:XML;
		var _chumby_result_xml:XML;
		trace("Set parameters: " + p);
		_chumby_xml = new XML();
		_chumby_xml.onLoad = undefined;
		var widget_parameters_xml = _chumby_xml.createElement('widget_parameters');
		for (var i in p) {
			var widget_parameter_xml = _chumby_xml.createElement('widget_parameter');
			var name_xml = _chumby_xml.createElement('name');
			name_xml.appendChild(_chumby_xml.createTextNode(i));
			var value_xml = _chumby_xml.createElement('value');
			value_xml.appendChild(_chumby_xml.createTextNode(p[i]));
			widget_parameter_xml.appendChild(name_xml);
			widget_parameter_xml.appendChild(value_xml);
			widget_parameters_xml.appendChild(widget_parameter_xml);
		}
		var widget_instance_xml = _chumby_xml.createElement('widget_instance');
		widget_instance_xml.appendChild(widget_parameters_xml);
		_chumby_xml.appendChild(widget_instance_xml);
		_chumby_result_xml = new XML();
		_chumby_result_xml.onLoad = function(success) {
			trace("sendAndLoad success: " + success);
			callback();
			 }
		trace("URL: "+_global._configURL+ "  XML: "+_chumby_xml);
		_chumby_xml.sendAndLoad(_global._configURL, _chumby_result_xml);
	}

}
