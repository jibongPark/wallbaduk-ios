import UIKit
import RIBs
import GameMenu
import GameBoard

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
extension AppComponent: GameBoardDependency {}

// MARK: - Basic RIB Setup
protocol LaunchRouting: ViewableRouting {
    func launch(from window: UIWindow)
}

final class RootRouter: ViewableRouter<RootInteractable, RootViewControllable>, LaunchRouting, RootRouting {
    
    private let gameMenuBuilder: GameMenuBuildable
    private let gameBoardBuilder: GameBoardBuildable
    private var gameMenuRouter: GameMenuRouting?
    private var gameBoardRouter: GameBoardRouting?
    
    init(interactor: RootInteractable, viewController: RootViewControllable, gameMenuBuilder: GameMenuBuildable, gameBoardBuilder: GameBoardBuildable) {
        self.gameMenuBuilder = gameMenuBuilder
        self.gameBoardBuilder = gameBoardBuilder
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
    
    // MARK: - RootRouting
    
    func routeToGameBoard(with gameSettings: GameSettings) {
        guard let gameMenuRouter = self.gameMenuRouter else { return }
        
        let gameBoardRouter = gameBoardBuilder.build(withListener: interactor, gameSettings: gameSettings)
        self.gameBoardRouter = gameBoardRouter
        
        attachChild(gameBoardRouter)
        
        // GameMenu의 viewController를 통해 전체화면으로 GameBoard 표시
        let gameBoardViewController = gameBoardRouter.viewControllable.uiviewController
        gameBoardViewController.modalPresentationStyle = .fullScreen
        gameMenuRouter.viewControllable.uiviewController.present(gameBoardViewController, animated: true)
    }
    
    func detachGameBoard() {
        guard let gameBoardRouter = gameBoardRouter else { return }
        
        gameBoardRouter.viewControllable.uiviewController.dismiss(animated: true) { [weak self] in
            self?.detachChild(gameBoardRouter)
            self?.gameBoardRouter = nil
        }
    }
}

protocol RootInteractable: Interactable, GameMenuListener, GameBoardListener {
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
        // 게임 시작 요청 시 아무 동작 없음 (GameMenuRouter에서 직접 처리)
        print("게임 시작 요청됨")
    }
    
    func gameMenuDidRequestGameStart(with gameSettings: GameSettings) {
        // 게임 설정과 함께 게임 시작 요청
        router?.routeToGameBoard(with: gameSettings)
    }
    
    // MARK: - GameBoardListener
    func gameBoardDidFinish() {
        router?.detachGameBoard()
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
        let gameBoardBuilder = GameBoardBuilder(dependency: dependency)
        
        return RootRouter(
            interactor: interactor,
            viewController: viewController,
            gameMenuBuilder: gameMenuBuilder,
            gameBoardBuilder: gameBoardBuilder
        )
    }
}

protocol RootRouting: ViewableRouting {
    func routeToGameBoard(with gameSettings: GameSettings)
    func detachGameBoard()
}
protocol RootListener: AnyObject {} 
