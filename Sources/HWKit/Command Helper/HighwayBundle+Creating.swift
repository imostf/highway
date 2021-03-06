import Foundation
import HighwayCore
import FSKit

public extension HighwayBundle {
    public convenience init(creatingInParent parentUrl: AbsoluteUrl, fileSystem: FileSystem, configuration config: Configuration = .standard, homeBundleConfiguration homeConfig: HomeBundle.Configuration) throws {
        let url = parentUrl.appending(config.directoryName)
        guard fileSystem.directory(at: url).isExistingDirectory == false else {
            throw "Failed to inittialize a highway project: There is already a file at '\(config.directoryName)'."
        }
        try fileSystem.createDirectory(at: url)
        try self.init(url: url, fileSystem: fileSystem, configuration: config)
    
        func _writeXCConfig() throws {
            let configData = xcconfigTemplate.data(using: .utf8)!
            try write(xcconfigData: configData)
        }
        func _writeGitIgnore() throws {
            let data = gitignoreTemplate.data(using: .utf8)!
            try write(gitignore: data)
        }
        
        func _createMainSwiftFile() throws {
            let mainSwiftFileData = mainSwiftTemplate.data(using: .utf8)!
            try write(mainSwiftData: mainSwiftFileData)
        }
        
        func _updatePackageDescription() throws {
            let dependencyUrl = homeConfig.remoteRepositoryUrl
            let fromVersion = config.dependencyFromVersion
            let packageName = config.packageName
            let targetName = config.targetName
            
            let contents = packageDescriptionTemplate(packageName: packageName, targetName: targetName, dependencyFromVersion: fromVersion, dependencyUrl: dependencyUrl)
            let data = contents.data(using: .utf8)!
            try write(packageDescription: data)
        }
        
        try _writeXCConfig()
        try _updatePackageDescription()
        try _createMainSwiftFile()
        try _writeGitIgnore()
    }
}
