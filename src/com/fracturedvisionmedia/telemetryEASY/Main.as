package com.fracturedvisionmedia.telemetryEASY
{
	import com.fracturedvisionmedia.telemetryEASY.screens.MainMenuScreen;
	
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	import themes.MetalWorksMobileTheme;

	public class Main extends Sprite
	{
		public var message:String = "Drag a SWF here to enable advanced telemetry.\n\nUses add-opt-in.py from https://github.com/adamcath/telemetry-utils and Standalone Python 2.7.1 (minimal) from Eric Fimbel.\n\nDoes not support LZMA-compressed SWFs, yet.\n\nDoes not support passwords, yet.\n\n\n© 2012 Fractured Vision Media, LLC - @JosephLabrecque";
		
		private static const MAIN_MENU:String = "mainMenu";
		
		public function Main()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private var _navigator:ScreenNavigator;
		
		private var _theme:MetalWorksMobileTheme;
		private var _transitionManager:ScreenSlidingStackTransitionManager;
		
		private function addedToStageHandler(event:Event):void
		{
			this._theme = new MetalWorksMobileTheme(this.stage);
			
			this._navigator = new ScreenNavigator();
			this.addChild(this._navigator);
			
			this._navigator.addScreen(MAIN_MENU, new ScreenNavigatorItem(MainMenuScreen));
			this._navigator.showScreen(MAIN_MENU);
			
			this._transitionManager = new ScreenSlidingStackTransitionManager(this._navigator);
			this._transitionManager.duration = 0.4;
		}
	}
}