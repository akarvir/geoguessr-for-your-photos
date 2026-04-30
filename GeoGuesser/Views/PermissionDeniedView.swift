import SwiftUI

struct PermissionDeniedView: View {
    var body: some View {
        ZStack {
            Color(red: 0.98, green: 0.95, blue: 0.90).ignoresSafeArea()

            VStack(spacing: 20) {
                Text("🔒")
                    .font(.system(size: 64))

                Text("Photos access denied")
                    .font(.system(size: 22, weight: .bold, design: .serif))
                    .foregroundColor(Color(red: 0.22, green: 0.15, blue: 0.10))

                Text("Open Settings and allow GeoGuesser to access your photos.")
                    .font(.system(size: 15, design: .rounded))
                    .foregroundColor(Color(red: 0.50, green: 0.40, blue: 0.32))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Button(action: {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("Open Settings")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 0.85, green: 0.42, blue: 0.58))
                        )
                }
            }
        }
    }
}
