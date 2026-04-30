import SwiftUI

struct FinalResultsView: View {
    @ObservedObject var viewModel: GameViewModel

    var totalScore: Int { viewModel.session.totalScore }
    var maxScore: Int { viewModel.session.maxTotalScore }
    var pct: Double { maxScore > 0 ? Double(totalScore) / Double(maxScore) : 0 }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.98, green: 0.95, blue: 0.90),
                         Color(red: 0.99, green: 0.91, blue: 0.87)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    Spacer().frame(height: 20)

                    // Score header
                    VStack(spacing: 10) {
                        Text(finalMessage)
                            .font(.system(size: 26, weight: .bold, design: .serif))
                            .foregroundColor(Color(red: 0.22, green: 0.15, blue: 0.10))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)

                        Text("\(totalScore)")
                            .font(.system(size: 72, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 0.85, green: 0.42, blue: 0.58))

                        Text("out of \(maxScore) points")
                            .font(.system(size: 16, design: .rounded))
                            .foregroundColor(Color(red: 0.55, green: 0.45, blue: 0.38))
                    }

                    // Per-photo rows
                    VStack(spacing: 8) {
                        ForEach(Array(viewModel.session.results.enumerated()), id: \.offset) { idx, r in
                            HStack(spacing: 12) {
                                Image(uiImage: r.photo.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 46, height: 46)
                                    .clipped()
                                    .clipShape(RoundedRectangle(cornerRadius: 8))

                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Photo \(idx + 1)")
                                        .font(.system(size: 13, weight: .medium, design: .rounded))
                                        .foregroundColor(Color(red: 0.22, green: 0.15, blue: 0.10))
                                    HStack(spacing: 4) {
                                        Text("\(r.yearScore + r.monthScore) date")
                                        Text("+")
                                        Text("\(r.locationScore) location")
                                    }
                                    .font(.system(size: 11, design: .rounded))
                                    .foregroundColor(Color(red: 0.55, green: 0.45, blue: 0.38))
                                }

                                Spacer()

                                Text("\(r.totalScore)/10")
                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(red: 0.85, green: 0.42, blue: 0.58))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(
                                        Capsule()
                                            .fill(Color(red: 0.85, green: 0.42, blue: 0.58).opacity(0.12))
                                    )
                            }
                            .padding(12)
                            .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.65)))
                        }
                    }
                    .padding(.horizontal, 16)

                    // Buttons
                    VStack(spacing: 10) {
                        Button(action: { viewModel.startRound() }) {
                            HStack(spacing: 10) {
                                Image(systemName: "arrow.clockwise")
                                Text("Play Again")
                            }
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 17)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color(red: 0.85, green: 0.42, blue: 0.58))
                                    .shadow(
                                        color: Color(red: 0.85, green: 0.42, blue: 0.58).opacity(0.4),
                                        radius: 12, y: 6
                                    )
                            )
                        }

                        Button(action: { viewModel.goHome() }) {
                            Text("Home")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(Color(red: 0.50, green: 0.40, blue: 0.32))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.7))
                                )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 40)
                }
            }
        }
    }

    var finalMessage: String {
        if pct >= 0.85 { return "You know your own life ✨" }
        if pct >= 0.65 { return "A pretty solid memory" }
        if pct >= 0.45 { return "It's coming back to you..." }
        return "Your past is a mystery 🌫️"
    }
}
