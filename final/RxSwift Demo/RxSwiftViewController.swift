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
enum Activity: String {
  case beer = "🍺"
  case surf = "🏄"
  case ski = "⛷"
  case car = "🚗"
}

class RxSwiftViewController: UIViewController {
  fileprivate let bag = DisposeBag()

  @IBOutlet weak var clearButton: UIButton!
  @IBOutlet weak var skiButton: UIButton!
  @IBOutlet weak var surfButton: UIButton!
  @IBOutlet weak var beerButton: UIButton!
  @IBOutlet weak var carButton: UIButton!
  @IBOutlet weak var activityTableView: UITableView!

  // MARK: Private Observables

  var viewModel = RxSwiftViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    style()

    /// We will use these below so it makes it easy to have them handy.

    // MARK: Button Bindings

    // Ski ⛷⛷⛷⛷⛷⛷⛷⛷⛷⛷⛷⛷⛷⛷⛷⛷⛷⛷⛷⛷⛷⛷

    viewModel.skiButtonIsHidden.drive(skiButton.rx.isHidden).disposed(by: bag)

    viewModel.skiButtonIsEnabled.drive(skiButton.rx.isEnabled).disposed(by: bag)

    // Surf 🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄🏄

    // isHidden: Hide when we have 5 activities or 3 beers


    // isEnabled: Enable when last activity is not skiing or surfing

    // Beer 🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺
    viewModel.beerButtonIsHidden.drive(beerButton.rx.isHidden).disposed(by: bag)

    // isEnabled: -------------

    // Car 🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗

    // isHidden: Hide when you drink 2 or more beers


    // isEnabled: -------------

    setupActions()

    // MARK: TableView Binding
    viewModel.activities
      .bind(to: activityTableView.rx.items(cellIdentifier: "activityCell")) { index, model, cell in
        cell.textLabel?.text = model.rawValue
      }
      .disposed(by: bag)
  }
}

extension RxSwiftViewController {
  // MARK: Actions
  func setupActions() {

    skiButton.rx.tap
      .subscribe(onNext: { [unowned self] _ in
        self.viewModel.activityButtonPressed(activity: .ski)
      })
      .disposed(by: bag)

    surfButton.rx.tap
      .subscribe(onNext: { [unowned self] _ in
        self.viewModel.activityButtonPressed(activity: .surf)
      })
      .disposed(by: bag)

    beerButton.rx.tap
      .subscribe(onNext: { [unowned self] _ in
        self.viewModel.activityButtonPressed(activity: .beer)
      })
      .disposed(by: bag)

    carButton.rx.tap
      .subscribe(onNext: { [unowned self] _ in
        self.viewModel.activityButtonPressed(activity: .car)
      })
      .disposed(by: bag)

    clearButton.rx.tap
      .subscribe(onNext: { [unowned self] _ in
        self.viewModel.clearButtonPressed()
      })
      .disposed(by: bag)

  }
}

extension RxSwiftViewController {
  func style() {
    skiButton.setTitle("X", for: .disabled)
    surfButton.setTitle("X", for: .disabled)
    beerButton.setTitle("X", for: .disabled)
    carButton.setTitle("X", for: .disabled)
  }
}
