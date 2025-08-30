import Foundation
import WatchConnectivity

struct RowMetrics: Codable {
    let strokesPerMinute: Double
    let heartRate: Double
    let distance: Double
    let calories: Double
}

class WatchSessionManager: NSObject, WCSessionDelegate {
    static let shared = WatchSessionManager()
    private override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
        }
    }

    var metricsUpdateHandler: ((RowMetrics) -> Void)?
    var isActivated: Bool {
        return WCSession.isSupported() && WCSession.default.activationState == .activated
    }

    func activateSession() {
        guard WCSession.isSupported() else { return }
        WCSession.default.activate()
    }

    func requestStartWorkout() {
        guard WCSession.isSupported(), WCSession.default.isPaired else { return }
        let message = ["command": "startWorkout"]
        WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)
    }

    // MARK: - WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Handle activation completion if needed
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard let data = message["metrics"] as? Data,
              let metrics = try? JSONDecoder().decode(RowMetrics.self, from: data) else { return }
        DispatchQueue.main.async {
            self.metricsUpdateHandler?(metrics)
        }
    }
}
