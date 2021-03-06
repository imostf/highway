import Foundation
import FSKit

private let _gitAutotagCommand = "git-autotag"

public final class GitAutotag {
    // MARK: - Properties
    public let context: Context
    
    // MARK: - Init
    public init(context: Context = .local()) throws {
        guard context.containsExecutableFor(command: _gitAutotagCommand) else {
            throw "\(_gitAutotagCommand): Executable found."
        }
        self.context = context
    }
    
    // MARK: - Tagging
    @discardableResult
    public func autotag(at url: AbsoluteUrl, dryRun: Bool = true) throws -> String {
        let arguments = dryRun ? ["-n"] : []
        let task = try Task(commandName: "git-autotag", arguments: arguments, currentDirectoryURL: url, executableFinder: context.executableFinder)
        task.output = .pipeChannel()
        task.enableReadableOutputDataCapturing()
        context.executor.execute(task: task)
        
        guard task.state.successfullyFinished else {
            throw "git autotag failed."
        }
        guard let outputData = task.readOutputData else {
            throw "Failed to get current tag."
        }
        guard let rawTag = String(data: outputData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            throw "Failed to get current tag."
        }
        let numberOfDots = rawTag.reduce(0) { (result, char) -> Int in
            return char == "." ? result + 1 : result
        }
        guard numberOfDots == 2 else {
            throw "'\(rawTag)' is not a valid version number: Must contain two '.'."
        }
        return rawTag
    }
}
