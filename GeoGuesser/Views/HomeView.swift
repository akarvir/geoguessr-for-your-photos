import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var pulse = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.98, green: 0.95, blue: 0.90),
                         Color(red: 0.99, green: 0.91, blue: 0.87)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 16) {
                    Text("📷")
                        .font(.system(size: 72))
                        .scaleEffect(pulse ? 1.06 : 1.0)
                        .animation(
                            .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                            value: pulse
                        )

                    Text("Roll Guesser")
                        .font(.system(size: 38, weight: .bold, design: .serif))
                        .foregroundColor(Color(red: 0.22, green: 0.15, blue: 0.10))

                    Text("How well do you know your own life?")
                        .font(.system(size: 16, design: .rounded))
                        .foregroundColor(Color(red: 0.50, green: 0.40, blue: 0.32))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }

                Spacer()
                Spacer()

                Button(action: { viewModel.startRound() }) {
                    HStack(spacing: 12) {
                        if viewModel.isLoadingPhotos {
                            ProgressView().tint(.white)
                            Text("Picking photos...")
                        } else {
                            Image(systemName: "play.fill")
                            Text("Play Round")
                        }
                    }
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 22)
                            .fill(Color(red: 0.85, green: 0.42, blue: 0.58))
                            .shadow(
                                color: Color(red: 0.85, green: 0.42, blue: 0.58).opacity(0.45),
                                radius: 16, y: 8
                            )
                    )
                }
                .disabled(viewModel.isLoadingPhotos)
                .padding(.horizontal, 32)

                Spacer().frame(height: 80)
            }
        }
        .onAppear { pulse = true }
    }
}
