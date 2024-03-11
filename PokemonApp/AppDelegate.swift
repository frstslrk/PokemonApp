import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: Coordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window =  UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        coordinator = Coordinator(navigationController: navigationController)
        coordinator?.start()
        window.rootViewController = coordinator?.navigationController
        self.window = window
        window.makeKeyAndVisible()
        return true
    }
}

