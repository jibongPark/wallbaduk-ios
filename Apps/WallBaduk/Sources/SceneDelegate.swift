import UIKit
import RIBs

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var launchRouter: LaunchRouting?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        // RIBs 앱 시작
        let appComponent = AppComponent(dependency: EmptyDependency())
        let launchRouter = RootBuilder(dependency: appComponent).build()
        self.launchRouter = launchRouter
        launchRouter.launch(from: window)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Scene이 해제될 때 호출됨
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Scene이 활성화될 때 호출됨
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Scene이 비활성화되기 전에 호출됨
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Scene이 포어그라운드로 진입할 때 호출됨
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Scene이 백그라운드로 진입할 때 호출됨
    }
} 