import UIKit
import RIBs

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

// MARK: - Basic RIB Setup
protocol LaunchRouting: ViewableRouting {
    func launch(from window: UIWindow)
}

final class RootRouter: ViewableRouter<RootInteractable, RootViewControllable>, LaunchRouting {
    
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

final class RootViewController: UIViewController, RootViewControllable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // 타이틀 라벨
        let titleLabel = UILabel()
        titleLabel.text = "Wall Baduk"
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 서브타이틀 라벨
        let subtitleLabel = UILabel()
        subtitleLabel.text = "벽 바둑 게임"
        subtitleLabel.font = .systemFont(ofSize: 18, weight: .medium)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 시작 버튼
        let startButton = UIButton(type: .system)
        startButton.setTitle("게임 시작", for: .normal)
        startButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        startButton.backgroundColor = .systemBlue
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 12
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startGameTapped), for: .touchUpInside)
        
        // 설정 버튼
        let settingsButton = UIButton(type: .system)
        settingsButton.setTitle("설정", for: .normal)
        settingsButton.titleLabel?.font = .systemFont(ofSize: 18)
        settingsButton.setTitleColor(.systemBlue, for: .normal)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        
        // 스택뷰로 구성
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, startButton, settingsButton])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -40),
            
            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.widthAnchor.constraint(equalToConstant: 200),
            
            settingsButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func startGameTapped() {
        // TODO: 게임 시작 로직 구현
        print("게임 시작!")
        
        // 임시로 알림 표시
        let alert = UIAlertController(title: "게임 시작", message: "Wall Baduk 게임이 곧 시작됩니다!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func settingsTapped() {
        // TODO: 설정 화면 구현
        print("설정 화면!")
        
        // 임시로 알림 표시
        let alert = UIAlertController(title: "설정", message: "설정 화면은 추후 구현 예정입니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

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

final class RootBuilder: Builder<AppComponent>, RootBuildable {
    
    func build() -> LaunchRouting {
        let viewController = RootViewController()
        let interactor = RootInteractor()
        
        return RootRouter(interactor: interactor, viewController: viewController)
    }
}

protocol RootRouting: ViewableRouting {}
protocol RootListener: AnyObject {} 
