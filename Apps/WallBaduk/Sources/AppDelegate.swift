import UIKit
import RIBs
import GameMenu

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 앱 시작시 필요한 초기화 작업
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Scene을 생성할 때 호출됨
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Scene이 해제될 때 호출됨
    }
}

// MARK: - Empty Dependency for Root
final class EmptyDependency: AppDependency {}

// MARK: - App Component Extension
extension AppComponent: GameMenuDependency {}

// MARK: - Basic RIB Setup
protocol LaunchRouting: ViewableRouting {
    func launch(from window: UIWindow)
}

final class RootRouter: ViewableRouter<RootInteractable, RootViewControllable>, LaunchRouting, RootRouting {
    
    private let gameMenuBuilder: GameMenuBuildable
    private var gameMenuRouter: GameMenuRouting?
    
    init(interactor: RootInteractable, viewController: RootViewControllable, gameMenuBuilder: GameMenuBuildable) {
        self.gameMenuBuilder = gameMenuBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func launch(from window: UIWindow) {
        let gameMenuRouter = gameMenuBuilder.build(withListener: interactor)
        self.gameMenuRouter = gameMenuRouter
        
        attachChild(gameMenuRouter)
        window.rootViewController = gameMenuRouter.viewControllable.uiviewController
        window.makeKeyAndVisible()
    }
}

protocol RootInteractable: Interactable, GameMenuListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {}

// MARK: - Simplified Root View Controller
final class RootViewController: UIViewController, RootViewControllable {
    // 이제 GameMenu RIB가 메인 화면을 담당하므로 간단하게 유지
}

final class RootInteractor: Interactor, RootInteractable {
    weak var router: RootRouting?
    weak var listener: RootListener?
    
    override func didBecomeActive() {
        super.didBecomeActive()
    }
    
    // MARK: - GameMenuListener
    func gameMenuDidRequestGameStart() {
        // TODO: 게임 시작 로직 구현
        print("게임 시작 요청됨")
    }
}

protocol RootBuildable: Buildable {
    func build() -> LaunchRouting
}

final class RootBuilder: Builder<AppComponent>, RootBuildable {
    
    func build() -> LaunchRouting {
        let viewController = RootViewController()
        let interactor = RootInteractor()
        let gameMenuBuilder = GameMenuBuilder(dependency: dependency)
        
        return RootRouter(
            interactor: interactor,
            viewController: viewController,
            gameMenuBuilder: gameMenuBuilder
        )
    }
}

protocol RootRouting: ViewableRouting {}
protocol RootListener: AnyObject {} 
