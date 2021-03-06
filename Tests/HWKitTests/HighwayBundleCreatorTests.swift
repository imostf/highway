import XCTest
import HWKit
import HighwayCore
import TestKit
import FSKit

final class HighwayBundleCreatorTests: XCTestCase {
    func testSuccess() {
        let fs = InMemoryFileSystem()
        let url = AbsoluteUrl("/highway-go")
        let homeUrl = AbsoluteUrl("/.highway")
        XCTAssertNoThrow(try fs.createDirectory(at: url))
        XCTAssertNoThrow(try fs.createDirectory(at: homeUrl))
        let bundle: HighwayBundle
        let config = HighwayBundle.Configuration.standard
        do {
            bundle = try HighwayBundle(creatingInParent: .root, fileSystem: fs, configuration: config, homeBundleConfiguration: .standard)
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        
        XCTAssertTrue(fs.file(at: bundle.mainSwiftFileUrl).isExistingFile)
        XCTAssertTrue(fs.file(at: bundle.packageFileUrl).isExistingFile)
        XCTAssertTrue(fs.file(at: bundle.xcconfigFileUrl).isExistingFile)
        XCTAssertTrue(fs.file(at: bundle.gitignoreFileUrl).isExistingFile)
    }
}
