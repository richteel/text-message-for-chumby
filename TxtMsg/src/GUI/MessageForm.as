import flash.geom.Rectangle;
import util.*;



/**
 * ...
 * @author Richard Teel
 */
class GUI.MessageForm extends MovieClip
{
	/*
	[Embed(source="I:\Projects - Chumby\Projects\TxtMsg\library\library\DejaVuSansMono.ttf",
                    fontName="DejaVuSansMonoBook",
                    mimeType = "application/x-font",
					unicodeRange = "U+0020-U+007E")]
	*/
	/*************************************************************
	 * START: Variable Declarations
	 *************************************************************/
	private var SCROLLBARWIDTH:Number = 20;
	private var PREVIOUSNEXTBTNWIDTH:Number = 30;
	private var TEXTBOXHEIGHT:Number = 20;
	private var SCROLLSTEPSIZE:Number = 2;
	//private var DEFAULTFONT:String = "_serif";
	//private var DEFAULTFONT:String = "library.Monofont.ttf";
	private var DEFAULTFONT:String = "library.DejaVuSansMono.ttf";
	//private var DEFAULTFONT:String = "DejaVuSansMonoBook";
	
	
	private var topParent:MovieClip;
	private var myOwner:MovieClip;
	// Not used but needed to allow FlashDevelop to compile the code
	private var owner:MovieClip;
	
	private var appBackground:MovieClip;
	private var txtCount:TextField;
	private var txtDate:TextField;
	private var txtFrom:TextField;
	private var txtMessage:TextField;
	private var cmdAbout:MovieClip;
	private var cmdRefresh:MovieClip;
	private var cmdNextMsg:MovieClip;
	private var cmdPreviousMsg:MovieClip;
	private var cmdScrollUp:MovieClip;
	private var cmdScrollDown:MovieClip;
	private var cmdScroll:MovieClip;
	private var shapeScrollbar:MovieClip;
	
	private var fmtCenterText:TextFormat;
	private var fmtLeftText:TextFormat;
	//private var fmtMsgText:TextFormat;
	
	//Fields
	private var _totalMessagesCount:Number;
	private var _currentMessageIndex:Number;
	private var _messageDate:Date;
	private var _messageFrom:String;
	private var _messageText:String;
	/*************************************************************
	 * END: Variable Declarations
	 *************************************************************/
	
	 
	/*************************************************************
	 * START: Public Properties
	 *************************************************************/
	public function get TotalMessagesCount():Number 
	{
		return _totalMessagesCount;
	}
	public function set TotalMessagesCount(value:Number):Void 
	{
		_totalMessagesCount = value;
		txtCount.text = _currentMessageIndex.toString() + " of " + _totalMessagesCount.toString();
		txtCount.setTextFormat(fmtCenterText);
	}
	
	public function get CurrentMessageIndex():Number 
	{
		return _currentMessageIndex;
	}
	public function set CurrentMessageIndex(value:Number):Void 
	{
		_currentMessageIndex = value;
		txtCount.text = _currentMessageIndex.toString() + " of " + _totalMessagesCount.toString();
		txtCount.setTextFormat(fmtCenterText);
	}
	
	public function get MessageDate():Date 
	{
		return _messageDate;
	}
	public function set MessageDate(value:Date):Void 
	{
		_messageDate = value;
		txtDate.text = formatDate(_messageDate, true);
		txtDate.setTextFormat(fmtCenterText);
	}
	
	public function get MessageFrom():String 
	{
		return _messageFrom;
	}
	public function set MessageFrom(value:String):Void 
	{
		_messageFrom = value;
		txtFrom.text = _messageFrom;
		txtFrom.setTextFormat(fmtLeftText);
	}
	
	public function get MessageText():String 
	{
		return _messageText;
	}
	public function set MessageText(value:String):Void 
	{
		//txtMessage.setTextFormat(fmtMsgText);
		//_messageText = "<font style=\"font-family:DejaVuSansMonoBook;\">" + value + "</font>";
		_messageText = value;
		txtMessage.htmlText = _messageText;
		//txtMessage.setTextFormat(fmtMsgText);
	}
	
