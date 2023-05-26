import XCTest
@testable import DalculatorResources

final class DalculatorResourcesTests: XCTestCase {
    
    func testFonts() throws {
        try DalculatorFont.register()
    }
    
    func testResources() throws {
        try DalculatorFont.register()
        try R.validate()
    }
    
}
