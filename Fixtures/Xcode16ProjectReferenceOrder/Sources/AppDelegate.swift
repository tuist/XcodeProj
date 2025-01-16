import Framework1
import Framework2
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func applicationDidFinishLaunching(_: UIApplication) {
        print(hello())
    }

    func hello() -> String {
        "AppDelegate.hello()"
    }
}
