import Swinject
import SwinjectAutoregistration

public enum ControllerType {

    case pinEntry
    case answer(voteContext: VoteContext)
    case comment(voteContext: VoteContext)

}

public protocol ControllerCreating {

    func makeController(of type: ControllerType) -> ControllerProviding

}

public class ControllerFactory: ControllerCreating {

    private let resolver: Resolver

    public init(resolver: Resolver) {
        self.resolver = resolver
    }

    public func makeController(of type: ControllerType) -> ControllerProviding {
        switch type {
        case .pinEntry:
            return resolver ~> PinEntryViewController.self
        case let .answer(voteContext: voteContext):
            return resolver ~> (AnswerViewController.self, argument: voteContext)
        case let .comment(voteContext: voteContext):
            return resolver ~> (CommentViewController.self, argument: voteContext)
        }
    }

}
