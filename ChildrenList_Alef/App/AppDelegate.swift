import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        setupDependencies()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveUserData()
    }
    
    private func setupDependencies() {
        let userDefaultsManager = UserDefaultsManagerImpl()
        let userStore = UserStore(storage: userDefaultsManager)
        let vm = UserInfoViewModel(userStore: userStore)
        
        let vc = UserInfoViewController(vm: vm)
        let navVC = UINavigationController(rootViewController: vc)
        
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
    
    private func saveUserData() {
        if let rootNav = window?.rootViewController as? UINavigationController,
           let vc = rootNav.viewControllers.first as? UserInfoViewController {
            vc.saveData()
        }
    }
    
    
}

