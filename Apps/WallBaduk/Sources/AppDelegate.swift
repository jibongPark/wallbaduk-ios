import UIKit
import RIBs

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var launchRouter: LaunchRouting?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        // RIBs 앱 시작
        let launchRouter = RootBuilder(dependency: AppComponent()).build()
        self.launchRouter = launchRouter
        launchRouter.launch(from: window)
        
        return true
    }
}

// MARK: - Basic RIB Setup
protocol LaunchRouting: ViewableRouting {
    func launch(from window: UIWindow)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, LaunchRouting {
    
    func launch(from window: UIWindow) {
        window.rootViewController = viewController.uiviewController
        window.makeKeyAndVisible()
    }
}

protocol RootInteractable: Interactable {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {}

final class RootViewController: UIViewController, RootViewControllable {}

final class RootInteractor: Interactor, RootInteractable {
    weak var router: RootRouting?
    weak var listener: RootListener?
    
    override func didBecomeActive() {
        super.didBecomeActive()
    }
}

protocol RootBuildable: Buildable {
    func build() -> LaunchRouting
}

final class RootBuilder: Builder<AppDependency>, RootBuildable {
    
    func build() -> LaunchRouting {
        let viewController = RootViewController()
        let interactor = RootInteractor()
        
        return RootRouter(interactor: interactor, viewController: viewController)
    }
}

protocol RootRouting: ViewableRouting {}
protocol RootListener: AnyObject {} 