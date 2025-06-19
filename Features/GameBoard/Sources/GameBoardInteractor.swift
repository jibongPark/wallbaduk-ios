import RIBs
import RxSwift
import GameDomain

public protocol GameBoardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

public protocol GameBoardPresentable: Presentable {
    var listener: GameBoardPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

public protocol GameBoardPresentableListener: AnyObject {
    func didTapBackButton()
}

public protocol GameBoardListener: AnyObject {
    func gameBoardDidFinish()
}

public protocol GameBoardInteractable: Interactable {
    var router: GameBoardRouting? { get set }
    var listener: GameBoardListener? { get set }
}

final class GameBoardInteractor: PresentableInteractor<GameBoardPresentable>, GameBoardInteractable, GameBoardPresentableListener {

    weak var router: GameBoardRouting?
    weak var listener: GameBoardListener?
    
    private let gameSettings: GameSettings

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: GameBoardPresentable, gameSettings: GameSettings) {
        self.gameSettings = gameSettings
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // MARK: - GameBoardPresentableListener
    
    func didTapBackButton() {
        listener?.gameBoardDidFinish()
    }
} 