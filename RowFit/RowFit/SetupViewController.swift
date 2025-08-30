import UIKit

class SetupViewController: UIViewController {
    private let instructionsLabel = UILabel()
    private let connectButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        instructionsLabel.text = "Connect your Apple Watch to track your rowing metrics."
        instructionsLabel.numberOfLines = 0
        instructionsLabel.textAlignment = .center

        connectButton.setTitle("Connect Watch", for: .normal)
        connectButton.addTarget(self, action: #selector(connectTapped), for: .touchUpInside)

        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        connectButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(instructionsLabel)
        view.addSubview(connectButton)

        NSLayoutConstraint.activate([
            instructionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instructionsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            instructionsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            connectButton.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 30),
            connectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func connectTapped() {
        WatchSessionManager.shared.activateSession()
        WatchSessionManager.shared.requestStartWorkout()
        dismiss(animated: true, completion: nil)
    }
}
