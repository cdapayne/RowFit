import SpriteKit

class GameScene: SKScene {
    private let strokeLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
    private let heartLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
    private let distanceLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
    private let caloriesLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")

    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        let labels = [strokeLabel, heartLabel, distanceLabel, caloriesLabel]
        for (index, label) in labels.enumerated() {
            label.fontSize = 24
            label.fontColor = .white
            label.position = CGPoint(x: frame.midX, y: frame.midY + CGFloat(40 - (index * 30)))
            addChild(label)
        }
        strokeLabel.text = "SPM: --"
        heartLabel.text = "HR: --"
        distanceLabel.text = "Distance: --"
        caloriesLabel.text = "Calories: --"

        WatchSessionManager.shared.metricsUpdateHandler = { [weak self] metrics in
            self?.updateMetrics(metrics)
        }
    }

    private func updateMetrics(_ metrics: RowMetrics) {
        strokeLabel.text = String(format: "SPM: %.0f", metrics.strokesPerMinute)
        heartLabel.text = String(format: "HR: %.0f", metrics.heartRate)
        distanceLabel.text = String(format: "Distance: %.1f m", metrics.distance)
        caloriesLabel.text = String(format: "Calories: %.0f", metrics.calories)
    }
}