	public function get Visible():Boolean 
	{
		return appBackground._visible;
	}
	public function set Visible(value:Boolean):Void 
	{
		cmdAbout.onMouseDown = null;
		cmdRefresh.onMouseDown = null;
		cmdNextMsg.onMouseDown = null;
		cmdPreviousMsg.onMouseDown = null;
		cmdScrollUp.onMouseDown = null;
		cmdScrollDown.onMouseDown = null;
		
		this._visible = value;
		appBackground._visible = value;
		txtCount._visible = value;
		txtDate._visible = value;
		txtFrom._visible = value;
		txtMessage._visible = value;
		cmdAbout._visible = value;
		cmdRefresh._visible = value;
		cmdNextMsg._visible = value;
		cmdPreviousMsg._visible = value;
		cmdScrollUp._visible = value;
		cmdScrollDown._visible = value;
		cmdScroll._visible = value;
		shapeScrollbar._visible = value;
		
		if (value)
		{
			cmdAbout.onMouseDown = button_onClick_HitTest;
			cmdRefresh.onMouseDown = button_onClick_HitTest;
			cmdNextMsg.onMouseDown = previousNextbutton_onClick;
			cmdPreviousMsg.onMouseDown = previousNextbutton_onClick;
			cmdScrollUp.onMouseDown = button_onClick_HitTest;
			cmdScrollDown.onMouseDown = button_onClick_HitTest;
		}
	}
	/*************************************************************
	 * END: Public Properties
	 *************************************************************/
	
	 
	/*************************************************************
	 * START: Constructor
	 *************************************************************/
	public function MessageForm(mc:MovieClip, Owner:MovieClip) 
	{
		// save reference to main movieclip
		this.topParent = mc;
		this.myOwner = Owner;
		
		// Add controls
		init();
		
		this.ClearForm();
	}
	/*************************************************************
	 * END: Constructor
	 *************************************************************/
	
	 
	/*************************************************************
	 * START: Private Functions
	 *************************************************************/
	private function formatDate(dte:Date, IsUTC:Boolean):String 
	{
		var retVal:String = "";
		var dow:Array = new Array("SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT");
		var months:Array = new Array("JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC");
		var tmpDte:Date = dte;
		
		if (IsUTC)
		{
			tmpDte.setUTCFullYear(dte.getFullYear());
			tmpDte.setUTCMonth(dte.getMonth());
			tmpDte.setUTCDate(dte.getDate());
			tmpDte.setUTCHours(dte.getHours());
		}
		 
		// ddd d MMM yyyy hh:mm:ss T
		retVal = dow[dte.getDay()] + " " + dte.getDate().toString() + " " + months[dte.getMonth()] + " " + dte.getFullYear().toString() + " " +
			(dte.getHours() == 0 ? "12" : dte.getHours() > 12 ? (dte.getHours() -12).toString() : dte.getHours().toString()) + 
			":" + (dte.getMinutes() < 10 ? "0" : "") + dte.getMinutes().toString() + ":" + (dte.getSeconds() < 10 ? "0" : "") + dte.getSeconds().toString() +
			(dte.getHours() < 12 ? " AM" : " PM");
		
		return retVal;
	}
	
