import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var selectedTime = Date()
    @State private var permissionGranted = false
    @State private var showToast = false
    @State private var timerSet = false

    var body: some View {
        ZStack {
            // すりガラス風背景
            Color.clear
                .background(.ultraThinMaterial)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .frame(width: 100)
                    .disabled(timerSet)

                Button(action: {
                    if !timerSet {
                        requestNotificationPermission {
                            scheduleNotifications(for: selectedTime)
                            withAnimation { showToast = true }
                            timerSet = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation { showToast = false }
                            }
                        }
                    } else {
                        // 完了ボタンが押されたとき、リセット
                        timerSet = false
                    }
                }) {
                    Text(timerSet ? "完了" : "タイマーをセット")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(
                                colors: timerSet ?
                                    [Color.green, Color.green.opacity(0.7)] :
                                    [Color.blue, Color.purple],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(radius: 6)
                }
                .buttonStyle(PlainButtonStyle())
                // .disabled(timerSet) ← 無効化は削除

            }
            .padding(20)

            // トースト通知
            if showToast {
                VStack {
                    Spacer()
                    Text("通知をセットしました")
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .shadow(radius: 8)
                        .padding(.bottom, 20)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    func requestNotificationPermission(completion: @escaping () -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            permissionGranted = granted
            if granted {
                completion()
            }
        }
    }

    func scheduleNotifications(for date: Date) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        if let fiveMinutesBefore = Calendar.current.date(byAdding: .minute, value: -5, to: date) {
            scheduleNotification(at: fiveMinutesBefore, title: "あと5分です", body: "指定した時間まで残り5分です。")
        }
        scheduleNotification(at: date, title: "タイマー終了", body: "指定した時間になりました。")
    }

    func scheduleNotification(at date: Date, title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body

        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
