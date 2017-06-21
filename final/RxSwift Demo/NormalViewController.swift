import UIKit

// If you drink more than one beer, you can't drive (hide car).
// If you drink more than two beers, you shouldn't surf (hide surf).
// If you drink more than three beers, you shouldn't ski (hide ski).
// If you ski or surf, you need to drive before you can do the other (enable or disable).
// Can't drink more than four beers (hide)
// Can't consecutively surf twice (disable)
// Can't consecutively ski twice (disable)
// Can only do 5 activities (hide)

//NEW RULE: If you start the day with a beer, can't do anything else besides drink beer. (disable)
struct Emoji {
  static let beer = "🍺"
  static let surf = "🏄"
  static let ski = "⛷"
  static let car = "🚗"
}

class NormalViewController: UIViewController {

  // MARK: Outlets
  @IBOutlet weak var skiButton: UIButton!
  @IBOutlet weak var surfButton: UIButton!
  @IBOutlet weak var beerButton: UIButton!
  @IBOutlet weak var carButton: UIButton!
  @IBOutlet weak var activityTableView: UITableView!

  // MARK: Actions
  @IBAction func clearButtonPressed(_ sender: Any) {
    activities.removeAll()
    resetButtons()
    activityTableView.reloadData()
  }

  @IBAction func activityButtonPressed(_ sender: UIButton) {
    guard let activity = sender.titleLabel?.text else { return }

    appendActivity(activity)

    updateButtonState()
  }

  // MARK: Model
  var activities: [String] = []

  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    style()
    activityTableView.dataSource = self
    activityTableView.delegate = self
  }

  // MARK: Private methods
  private func appendActivity(_ activity: String) {
    activities.append(activity)
    activityTableView.reloadData()
  }

  /// This method makes sure the correct buttons are enabled or disabled
  private func updateButtonState() {
    let activityCount = activities.count

    let beerCount = activities.filter { $0 == Emoji.beer }.count

    if beerCount > 1 { carButton.isHidden = true }

    if beerCount > 2 { surfButton.isHidden = true }

    if beerCount > 3 { skiButton.isHidden = true }

    guard let lastActivity = activities.last else { return }
    guard let firstActivity = activities.first else { return }

    if lastActivity == Emoji.surf {
      surfButton.isEnabled = false
      skiButton.isEnabled = false
    }

    if lastActivity == Emoji.ski {
      skiButton.isEnabled = false
      surfButton.isEnabled = false
    }

    if lastActivity == Emoji.car {
      skiButton.isEnabled = true
      surfButton.isEnabled = true
    }

    if beerCount > 3 {
      beerButton.isHidden = true
    }

    if activityCount > 4 {
      skiButton.isEnabled = false
      surfButton.isEnabled = false
      beerButton.isEnabled = false
      carButton.isEnabled = false
    }

    if firstActivity == Emoji.beer {
      surfButton.isEnabled = false
      skiButton.isEnabled = false
      carButton.isEnabled = false
    }

  }

  private func resetButtons() {
    skiButton.isEnabled = true
    surfButton.isEnabled = true
    beerButton.isEnabled = true
    carButton.isEnabled = true
    skiButton.isHidden = false
    surfButton.isHidden = false
    beerButton.isHidden = false
    carButton.isHidden = false
  }

}

extension NormalViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView
      .dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)

    let activity = activities[indexPath.row]

    cell.textLabel?.text = activity

    return cell
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return activities.count
  }

}

extension NormalViewController: UITableViewDelegate {

}

extension NormalViewController {
  func style() {
    skiButton.setTitle("X", for: .disabled)
    surfButton.setTitle("X", for: .disabled)
    beerButton.setTitle("X", for: .disabled)
    carButton.setTitle("X", for: .disabled)
  }
}
