import SwiftUI

struct PermissionView: View {
    let onRequest: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.98, green: 0.95, blue: 0.90),
                         Color(red: 0.99, green: 0.91, blue: 0.87)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer()

                Text("📸")
                    .font(.system(size: 72))

                VStack(spacing: 12) {
                    Text("Your camera roll,\nyour playground")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                        .foregroundColor(Color(red: 0.22, green: 0.15, blue: 0.10))
                        .multilineTextAlignment(.center)

                    Text("GeoGuesser needs access to your photos to pull 5 random images each round.")
                        .font(.system(size: 15, design: .rounded))
                        .foregroundColor(Color(red: 0.50, green: 0.40, blue: 0.32))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                Spacer()

                Button(action: onRequest) {
                    Text("Allow Photo Access")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(red: 0.85, green: 0.42, blue: 0.58))
                                .shadow(
                                    color: Color(red: 0.85, green: 0.42, blue: 0.58).opacity(0.4),
                                    radius: 14, y: 7
                                )
                        )
                }
                .padding(.horizontal, 32)

                Spacer().frame(height: 60)
            }
        }
    }
}
