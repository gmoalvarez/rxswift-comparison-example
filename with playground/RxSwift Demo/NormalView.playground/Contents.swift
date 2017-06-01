import UIKit
import PlaygroundSupport

struct Emoji {
  static let beer = "🍺"
  static let surf = "🏄"
  static let ski = "⛷"
  static let car = "🚗"
}

class NormalViewController: UIViewController {
  let rootStackView = UIStackView()
  let topHorizontalStackView = UIStackView()
  let bottomHorizontalStackView = UIStackView()
  let activityTableView = UITableView()
  let clearButton = UIButton()
  let skiButton = UIButton()
  let surfButton = UIButton()
  let beerButton = UIButton()
  let carButton = UIButton()
}

extension NormalViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white
    // Set up Root Stack View
    rootStackView.translatesAutoresizingMaskIntoConstraints = false
    rootStackView.axis = .vertical
    rootStackView.distribution = .fillEqually
    rootStackView.spacing = 8

    //Set up Clear Button
    clearButton.setTitle("Clear", for: .normal)
    clearButton.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)

    // Set up Top Horizontal Stack View
    topHorizontalStackView.axis = .horizontal
    topHorizontalStackView.distribution = .fillEqually
    topHorizontalStackView.spacing = 8

    skiButton.setTitle(Emoji.ski, for: .normal)
    skiButton.titleLabel?.font = skiButton.titleLabel?.font.withSize(80)
    skiButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    surfButton.setTitle(Emoji.surf, for: .normal)
    surfButton.titleLabel?.font = skiButton.titleLabel?.font.withSize(80)
    surfButton.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    topHorizontalStackView.addArrangedSubview(skiButton)
    topHorizontalStackView.addArrangedSubview(surfButton)

    // Set up Bottom Horizontal Stack View
    bottomHorizontalStackView.axis = .horizontal
    bottomHorizontalStackView.distribution = .fillEqually
    bottomHorizontalStackView.spacing = 8

    beerButton.setTitle(Emoji.beer, for: .normal)
    beerButton.titleLabel?.font = skiButton.titleLabel?.font.withSize(80)
    beerButton.backgroundColor = #colorLiteral(red: 0.7736830855, green: 0.6743415421, blue: 1, alpha: 1)
    carButton.setTitle(Emoji.car, for: .normal)
    carButton.titleLabel?.font = skiButton.titleLabel?.font.withSize(80)
    carButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.7020508371, blue: 0.6519458884, alpha: 1)
    bottomHorizontalStackView.addArrangedSubview(beerButton)
    bottomHorizontalStackView.addArrangedSubview(carButton)

    view.addSubview(rootStackView)
    view.addSubview(clearButton)
//    rootStackView.addArrangedSubview(clearButton)
    rootStackView.addArrangedSubview(topHorizontalStackView)
    rootStackView.addArrangedSubview(bottomHorizontalStackView)
    rootStackView.addArrangedSubview(activityTableView)

    //Activate layout constraints
    NSLayoutConstraint.activate([
      clearButton.heightAnchor.constraint(equalToConstant: 50.0),
      clearButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      clearButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      clearButton.bottomAnchor.constraint(equalTo: rootStackView.topAnchor),
//      rootStackView.topAnchor.constraint(equalTo: view.topAnchor),
      rootStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      rootStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      rootStackView.topAnchor.constraint(equalTo: clearButton.bottomAnchor),
      rootStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
      ])
  }
}

let vc = NormalViewController()

PlaygroundPage.current.liveView = vc
