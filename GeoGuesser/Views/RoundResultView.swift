import SwiftUI
import CoreLocation

struct RoundResultView: View {
    @ObservedObject var viewModel: GameViewModel
    let result: GuessResult

    private let monthNames = ["January","February","March","April","May","June",
                               "July","August","September","October","November","December"]

    var body: some View {
        ZStack {
            Color(red: 0.98, green: 0.95, blue: 0.90).ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    heroSection
                    dateBreakdown
                    locationBreakdown
                    actionButtons
                        .padding(.bottom, 36)
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
            }
        }
    }

    // MARK: Hero

    var heroSection: some View {
        ZStack(alignment: .bottom) {
            Image(uiImage: result.photo.image)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 220)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 22))

            VStack(spacing: 6) {
                Text(resultMessage)
                    .font(.system(size: 19, weight: .bold, design: .serif))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 4)

                HStack(spacing: 4) {
                    ForEach(0..<result.maxScore, id: \.self) { i in
                        Circle()
                            .fill(i < result.totalScore
                                  ? Color(red: 0.98, green: 0.82, blue: 0.30)
                                  : Color.white.opacity(0.35))
                            .frame(width: 9, height: 9)
                    }
                }

                Text("\(result.totalScore)/\(result.maxScore) pts")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(.bottom, 14)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [.clear, .black.opacity(0.55)],
                    startPoint: .center,
                    endPoint: .bottom
                )
                .clipShape(RoundedRectangle(cornerRadius: 22))
            )
        }
    }

    var resultMessage: String {
        let tier: [String]
        if result.totalScore >= 9 {
            tier = [
                "You know your own life ✨",
                "Living in the memories 🌟",
                "Sharp as a tack",
                "Nothing gets past you"
            ]
        } else if result.totalScore >= 7 {
            tier = [
                "Pretty close, memory champ",
                "Almost had it",
                "Your memory's not bad at all",
                "Just a little off"
            ]
        } else if result.totalScore >= 5 {
            tier = [
                "It's coming back to you...",
                "Somewhere in the ballpark",
                "A hazy but honest attempt",
                "Not your worst guess"
            ]
        } else if result.totalScore >= 3 {
            tier = [
                "Your past is a blur, huh?",
                "Time is a flat circle",
                "When was this again?",
                "The mind forgets what the heart felt"
            ]
        } else {
            tier = [
                "Did this even happen? 🌫️",
                "A mystery from your own life",
                "Complete blackout",
                "Were you even there?"
            ]
        }
        return tier[abs(result.id.hashValue) % tier.count]
    }

    // MARK: Date

    var dateBreakdown: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Date", systemImage: "calendar")
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(Color(red: 0.22, green: 0.15, blue: 0.10))

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your guess")
                        .font(.system(size: 11, design: .rounded))
                        .foregroundColor(Color(red: 0.55, green: 0.45, blue: 0.38))
                    Text("\(monthNames[result.guessedMonth - 1]) \(String(result.guessedYear))")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(Color(red: 0.22, green: 0.15, blue: 0.10))
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Actual")
                        .font(.system(size: 11, design: .rounded))
                        .foregroundColor(Color(red: 0.55, green: 0.45, blue: 0.38))
                    Text("\(monthNames[result.actualMonth - 1]) \(String(result.actualYear))")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(Color(red: 0.22, green: 0.15, blue: 0.10))
                }
            }

            HStack(spacing: 8) {
                ScoreChip(
                    label: result.yearScore == 2 ? "Year ✓" : "Year ✗",
                    points: result.yearScore,
                    correct: result.yearScore > 0
                )
                ScoreChip(
                    label: result.monthScore == 2 ? "Month ✓" : "Month ✗",
                    points: result.monthScore,
                    correct: result.monthScore > 0
                )
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.60)))
    }

    // MARK: Location

    var locationBreakdown: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Location", systemImage: "mappin.circle.fill")
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(Color(red: 0.22, green: 0.15, blue: 0.10))

            if let guessed = result.guessedCoordinate {
                locationDetails(guessed: guessed)
            } else {
                Text("No pin placed — 0 pts for location")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(Color(red: 0.55, green: 0.45, blue: 0.38))
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.60)))
    }

    @ViewBuilder
    func locationDetails(guessed: CLLocationCoordinate2D) -> some View {
        let actualLoc = CLLocation(latitude: result.photo.coordinate.latitude,
                                   longitude: result.photo.coordinate.longitude)
        let guessedLoc = CLLocation(latitude: guessed.latitude, longitude: guessed.longitude)
        let km = Int(actualLoc.distance(from: guessedLoc) / 1000)

        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Your pin")
                    .font(.system(size: 11, design: .rounded))
                    .foregroundColor(Color(red: 0.55, green: 0.45, blue: 0.38))
                Text(String(format: "%.2f°, %.2f°", guessed.latitude, guessed.longitude))
                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                    .foregroundColor(Color(red: 0.22, green: 0.15, blue: 0.10))
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text("Actual")
                    .font(.system(size: 11, design: .rounded))
                    .foregroundColor(Color(red: 0.55, green: 0.45, blue: 0.38))
                Text(String(format: "%.2f°, %.2f°",
                            result.photo.coordinate.latitude,
                            result.photo.coordinate.longitude))
                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                    .foregroundColor(Color(red: 0.22, green: 0.15, blue: 0.10))
            }
        }

        ScoreChip(
            label: "~\(km) km off",
            points: result.locationScore,
            correct: result.locationScore >= 4
        )
    }

    // MARK: Buttons

    var actionButtons: some View {
        let isLast = viewModel.session.currentPhotoIndex + 1 >= viewModel.session.photos.count
        return VStack(spacing: 10) {
            Button(action: { viewModel.continueToNext() }) {
                Text(isLast ? "See Final Results" : "Continue Guessing")
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
                Text("Quit")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(Color(red: 0.50, green: 0.40, blue: 0.32))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.7)))
            }
        }
    }
}

// MARK: - ScoreChip

struct ScoreChip: View {
    let label: String
    let points: Int
    let correct: Bool

    var body: some View {
        HStack(spacing: 5) {
            Text(label)
                .font(.system(size: 12, weight: .medium, design: .rounded))
            Text("+\(points)")
                .font(.system(size: 11, weight: .bold, design: .rounded))
        }
        .foregroundColor(
            correct
            ? Color(red: 0.18, green: 0.50, blue: 0.28)
            : Color(red: 0.60, green: 0.22, blue: 0.18)
        )
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(correct
                      ? Color(red: 0.88, green: 0.97, blue: 0.90)
                      : Color(red: 0.98, green: 0.89, blue: 0.87))
        )
    }
}
