package com.fracturedvisionmedia.telemetryEASY.screens
{
	import com.fracturedvisionmedia.telemetryEASY.Main;
	
	import flash.text.TextFormat;
	import flash.desktop.NativeApplication;
	
	import feathers.controls.Header;
	import feathers.controls.Screen;
	import feathers.controls.ScrollText;
	
	import starling.events.Event;

	public class MainMenuScreen extends Screen
	{
		
		public function MainMenuScreen()
		{
			super();
		}
		
		private var _header:Header;
		private var _status:ScrollText;
		
		override protected function initialize():void
		{
			this._header = new Header();
			this._header.title = "TelemetryEASY - " + getAppVersion();
			this.addChild(this._header);

			this._status = new ScrollText();
			this._status.text = "Drag a SWF here to enable advanced telemetry.";
			this._status.addEventListener(Event.ENTER_FRAME, checkMessage);
			this.addChild(this._status);
			this._status.textFormat = new TextFormat("Arial", 14, 0xffb400, true, false, false, null, null, "center");
		}
		
		private function checkMessage():void
		{
			_status.text = (this.root as Main).message;
		}
		
		private function getAppVersion():String 
		{
			var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXml.namespace();
			var appVersion:String = appXml.ns::versionNumber[0];
			return appVersion;
		}
		
		override protected function draw():void
		{
			this._header.width = this.actualWidth;
			this._header.validate();
			this._status.y = this._header.height;
			this._status.width = this.actualWidth;
			this._status.height = this.actualHeight - this._status.y;
		}
		
	}
}