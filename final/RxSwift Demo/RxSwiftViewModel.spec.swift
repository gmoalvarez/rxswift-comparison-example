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

    viewModel.activityButtonPressed(activity: Emoji.surf)
    viewModel.activityButtonPressed(activity: Emoji.car)
    viewModel.activityButtonPressed(activity: Emoji.car)
    viewModel.activityButtonPressed(activity: Emoji.beer)
    viewModel.activityButtonPressed(activity: Emoji.beer)

    let skiButtonIsHiddenAfter = try! viewModel.skiButtonIsHidden.asObservable().toBlocking().first()!
    XCTAssert(skiButtonIsHiddenAfter == true)
  }

  func testSkiButtonIsHiddenWhenFourBeers() {
    let skiButtonIsHiddenBefore = try! viewModel.skiButtonIsHidden.asObservable().toBlocking().first()!
    XCTAssert(skiButtonIsHiddenBefore == false)

    viewModel.activityButtonPressed(activity: Emoji.beer)
    viewModel.activityButtonPressed(activity: Emoji.beer)
    viewModel.activityButtonPressed(activity: Emoji.beer)
    viewModel.activityButtonPressed(activity: Emoji.beer)

    let skiButtonIsHiddenAfter = try! viewModel.skiButtonIsHidden.asObservable().toBlocking().first()!
    XCTAssert(skiButtonIsHiddenAfter == true)
  }

}
