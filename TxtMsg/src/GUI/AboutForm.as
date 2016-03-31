import flash.geom.Rectangle;
import util.*;


/**
 * ...
 * @author Richard Teel
 */
class GUI.AboutForm extends MovieClip
{
	/*************************************************************
	 * START: Variable Declarations
	 *************************************************************/
	private var DEFAULTPADDING:Number = 10;
	 
	private var parent:MovieClip;
	private var owner:MovieClip;
	
	private var fmtTitle:TextFormat;
	
	private var screenBackground:MovieClip;
	private var txtTitle:TextField;
	private var cmdClose:MovieClip;
	private var txtAbout:TextField;
	/*************************************************************
	 * END: Variable Declarations
	 *************************************************************/
	
	 
	/*************************************************************
	 * START: Public Properties
	 *************************************************************/
	public function get AboutText():String 
	{
		return txtAbout.htmlText;
	}
	public function set AboutText(value:String):Void 
	{
		txtAbout.htmlText = value;
	}
	
	public function get Title():String 
	{
		return txtTitle.text;
	}
	public function set Title(value:String):Void 
	{
		txtTitle.text = value;
		txtTitle.setTextFormat(fmtTitle);
	}
	
	public function get Visible():Boolean 
	{
		return screenBackground._visible;
	}
	public function set Visible(value:Boolean):Void 
	{
		cmdClose.onMouseDown = null;
		
		this._visible = value;
		screenBackground._visible = value;
		txtTitle._visible = value;
		cmdClose._visible = value;
		txtAbout._visible = value;
		
		if (value)
		{
			cmdClose.onMouseDown = cmdClose_onClick;
		}
	}
	/*************************************************************
	 * END: Public Properties
	 *************************************************************/
	
	 
	/*************************************************************
	 * START: Constructor
	 *************************************************************/
	public function AboutForm(mc:MovieClip, Owner:MovieClip) 
	{
		// save reference to main movieclip
		this.parent = mc;
		this.owner = Owner;
		
		// Add controls
		init();
	}
	/*************************************************************
	 * END: Constructor
	 *************************************************************/
	
	 
	/*************************************************************
	 * START: Private Functions
	 *************************************************************/
	private function init():Void 
	{
		var defaultProperties:Object = new Object();
		defaultProperties.parent = this.parent;
		defaultProperties.owner = this.owner;
		
		fmtTitle = new TextFormat();
		fmtTitle.align = "center";
		fmtTitle.bold = true;
		fmtTitle.size = 24;
		
		screenBackground = this.parent.attachMovie("library.orange20background203.jpg", "screenBackground", this.parent.getNextHighestDepth(), defaultProperties);
		
		txtTitle = this.parent.createTextField("txtTitle", this.parent.getNextHighestDepth(), 0, 0, 10, 10);
		txtTitle._x = 0;
		txtTitle._y = 0;
		txtTitle._width = Stage.width - 30;
		txtTitle._height = 30;
		txtTitle.border = true;
		txtTitle.html = false;
		txtTitle.multiline = false;
		txtTitle.wordWrap = false;
		txtTitle.background = true;
		txtTitle.backgroundColor = 0xb47f4c;
		
		cmdClose = this.parent.attachMovie("library.close.png", "cmdClose", this.parent.getNextHighestDepth(), defaultProperties);
		cmdClose._x = txtTitle._width;
		cmdClose._y = 0;
		
		txtAbout = this.parent.createTextField("txtAbout", this.parent.getNextHighestDepth(), DEFAULTPADDING, txtTitle._height + DEFAULTPADDING, 
			Stage.width - (2 * DEFAULTPADDING), Stage.height - txtTitle._height - (2 * DEFAULTPADDING));
		txtAbout.border = true;
		txtAbout.html = true;
		txtAbout.multiline = true;
		txtAbout.wordWrap = true;
		txtAbout.background = true;
		txtAbout.backgroundColor = 0xffffff;
	}
	/*************************************************************
	 * END: Private Functions
	 *************************************************************/
	
	
	/*************************************************************
	 * START: Event Handlers
	 *************************************************************/
	 function cmdClose_onClick():Void 
	{
		if (this.hitTest(_root._xmouse, _root._ymouse, true) && this._visible)
		{
			if (this.owner.button_onClick)
			{
				this.owner.button_onClick(this);
			}
		}
	}
	/*************************************************************
	 * END: Event Handlers
	 *************************************************************/
}