	private function init():Void 
	{
		var defaultProperties:Object = new Object();
		defaultProperties.topParent = this.topParent;
		defaultProperties.myOwner = this.myOwner;
		defaultProperties.owner = this;
		
		fmtCenterText = new TextFormat(DEFAULTFONT, 11, 0x000000);
		fmtCenterText.align = "center";
		
		fmtLeftText = new TextFormat(DEFAULTFONT, 12, 0x000000, true);
		fmtLeftText.leftMargin = 5;
		fmtLeftText.align = "left";
		
		//fmtMsgText = new TextFormat(DEFAULTFONT, 12, 0x000000);
		
		appBackground = this.topParent.attachMovie("library.blue-yellow-abstract-background-thumb_medium.jpg", "appBackground", this.topParent.getNextHighestDepth(), defaultProperties);
		
		txtCount = this.topParent.createTextField("txtCount", this.topParent.getNextHighestDepth(), PREVIOUSNEXTBTNWIDTH, 0, 60, TEXTBOXHEIGHT);
		txtCount.border = true;
		txtCount.html = false;
		txtCount.multiline = false;
		txtCount.wordWrap = false;
		txtCount.embedFonts = true;
		
		txtDate = this.topParent.createTextField("txtDate", this.topParent.getNextHighestDepth(), 0, 0, 10, 10);
		txtDate._x = txtCount._x + txtCount._width;
		txtDate._y = txtCount._y;
		txtDate._width = Stage.width - txtCount._width - (2 * PREVIOUSNEXTBTNWIDTH) -1;
		txtDate._height = TEXTBOXHEIGHT;
		txtDate.border = true;
		txtDate.html = false;
		txtDate.multiline = false;
		txtDate.wordWrap = false;
		txtDate.embedFonts = true;
		
		txtFrom = this.topParent.createTextField("txtFrom", this.topParent.getNextHighestDepth(), 0, 0, 10, 10);
		txtFrom._x = PREVIOUSNEXTBTNWIDTH;
		txtFrom._y = txtCount._height;
		txtFrom._width = Stage.width - (2 * PREVIOUSNEXTBTNWIDTH) - 1;
		txtFrom._height = TEXTBOXHEIGHT;
		txtFrom.border = true;
		txtFrom.html = false;
		txtFrom.multiline = false;
		txtFrom.wordWrap = false;
		txtFrom.embedFonts = true;
		
		txtMessage = this.topParent.createTextField("txtMessage", this.topParent.getNextHighestDepth(), 0, 0, 10, 10);
		txtMessage._x = PREVIOUSNEXTBTNWIDTH;
		txtMessage._y = txtFrom._y + txtFrom._height;
		txtMessage._width = Stage.width - SCROLLBARWIDTH - (2 * PREVIOUSNEXTBTNWIDTH) - 1;
		txtMessage._height = Stage.height - (txtFrom._y + txtFrom._height + 1);
		txtMessage.border = true;
		txtMessage.html = true;
		txtMessage.multiline = true;
		txtMessage.wordWrap = true;
		//txtMessage.embedFonts = true;
		
		shapeScrollbar = this.topParent.createEmptyMovieClip("shapeScrollbar", this.topParent.getNextHighestDepth());
		shapeScrollbar._x = txtMessage._x + txtMessage._width;
		shapeScrollbar._y = txtFrom._y + txtFrom._height;
		shapeScrollbar.useHandCursor = true;
		shapeScrollbar.beginFill(0xdae0e6);
		shapeScrollbar.lineStyle(1, 0x000000, 100, true, "normal", "none", "miter", 2);
		shapeScrollbar.moveTo(0, 0);
		shapeScrollbar.lineTo(0, Stage.height - (txtFrom._y + txtFrom._height + 1));
		shapeScrollbar.lineTo(SCROLLBARWIDTH, Stage.height - (txtFrom._y + txtFrom._height + 1));
		shapeScrollbar.lineTo(SCROLLBARWIDTH, 0);
		shapeScrollbar.lineTo(0, 0);
		shapeScrollbar.endFill();
		
		cmdAbout = this.topParent.attachMovie("library.about.png", "cmdAbout", this.topParent.getNextHighestDepth(), defaultProperties);
		cmdAbout._x = 0;
		cmdAbout._y = 0; // Stage.height - PREVIOUSNEXTBTNWIDTH;
		cmdAbout.useHandCursor = true;
		
		cmdRefresh = this.topParent.attachMovie("library.refresh.png", "cmdRefresh", this.topParent.getNextHighestDepth(), defaultProperties);
		cmdRefresh._x = Stage.width - PREVIOUSNEXTBTNWIDTH;
		cmdRefresh._y = 0; // Stage.height - PREVIOUSNEXTBTNWIDTH;
		cmdRefresh.useHandCursor = true;
		
		cmdScrollUp = this.topParent.attachMovie("library.ScrollUp.png", "cmdScrollUp", this.topParent.getNextHighestDepth(), defaultProperties);
		cmdScrollUp._x = shapeScrollbar._x;
		cmdScrollUp._y = shapeScrollbar._y;
		cmdScrollUp.useHandCursor = true;
		
		cmdScrollDown = this.topParent.attachMovie("library.ScrollDown.png", "cmdScrollDown", this.topParent.getNextHighestDepth(), defaultProperties);
		cmdScrollDown._x = shapeScrollbar._x;
		cmdScrollDown._y = Stage.height - SCROLLBARWIDTH;
		cmdScrollDown.useHandCursor = true;
		
		cmdNextMsg = this.topParent.attachMovie("library.ScrollRight.png", "cmdNextMsg", this.topParent.getNextHighestDepth(), defaultProperties);
		cmdNextMsg._x = Stage.width - PREVIOUSNEXTBTNWIDTH;
		cmdNextMsg._y = (Stage.height - PREVIOUSNEXTBTNWIDTH)/2;
		cmdNextMsg.useHandCursor = true;
		
		cmdPreviousMsg = this.topParent.attachMovie("library.ScrollLeft.png", "cmdPreviousMsg", this.topParent.getNextHighestDepth(), defaultProperties);
		cmdPreviousMsg._x = 0;
		cmdPreviousMsg._y = (Stage.height - PREVIOUSNEXTBTNWIDTH)/2;
		cmdPreviousMsg.useHandCursor = true;
	}
	/*************************************************************
	 * END: Private Functions
	 *************************************************************/
	
	 
	/*************************************************************
	 * START: Public Methods
	 *************************************************************/
	public function ClearForm():Void 
	{
		this.TotalMessagesCount = 0;
		this.CurrentMessageIndex = 0;
		this.MessageDate = new Date();
		this.MessageFrom = "";
		this.MessageText = "";
	}
	/*************************************************************
	 * END: Public Methods
	 *************************************************************/
	
	
	/*************************************************************
	 * START: Event Handlers
	 *************************************************************/
	public function button_onClick(sender:MovieClip):Void
	{
		trace("MessageForm - " + sender._name);
		switch(sender._name)
		{
			case "cmdScrollUp":
				txtMessage.scroll--;
				break;
			case "cmdScrollDown":
				txtMessage.scroll++;
				break;
			default:
				break;
		}
	}
	
	private function button_onClick_HitTest():Void 
	{
		if (this.hitTest(_root._xmouse, _root._ymouse, true) && this._visible)
		{ 
			if (this._name == "cmdScrollUp" || this._name == "cmdScrollDown")
			{
				if (this.owner.button_onClick)
				{
					this.owner.button_onClick(this);
				}
			}
			else
			{
				if (this.myOwner.button_onClick)
				{
					this.myOwner.button_onClick(this);
				}
			}
		}
	}
	
	function previousNextbutton_onClick():Void 
	{
		//if (_root._xmouse >= this._x && _root._xmouse <= (this._x + this._width) && _root._ymouse >= 0 && _root._ymouse <= (Stage.height - this._height) && this._visible)
		if (_root._xmouse >= this._x && _root._xmouse <= (this._x + this._width) && _root._ymouse >= this._height && _root._ymouse <= Stage.height && this._visible)
		{
			if (this.myOwner.button_onClick)
			{
				this.myOwner.button_onClick(this);
			}
		}
	}
	/*************************************************************
	 * END: Event Handlers
	 *************************************************************/
}