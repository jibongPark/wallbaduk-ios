import RIBs
import SwiftUI
import GameDomain

// MARK: - GameMenu Builder
public protocol GameMenuBuildable: Buildable {
    func build(withListener listener: GameMenuListener) -> GameMenuRouting
}

public final class GameMenuBuilder: Builder<GameMenuDependency>, GameMenuBuildable {
    public override init(dependency: GameMenuDependency) {
        super.init(dependency: dependency)
    }
    
    public func build(withListener listener: GameMenuListener) -> GameMenuRouting {
        let _ = GameMenuComponent(dependency: dependency)
        let viewController = GameMenuViewController()
        let interactor = GameMenuInteractor(presenter: viewController)
        interactor.listener = listener
        
        return GameMenuRouter(interactor: interactor, viewController: viewController)
    }
}

// MARK: - GameMenu Component
public final class GameMenuComponent: Component<GameMenuDependency> {}

// MARK: - GameMenu Dependency
public protocol GameMenuDependency: Dependency {}

// MARK: - GameMenu Router
public protocol GameMenuRouting: ViewableRouting {
    func showGameSettings()
    func dismissGameSettings(completion: (() -> Void)?)
}

public final class GameMenuRouter: ViewableRouter<GameMenuInteractable, GameMenuViewControllable>, GameMenuRouting {
    
    public override init(interactor: GameMenuInteractable, viewController: GameMenuViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    public func showGameSettings() {
        let gameSettingsView = GameSettingsView { [weak self] gameSettings in
            // 먼저 설정 화면을 닫고, 완료 후에 게임 시작
            self?.dismissGameSettings {
                // 게임 설정이 완료되면 listener에게 알림
                self?.interactor.listener?.gameMenuDidRequestGameStart(with: gameSettings)
            }
        }
        let hostingController = UIHostingController(rootView: gameSettingsView)
        viewController.uiviewController.present(hostingController, animated: true)
    }
    
    public func dismissGameSettings(completion: (() -> Void)? = nil) {
        viewController.uiviewController.dismiss(animated: true, completion: completion)
    }
}

// MARK: - GameMenu Interactor
public protocol GameMenuInteractable: Interactable {
    var router: GameMenuRouting? { get set }
    var listener: GameMenuListener? { get set }
}

public protocol GameMenuListener: AnyObject {
    func gameMenuDidRequestGameStart()
    func gameMenuDidRequestGameStart(with gameSettings: GameSettings)
}

public final class GameMenuInteractor: Interactor, GameMenuInteractable {
    public weak var router: GameMenuRouting?
    public weak var listener: GameMenuListener?
    
    private let presenter: GameMenuPresentable
    
    public init(presenter: GameMenuPresentable) {
        self.presenter = presenter
        super.init()
        presenter.listener = self
    }
    
    public override func didBecomeActive() {
        super.didBecomeActive()
    }
}

// MARK: - GameMenu View Controller
public protocol GameMenuViewControllable: ViewControllable {}

public protocol GameMenuPresentable: Presentable {
    var listener: GameMenuPresentableListener? { get set }
}

public protocol GameMenuPresentableListener: AnyObject {
    func didTapStartGame()
}

public final class GameMenuViewController: UIViewController, GameMenuViewControllable, GameMenuPresentable {
    public weak var listener: GameMenuPresentableListener?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // 타이틀 라벨
        let titleLabel = UILabel()
        titleLabel.text = "벽바둑"
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 서브타이틀 라벨
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Wall Baduk Game"
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
        listener?.didTapStartGame()
    }
}

// MARK: - GameMenuInteractor Extension
extension GameMenuInteractor: GameMenuPresentableListener {
    public func didTapStartGame() {
        router?.showGameSettings()
    }
} 