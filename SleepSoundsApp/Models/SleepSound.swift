import SwiftUI

struct SleepSound: Identifiable, Hashable {
    let id: String
    let name: String
    let assetName: String
    let iconSystemName: String
    let accentColor: Color
    let defaultVolume: Double
}

extension SleepSound {
    static let catalog: [SleepSound] = [
        SleepSound(
            id: "rain",
            name: "Rain",
            assetName: "rain",
            iconSystemName: "cloud.rain.fill",
            accentColor: .blue,
            defaultVolume: 0.5
        ),
        SleepSound(
            id: "ocean",
            name: "Ocean Waves",
            assetName: "ocean",
            iconSystemName: "water.waves",
            accentColor: .cyan,
            defaultVolume: 0.5
        ),
        SleepSound(
            id: "whitenoise",
            name: "White Noise",
            assetName: "whitenoise",
            iconSystemName: "waveform",
            accentColor: .gray,
            defaultVolume: 0.5
        ),
        SleepSound(
            id: "forest",
            name: "Forest",
            assetName: "forest",
            iconSystemName: "leaf.fill",
            accentColor: .green,
            defaultVolume: 0.5
        ),
        SleepSound(
            id: "fire",
            name: "Fireplace",
            assetName: "fire",
            iconSystemName: "flame.fill",
            accentColor: .orange,
            defaultVolume: 0.5
        ),
        SleepSound(
            id: "wind",
            name: "Wind",
            assetName: "wind",
            iconSystemName: "wind",
            accentColor: .purple,
            defaultVolume: 0.5
        )
    ]
}
