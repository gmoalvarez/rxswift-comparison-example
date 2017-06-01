import UIKit
import RxSwift
import RxCocoa

// If you drink more than one beer, you can't drive (hide car).
// If you drink more than two beers, you shouldn't surf (hide surf).
// If you drink more than three beers, you shouldn't ski (hide ski).
// If you ski or surf, you need to drive before you can do the other (enable or disable).
// Can't drink more than four beers (hide)
// Can't consecutively surf twice (disable)
// Can't consecutively ski twice (disable)
// Can only do 5 activities (hide)

//NEW RULE: If you ski or surf, you need to drive before you can do the other (enable or disable).
class RxSwiftViewController: UIViewController {
  fileprivate let bag = DisposeBag()

  @IBOutlet weak var clearButton: UIButton!
  @IBOutlet weak var skiButton: UIButton!
  @IBOutlet weak var surfButton: UIButton!
  @IBOutlet weak var beerButton: UIButton!
  @IBOutlet weak var carButton: UIButton!
  @IBOutlet weak var activityTableView: UITableView!

  // MARK: Private Observables
  fileprivate var _activities = Variable<[String]>([])
  var activities: Observable<[String]> {
    return _activities.asObservable()
  }

  var beerCount: Observable<Int> {
    return activities.map { activities -> Int in
      return activities.filter { $0 == Emoji.beer }.count
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    printObservables()

    /// We will use these below so it makes it easy to have them handy.
    let lastActivity = activities.map { $0.last }
    let firstActivity = activities.map { $0.first }
    let activityCount = activities.map { $0.count }
    // MARK: Button Bindings

    // Ski ⛷⛷⛷⛷⛷⛷⛷⛷⛷⛷⛷⛷⛷⛷⛷⛷⛷⛷⛷⛷⛷⛷ //

    // isHidden: Hide when we have 5 activities or 4 beers.
    Observable
      .combineLatest(activityCount, beerCount ) { $0 >= 5 && $1 >= 4 }
      .bind(to: skiButton.rx.isHidden)
      .disposed(by: bag)

    
    // isEnabled: Enable when the last activity is not skiing and first is not beer.
    Observable.combineLatest(lastActivity, firstActivity)
      { $0 != Emoji.ski && $1 != Emoji.beer}
      .bind(to: skiButton.rx.isEnabled)
      .disposed(by: bag)

    // Surf 🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄 //

    // isHidden: Hide when we have 5 activities or 3 beers
    Observable
      .combineLatest(activityCount, beerCount ) { $0 >= 5 && $1 >= 3 }
      .bind(to: surfButton.rx.isHidden)
      .disposed(by: bag)

    // isEnabled: Enable when last activity is not surfing
    Observable.combineLatest(lastActivity, firstActivity)
    { $0 != Emoji.surf && $1 != Emoji.beer }
      .bind(to: surfButton.rx.isEnabled)
      .disposed(by: bag)

    // Beer 🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺 //

    // isHidden: Hide when we drink 4 beers or 5 activities
    Observable
      .combineLatest(activityCount, beerCount ) { $0 >= 5 && $1 >= 4 }
      .bind(to: beerButton.rx.isHidden)
      .disposed(by: bag)

    // isEnabled: -------------

    // Car 🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗 //

    // isHidden: Hide when you drink 2 or more beers
    Observable
      .combineLatest(activityCount, beerCount ) { $0 >= 5 && $1 >= 2 }
      .bind(to: carButton.rx.isHidden)
      .disposed(by: bag)

    // isEnabled: -------------

    setupActions()

    // MARK: TableView Binding
    activities
      .bind(to: activityTableView.rx.items(cellIdentifier: "activityCell")) { index, model, cell in
        cell.textLabel?.text = model
      }
      .disposed(by: bag)
  }
}

extension RxSwiftViewController {
  // MARK: Actions
  func setupActions() {

    skiButton.rx.tap
      .subscribe(onNext: { [unowned self] _ in
        self._activities.value.append(Emoji.ski)
      })
      .disposed(by: bag)

    surfButton.rx.tap
      .subscribe(onNext: { [unowned self] _ in
        self._activities.value.append(Emoji.surf)
      })
      .disposed(by: bag)

    beerButton.rx.tap
      .subscribe(onNext: { [unowned self] _ in
        self._activities.value.append(Emoji.beer)
      })
      .disposed(by: bag)

    carButton.rx.tap
      .subscribe(onNext: { [unowned self] _ in
        self._activities.value.append(Emoji.car)
      })
      .disposed(by: bag)

    clearButton.rx.tap
      .subscribe(onNext: { [unowned self] _ in
        self._activities.value.removeAll()
      })
      .disposed(by: bag)
  }
}

// MARK: Debug
extension RxSwiftViewController {
  func printObservables() {

    beerCount.subscribe(onNext: {
      print("beer count changed to \($0)")
    })
    .disposed(by: bag)


  }
}
