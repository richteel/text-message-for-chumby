/*
 * The MIT License
 *
 * Copyright (c) 2008 Raffaele Sena <raff367@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

import GUI.*;
import util.*;

class Main extends MovieClip
{
	/*************************************************************
	 * START: Variable Declarations
	 *************************************************************/
	private var VERSION:String = "1.0";
	private var aboutForm:AboutForm;
	private var mainForm:MessageForm;
	private var MessagesList:Array;
	/*************************************************************
	 * END: Variable Declarations
	 *************************************************************/
	
	
	/*************************************************************
	 * START: Application Entry Point
	 *************************************************************/
	static function main(mc:MovieClip)
	{
		var app = new Main(mc);
	}
	/*************************************************************
	 * END: Application Entry Point
	 *************************************************************/
	
	 
	/*************************************************************
	 * START: Variable Declarations
	 *************************************************************/
	private var parent:MovieClip;
	private var appUI:MessageForm;
	
	// START: Parameter Names
	// These must match the same block in the configuration widget!
	private static var PARAMURL:String = "TxtMsgURL";
	private static var PARAMMAXMESSAGES:String = "TxtMsgMaxMessages";
	private static var PARAMMAXDAYS:String = "TxtMsgMaxDays";
	private static var PARAMUSERNAME:String = "_private_TxtMsgUserName";
	private static var PARAMPASSWORD:String = "_private_TxtMsgPassword";
	private static var PARAMPARAMETERS:String = "TxtMsgParameters";
	// END: Parameter Names
	
	private var paramURL:String;
	private var paramMaxMessages:String;
	private var paramMaxDays:String;
	private var paramUserName:String;
	private var paramPassword:String;
	private var paramParameters:String;
	
	private var siteURL:String;
	/*************************************************************
	 * END: Variable Declarations
	 *************************************************************/
	
	 
	/*************************************************************
	 * START: Constructor
	 *************************************************************/
	function Main(mc:MovieClip)
	{
		// save reference to main movieclip
		this.parent = mc;
		
		loadConfiguration();
		init();
	}
	/*************************************************************
	 * START: Private Functions
	 *************************************************************/	
	private function DisplayMessage(increment:Number):Void 
	{
		var msgIdx:Number = appUI.CurrentMessageIndex + increment;
		
		if (MessagesList == null || MessagesList.length == 0)
		{ return; }
		
		if (msgIdx < 1)
		{
			msgIdx = MessagesList.length;
		}
		else if (msgIdx > MessagesList.length)
		{
			//loadMessages();
			//return;
			msgIdx = 1;
		}
		
		var items:Array = MessagesList[msgIdx - 1].toString().split("\t");
		
		appUI.ClearForm();
		appUI.CurrentMessageIndex = msgIdx;
		appUI.TotalMessagesCount = MessagesList.length;
		
		if (items.length < 3)
		{
			appUI.MessageText = "Sorry there is an error with this message.";
		}
		else
		{
			appUI.MessageDate = stringToDate(items[0].toString());
			appUI.MessageFrom = items[1].toString();
			appUI.MessageText = items[2].toString();
		}
	}
	
	private function init():Void 
	{
		// set background and app title
		aboutForm = new AboutForm(this.parent, this);
		aboutForm.Title = "ABOUT";
		aboutForm.AboutText = "<font color=\"#0000ff\" size=\"28\">Text Message</font><br />" +
			"&nbsp;by: Richard Teel<br />" +
			"&nbsp;View my Chumby Blog at:<br />" +
			"&nbsp;&nbsp;chumbydev.blogspot.com<br />" +
			"Version: " + VERSION;
		aboutForm.Visible = false;
		
		appUI = new MessageForm(this.parent, this);
		appUI.MessageFrom = "Lisa";
		appUI.TotalMessagesCount = 32;
		appUI.CurrentMessageIndex = 12;
		appUI.MessageText = "My List of Items<ul><li>Item 1</li><li>Item 2</li><li>Item 3</li><li>Item 4</li><li>Item 5</li><li>Item 6</li><li>Item 7</li><li>Item 8</li></ul>" +
			"<img src=\"http://www.teelsys.com/chumby/images/1913Benz.jpg\" width=\"150\" height=\"113\">1913 Benz" + 
			"My List of Items<ul><li>Item 1</li><li>Item 2</li><li>Item 3</li><li>Item 4</li><li>Item 5</li><li>Item 6</li><li>Item 7</li><li>Item 8</li></ul>" +
			"My List of Items<ul><li>Item 1</li><li>Item 2</li><li>Item 3</li><li>Item 4</li><li>Item 5</li><li>Item 6</li><li>Item 7</li><li>Item 8</li></ul>";
		appUI.MessageDate = (new Date(2011, 7, 29, 17, 20, 0, 0));
		appUI.Visible = true;
		
		loadMessages();
	}
	
	private function loadConfiguration():Void 
	{
		var DeviceId = _root["_chumby_chumby_id"];
		var DeviceName = _root["_chumby_chumby_name"];
		
		paramURL = _root[PARAMURL] != undefined ? _root[PARAMURL] : "http://www.teelsys.com/chumby/ChumbyServer.aspx";
		paramMaxMessages = _root[PARAMMAXMESSAGES] != undefined ? _root[PARAMMAXMESSAGES] : "20";
		paramMaxDays = _root[PARAMMAXDAYS] != undefined ? _root[PARAMMAXDAYS] : "7";
		paramUserName = _root[PARAMUSERNAME] != undefined ? _root[PARAMUSERNAME] : "";
		paramPassword = _root[PARAMPASSWORD] != undefined ? _root[PARAMPASSWORD] : "";
		paramParameters = _root[PARAMPARAMETERS] != undefined ? _root[PARAMPARAMETERS] : "";
		
		siteURL = paramURL + "?ChumbyName=" + DeviceName + "&ChumbyID=" + DeviceId 
			+ "&MaxMessages=" + paramMaxMessages 
			+ "&MaxDays=" + paramMaxDays 
			+ "&UserName=" + paramUserName
			+ "&Password=" + paramPassword
			+ "&Paramaters=" + paramParameters;
		
		trace(siteURL);
	}
	
	private function loadMessages():Void 
	{
		var myVars_lv:LoadVars = new LoadVars();
		var currentTime:Date = new Date();
		
		myVars_lv.parent = this;
		myVars_lv.onData = function(src:String):Void {
				if (src != undefined) {
					this.parent.messages_onLoaded(src);
				} else {
					trace("Unable to load HTML file");
				}
			};
		myVars_lv.load(siteURL + "&DTE=" + currentTime.getTime());
		
		appUI.ClearForm();
		appUI.MessageText = "<br /><br /><p align=\"center\"><font color=\"#800080\" size=\"28\">LOADING</font></p>";
	}
	
	private function stringToDate( str:String ): Date
	{
		// Assume mm/dd/yyyy hh:mm:ss format
		var month:Number = parseInt(str.substring(0, 2));
		var day:Number = parseInt(str.substring(3, 5));
		var year:Number = parseInt(str.substring(6, 10));
		var hours:Number = parseInt(str.substring(11, 13));
		var minutes:Number = parseInt(str.substring(14, 16));
		var seconds:Number = parseInt(str.substring(17, 19));
		
		/*
		trace(month);
		trace(day);
		trace(year);
		trace(hours);
		trace(minutes);
		trace(seconds);
		*/
		
		return new Date(year, month-1, day, hours, minutes, seconds, 0);
	}
	/*************************************************************
	 * END: Private Functions
	 *************************************************************/
	
	 
	/*************************************************************
	 * START: Public Methods
	 *************************************************************/
	/*************************************************************
	 * END: Public Methods
	 *************************************************************/
	
	
	/*************************************************************
	 * START: Event Handlers
	 *************************************************************/
	public function button_onClick(sender:MovieClip):Void
	{
		trace("Main - " + sender._name);
		switch(sender._name)
		{
			case "cmdAbout":
				appUI.swapDepths(aboutForm);
				appUI.Visible = false;
				aboutForm.Visible = true;
				break;
			case "cmdClose":
				aboutForm.swapDepths(appUI);
				aboutForm.Visible = false;
				appUI.Visible = true;
				break;
			case "cmdRefresh":
				loadMessages();
				break;
			case "cmdNextMsg":
				DisplayMessage(1);
				break;
			case "cmdPreviousMsg":
				DisplayMessage( -1);
				break;
			default:
				break;
		}
	}
	
	private function messages_onLoaded(messagesRaw:String):Void 
	{
		//trace(messagesRaw);
		
		if (messagesRaw.lastIndexOf("\r\n") == messagesRaw.length - 2)
		{
			messagesRaw = messagesRaw.substring(0, messagesRaw.length - 2);
		}
		
		MessagesList = messagesRaw.split("\r\n");
		
		appUI.ClearForm();
		
		DisplayMessage(1);
	}
	/*************************************************************
	 * END: Event Handlers
	 *************************************************************/
}
