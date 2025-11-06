import SwiftUI

struct SleepTimerSheet: View {
    @ObservedObject var timerManager: SleepTimerManager
    @Environment(\.dismiss) private var dismiss

    @State private var hours: Int
    @State private var minutes: Int

    init(timerManager: SleepTimerManager) {
        self.timerManager = timerManager
        let initialSeconds = Int(timerManager.remainingTime ?? 30 * 60)
        _hours = State(initialValue: min(initialSeconds / 3600, 12))
        _minutes = State(initialValue: (initialSeconds % 3600) / 60)
    }

    private var totalSeconds: Int {
        (hours * 3600) + (minutes * 60)
    }

    private var formattedSelection: String {
        let seconds = TimeInterval(totalSeconds)
        guard seconds > 0 else { return "" }
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = seconds >= 3600 ? [.hour, .minute] : [.minute]
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 2
        return formatter.string(from: seconds) ?? ""
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Duration"), footer: footerText) {
                    HStack(spacing: 0) {
                        Picker("Hours", selection: $hours) {
                            ForEach(0..<13, id: \.self) { value in
                                Text("\(value)h").tag(value)
                            }
                        }
                        .pickerStyle(.wheel)

                        Picker("Minutes", selection: $minutes) {
                            ForEach(0..<60, id: \.self) { value in
                                Text("\(value)m").tag(value)
                            }
                        }
                        .pickerStyle(.wheel)
                    }
                    .frame(height: 160)
                }

                Section("Presets") {
                    presetRow(minutes: 15, label: "15 minutes")
                    presetRow(minutes: 30, label: "30 minutes")
                    presetRow(minutes: 60, label: "1 hour")
                    presetRow(minutes: 120, label: "2 hours")
                }

                if timerManager.isActive, let current = timerManager.formattedRemaining {
                    Section("Active Timer") {
                        HStack {
                            Label("Ends in \(current)", systemImage: "timer")
                                .font(.subheadline)
                        }

                        Button(role: .destructive) {
                            timerManager.cancel()
                        } label: {
                            Label("Cancel Sleep Timer", systemImage: "stop.circle")
                        }
                    }
                }
            }
            .navigationTitle("Sleep Timer")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button(timerManager.isActive ? "Update" : "Start") {
                        timerManager.start(duration: TimeInterval(totalSeconds))
                        dismiss()
                    }
                    .disabled(totalSeconds == 0)
                }
            }
        }
    }

    private var footerText: some View {
        Group {
            if totalSeconds == 0 {
                Text("Choose a duration to enable the sleep timer.")
            } else {
                Text("Sounds will stop after \(formattedSelection).")
            }
        }
    }

    private func presetRow(minutes preset: Int, label: String) -> some View {
        Button {
            let clamped = min(max(preset, 1), 12 * 60)
            hours = clamped / 60
            minutes = clamped % 60
        } label: {
            HStack {
                Text(label)
                Spacer()
                if hours * 60 + minutes == preset {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.tint)
                }
            }
        }
    }
}

struct SleepTimerSheet_Previews: PreviewProvider {
    static var previews: some View {
        let audioManager = AudioManager()
        SleepTimerSheet(timerManager: SleepTimerManager(audioManager: audioManager))
    }
}
