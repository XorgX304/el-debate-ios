import Crashlytics
import ELDebateFramework
import Fabric
import Swinject
import SwinjectAutoregistration
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let assembler: Assembler
    var mainWindowFactory: MainWindowCreating
    var router: Routing
    var window: UIWindow?

    override init() {
        self.assembler = Assembler.defaultAssembler
        self.mainWindowFactory = assembler.resolver ~> MainWindowCreating.self
        self.router = assembler.resolver ~> Routing.self
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        window = mainWindowFactory.makeMainWindow(with: router.navigator)
        router.go(to: .pinEntry)

        return true
    }

    func reset() {
        router.reset(to: .pinEntry)
    }

}
