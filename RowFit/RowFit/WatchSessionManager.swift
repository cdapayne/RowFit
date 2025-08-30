import Foundation
import WatchConnectivity

struct RowMetrics: Codable {
    let strokesPerMinute: Double
    let heartRate: Double
    let distance: Double
    let calories: Double
}

class WatchSessionManager: NSObject, WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {
        // No-op for iOS, but required to conform to WCSessionDelegate.
        // When a session becomes inactive the counterpart app has been
        // switched. We simply keep the delegate in place so the session
        // can be reactivated when needed.
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // Once the old session has been deactivated it must be
        // reactivated before further communication can occur. Activate
        // immediately to resume the connection with the watch.
        session.activate()
    }
    
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

    func requestStopWorkout() {
        guard WCSession.isSupported(), WCSession.default.isPaired else { return }
        let message = ["command": "stopWorkout"]
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
