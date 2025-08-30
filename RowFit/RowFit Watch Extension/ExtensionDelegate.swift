import WatchKit
import WatchConnectivity
import Foundation

struct RowMetrics: Codable {
    let strokesPerMinute: Double
    let heartRate: Double
    let distance: Double
    let calories: Double
}

class ExtensionDelegate: NSObject, WKApplicationDelegate, WCSessionDelegate {
    var timer: Timer?

    func applicationDidFinishLaunching() {
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Activation handling is not needed for this simple example but the
        // delegate method must be present to conform to WCSessionDelegate.
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard let command = message["command"] as? String else { return }
        switch command {
        case "startWorkout":
            startSendingMetrics()
        case "stopWorkout":
            stopSendingMetrics()
        default:
            break
        }
    }

    func startSendingMetrics() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let metrics = RowMetrics(
                strokesPerMinute: Double.random(in: 20...35),
                heartRate: Double.random(in: 100...160),
                distance: Double.random(in: 0...1000),
                calories: Double.random(in: 0...200)
            )
            if let data = try? JSONEncoder().encode(metrics) {
                WCSession.default.sendMessage(["metrics": data], replyHandler: nil, errorHandler: nil)
            }
        }
    }

    func stopSendingMetrics() {
        timer?.invalidate()
        timer = nil
    }

    func applicationWillResignActive() {
        stopSendingMetrics()
    }
}
