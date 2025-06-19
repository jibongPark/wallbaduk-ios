import RIBs
import GameDomain

public protocol GameBoardDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class GameBoardComponent: Component<GameBoardDependency> {
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

public protocol GameBoardBuildable: Buildable {
    func build(withListener listener: GameBoardListener, gameSettings: GameSettings) -> GameBoardRouting
}

public final class GameBoardBuilder: Builder<GameBoardDependency>, GameBoardBuildable {

    public override init(dependency: GameBoardDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: GameBoardListener, gameSettings: GameSettings) -> GameBoardRouting {
        let _ = GameBoardComponent(dependency: dependency)
        let viewController = GameBoardViewController(gameSettings: gameSettings)
        let interactor = GameBoardInteractor(presenter: viewController, gameSettings: gameSettings)
        interactor.listener = listener
        return GameBoardRouter(interactor: interactor, viewController: viewController)
    }
} 