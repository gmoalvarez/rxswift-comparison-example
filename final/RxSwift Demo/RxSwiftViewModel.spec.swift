import XCTest
import RxSwift
import RxBlocking
@testable import RxSwift_Demo

class RxSwiftViewModel_spec: XCTestCase {

  var viewModel: RxSwiftViewModel!

  override func setUp() {
    super.setUp()
    viewModel = RxSwiftViewModel()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testSkiButtonIsHiddenWhenOverFiveActivities() {
    let skiButtonIsHiddenBefore = try! viewModel.skiButtonIsHidden.asObservable().toBlocking().first()!
    XCTAssert(skiButtonIsHiddenBefore == false)

    viewModel.activityButtonPressed(activity: .surf)
    viewModel.activityButtonPressed(activity: .car)
    viewModel.activityButtonPressed(activity: .car)
    viewModel.activityButtonPressed(activity: .beer)
    viewModel.activityButtonPressed(activity: .beer)

    let skiButtonIsHiddenAfter = try! viewModel.skiButtonIsHidden.asObservable().toBlocking().first()!
    XCTAssert(skiButtonIsHiddenAfter == true)
  }

  func testSkiButtonIsHiddenWhenFourBeers() {
    let skiButtonIsHiddenBefore = try! viewModel.skiButtonIsHidden.asObservable().toBlocking().first()!
    XCTAssert(skiButtonIsHiddenBefore == false)

    viewModel.activityButtonPressed(activity: .beer)
    viewModel.activityButtonPressed(activity: .beer)
    viewModel.activityButtonPressed(activity: .beer)
    viewModel.activityButtonPressed(activity: .beer)

    let skiButtonIsHiddenAfter = try! viewModel.skiButtonIsHidden.asObservable().toBlocking().first()!
    XCTAssert(skiButtonIsHiddenAfter == true)
  }

}
