import RIBs

public protocol GameBoardViewControllable: ViewControllable {
    // TODO: Declare methods the router can invoke to manipulate the view hierarchy.
}

final class GameBoardRouter: ViewableRouter<GameBoardInteractable, GameBoardViewControllable>, GameBoardRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: GameBoardInteractable, viewController: GameBoardViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
} 