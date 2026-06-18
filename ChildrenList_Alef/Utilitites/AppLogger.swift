import Foundation
import OSLog

final class AppLogger {
    static let shared = AppLogger()

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "ChildrenList_Alef",
        category: "Application"
    )

    private init() {}

    func debug(_ message: String) {
        logger.debug("\(message, privacy: .public)")
    }
}
