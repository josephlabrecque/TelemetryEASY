package
{	
	import com.fracturedvisionmedia.telemetryEASY.Main;
	
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NativeDragEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	
	import feathers.system.DeviceCapabilities;
	
	import starling.core.Starling;
	
	
	public class TelemetryEASY extends MovieClip
	{
		private var _dragTarget:Sprite;
		private var _starling:Starling;
		private var nativeProcess:NativeProcess;
		private var nativeProcessStartupInfo:NativeProcessStartupInfo;
		private var py:File;
		private var op:File;
		
		public function TelemetryEASY()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			setupProcessor();
		}
		
		private function setupProcessor():void
		{
			nativeProcess = new NativeProcess();
			nativeProcess.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
			nativeProcess.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onErrorData);
			nativeProcess.addEventListener(NativeProcessExitEvent.EXIT, onExit);
			nativeProcess.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
			nativeProcess.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
			nativeProcessStartupInfo = new NativeProcessStartupInfo();
			
			op = File.applicationDirectory;
			op = op.resolvePath("\python\\add-opt-in.py");
			
			py = File.applicationDirectory;
			py = py.resolvePath("\python\\python.exe");
			nativeProcessStartupInfo.executable = py;
		}
		
		private function addedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			_dragTarget = new Sprite();
			_dragTarget.graphics.beginFill(0x00000, 0);
			_dragTarget.graphics.drawRect(0,0,stage.stageWidth,stage.stageWidth);
			_dragTarget.graphics.endFill();
			this.addChild(_dragTarget);
			_dragTarget.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onDragEnter);
			_dragTarget.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDragDrop);
			
			if(this.stage)
			{
				this.stage.align = StageAlign.TOP_LEFT;
				this.stage.scaleMode = StageScaleMode.NO_SCALE;
			}
			
			DeviceCapabilities.dpi = 200;
			DeviceCapabilities.screenPixelWidth = stage.stageWidth;
			DeviceCapabilities.screenPixelHeight = stage.stageHeight;
			
			this.loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
		}
		
		private function loaderInfo_completeHandler(e:Event):void
		{
			this.start();
		}
		
		private function start():void
		{
			this.gotoAndStop(2);
			this.graphics.clear();
			
			Starling.handleLostContext = true;
			Starling.multitouchEnabled = true;
			this._starling = new Starling(Main, this.stage);
			this._starling.enableErrorChecking = false;
			this._starling.start();
		}
		
		private function onDragEnter(e:NativeDragEvent):void 
		{
			if(!nativeProcess.running){
				NativeDragManager.acceptDragDrop(_dragTarget);
			}
		}
		
		private function onDragDrop(e:NativeDragEvent):void 
		{
			var dropfiles:Array = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			for each (var file:File in dropfiles){
				if(!file.isDirectory){
					switch (file.extension.toLowerCase()){
						case "swf" :
							runPythonScript(file);
							break;
						default:
							updateMessage("This isn't a swf... what are you trying to do?\n\nFeed me a swf.");
					}
				}else{
					updateMessage("This isn't a file at all... you dragging a folder here?\n\nThat isn't going to work :(");
				}
			}
		}
		
		private function updateMessage(s:String):void
		{
			(_starling.stage.getChildAt(1) as Main).message = s;
		}
		
		private function runPythonScript(f:File):void
		{
			var processArgs:Vector.<String> = new Vector.<String>();
			processArgs.push(op.nativePath);
			processArgs.push(f.nativePath);
			nativeProcessStartupInfo.arguments = processArgs;
			nativeProcess.start(nativeProcessStartupInfo);
		}
		
		private function onOutputData(e:ProgressEvent):void {
			//updateMessage(nativeProcess.standardOutput.readUTFBytes(nativeProcess.standardOutput.bytesAvailable));
		}
		
		private function onErrorData(e:ProgressEvent):void {
			//updateMessage(nativeProcess.standardError.readUTFBytes(nativeProcess.standardError.bytesAvailable)); 
		}
		
		private function onExit(e:NativeProcessExitEvent):void {
			if(e.exitCode == 0){
				updateMessage("Telemetry Tag Added!\n\nHooray :D");
			}else if(e.exitCode == 1){
				updateMessage("Looks like Telemetry is already enabled.\n\nGood for you!");
			}else{
				updateMessage("I AM ERROR");
			}
		}
		
		private function onIOError(e:IOErrorEvent):void {
			updateMessage(e.toString());
		}
		
	}
}