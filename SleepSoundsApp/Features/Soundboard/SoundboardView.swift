import SwiftUI

struct SoundboardView: View {
    @StateObject private var audioManager = AudioManager()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 24) {
                    ForEach(audioManager.sounds) { sound in
                        SoundCardView(sound: sound, audioManager: audioManager)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 24)
            }
            .navigationTitle("Sleep Sounds")
            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        }
    }
}

struct SoundboardView_Previews: PreviewProvider {
    static var previews: some View {
        SoundboardView()
    }
}
