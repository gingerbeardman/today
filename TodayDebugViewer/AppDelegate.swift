//
//  AppDelegate.swift
//  TodayDebugViewer
//
//  Created by David Roberts on 14/03/2019.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!

	lazy var screenSaverView = TodayView(frame: NSZeroRect, isPreview: false)

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application

		if let screenSaverView = screenSaverView, let contentView = window.contentView {
			screenSaverView.frame = contentView.bounds
			contentView.addSubview(screenSaverView)
		}
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

}

