import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    
    let windowWidth: CGFloat = 1024
    let windowHeight: CGFloat = 1920
    
    // Get screen dimensions to center the window
    if let screen = NSScreen.main {
      let screenRect = screen.visibleFrame
      let windowRect = NSRect(
        x: (screenRect.width - windowWidth),
        y: (screenRect.height - windowHeight),
        width: windowWidth,
        height: windowHeight
      )
      self.setFrame(windowRect, display: true)
    } else {
      // Fallback if no screen is available
      let windowRect = NSRect(x: 0, y: 0, width: windowWidth, height: windowHeight)
      self.setFrame(windowRect, display: true)
    }
    
    // Set minimum window size to maintain mobile aspect ratio
    self.minSize = NSSize(width: 350, height: 600)
    
    self.contentViewController = flutterViewController

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
