import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    
    // Set minimum window size to maintain mobile aspect ratio
    self.minSize = NSSize(width: 350, height: 600)
    
    self.contentViewController = flutterViewController

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
    
    // Maximize window after everything is set up
    DispatchQueue.main.async {
      self.maximizeWindow()
    }
  }
  
  private func maximizeWindow() {
    if let screen = NSScreen.main {
      let visibleFrame = screen.visibleFrame
      // Set window to use the full visible frame (maximum size while respecting menu bar and dock)
      self.setFrame(visibleFrame, display: true, animate: false)
    }
  }
}
