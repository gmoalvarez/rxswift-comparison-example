import RxCocoa
import RxSwift

class RxSwiftViewModel {

  init() {

  }

  // MARK: Inputs... Accept Actions from the view controller
  func activityButtonPressed(activity: Activity) {
    _activities.value.append(activity)
  }

  func clearButtonPressed() {
    _activities.value.removeAll()
  }

  // MARK: Outputs... Unidirectional bindings

  // Bind to TableView
  var activities: Observable<[Activity]> {
    return _activities.asObservable()
  }

  // Drivers

  // isHidden: Hide when we have 5 activities or 4 beers.
  var skiButtonIsHidden: Driver<Bool> {
    return Observable
      .combineLatest(activityCount, beerCount ) { $0 >= 5 || $1 >= 4 }
      .asDriver(onErrorJustReturn: false)
  }

  // isEnabled: Enable when the last activity is not skiing or surfing.
  var skiButtonIsEnabled: Driver<Bool> {
    return Observable.combineLatest(lastActivity, firstActivity)
    { $1 != .beer || $0 != .surf && $0 != .ski || $0 == .car }
      .asDriver(onErrorJustReturn: false)
  }

  // isHidden: Hide when we drink 4 beers or 5 activities
  var beerButtonIsHidden: Driver<Bool> {
    return Observable.combineLatest(beerCount, activityCount)
      { $0 >= 4 || $1 >= 5 }
      .asDriver(onErrorJustReturn: false)
  }




  // MARK: Private
  private var _activities = Variable<[Activity]>([])


  private var beerCount: Observable<Int> {
    return activities.map { activities -> Int in
      return activities.filter { $0 == .beer }.count
    }
  }

  private var lastActivity: Observable<Activity?> {
    return activities.map { $0.last }
  }

  private var firstActivity: Observable<Activity?> {
    return activities.map { $0.first }
  }

  private var activityCount: Observable<Int> {
    return activities.map { $0.count }
  }

}
