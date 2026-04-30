import SwiftUI
import MapKit

struct PhotoRoundView: View {
    @ObservedObject var viewModel: GameViewModel
    let photo: GamePhoto

    @State private var mapRegion: MKCoordinateRegion
    @State private var yearOptions: [Int] = []

    private let months = ["Jan","Feb","Mar","Apr","May","Jun",
                          "Jul","Aug","Sep","Oct","Nov","Dec"]

    init(viewModel: GameViewModel, photo: GamePhoto) {
        self.viewModel = viewModel
        self.photo = photo
        _mapRegion = State(initialValue: MKCoordinateRegion(
            center: photo.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 12, longitudeDelta: 12)
        ))
    }

    var body: some View {
        ZStack {
            Color(red: 0.98, green: 0.95, blue: 0.90).ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    progressBar
                    photoCard
                    yearSection
                    monthSection
                    locationSection
                    submitButton
                        .padding(.bottom, 32)
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
            }
        }
        .onAppear { yearOptions = viewModel.yearOptions(for: photo) }
    }

    // MARK: Progress

    var progressBar: some View {
        HStack {
            Text("Photo \(viewModel.session.currentPhotoIndex + 1) of \(viewModel.session.photos.count)")
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(Color(red: 0.50, green: 0.40, blue: 0.32))
            Spacer()
            HStack(spacing: 5) {
                ForEach(0..<viewModel.session.photos.count, id: \.self) { i in
                    Capsule()
                        .fill(i <= viewModel.session.currentPhotoIndex
                              ? Color(red: 0.85, green: 0.42, blue: 0.58)
                              : Color(red: 0.85, green: 0.42, blue: 0.58).opacity(0.22))
                        .frame(
                            width: i == viewModel.session.currentPhotoIndex ? 22 : 8,
                            height: 8
                        )
                        .animation(.spring(response: 0.3), value: viewModel.session.currentPhotoIndex)
                }
            }
        }
    }

    // MARK: Photo

    var photoCard: some View {
        Image(uiImage: photo.image)
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .frame(height: 280)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 22))
            .shadow(color: .black.opacity(0.14), radius: 14, y: 6)
    }

    // MARK: Year

    var yearSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("When was this taken?", icon: "calendar")
            HStack(spacing: 8) {
                ForEach(yearOptions, id: \.self) { year in
                    let selected = viewModel.currentGuess.year == year
                    Button { viewModel.currentGuess.year = year } label: {
                        Text(String(year))
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(selected ? .white : Color(red: 0.22, green: 0.15, blue: 0.10))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selected
                                          ? Color(red: 0.85, green: 0.42, blue: 0.58)
                                          : Color.white.opacity(0.8))
                                    .shadow(color: .black.opacity(selected ? 0 : 0.05), radius: 3, y: 2)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .cardStyle()
    }

    // MARK: Month

    var monthSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("Which month?", icon: "leaf")
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4),
                spacing: 8
            ) {
                ForEach(Array(months.enumerated()), id: \.offset) { i, month in
                    let selected = viewModel.currentGuess.month == i + 1
                    Button { viewModel.currentGuess.month = i + 1 } label: {
                        Text(month)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(Color(red: 0.22, green: 0.15, blue: 0.10))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(selected
                                          ? Color(red: 0.98, green: 0.82, blue: 0.30)
                                          : Color.white.opacity(0.8))
                                    .shadow(color: .black.opacity(selected ? 0 : 0.04), radius: 2, y: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .cardStyle()
    }

    // MARK: Location

    var locationSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionLabel("Where were you?", icon: "mappin.circle.fill")
            Text(viewModel.currentGuess.coordinate == nil
                 ? "Tap to drop a pin"
                 : "Pin placed — tap to move it")
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(Color(red: 0.55, green: 0.45, blue: 0.38))
            MapPickerView(region: $mapRegion, selectedCoordinate: $viewModel.currentGuess.coordinate)
                .frame(height: 240)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.10), radius: 8, y: 4)
        }
        .cardStyle()
    }

    // MARK: Submit

    var submitButton: some View {
        let ready = viewModel.currentGuess.isReadyToSubmit
        return Button(action: { viewModel.submitGuess() }) {
            Text("Submit Guess")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 17)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(ready
                              ? Color(red: 0.85, green: 0.42, blue: 0.58)
                              : Color(red: 0.75, green: 0.70, blue: 0.68))
                        .shadow(
                            color: ready
                                ? Color(red: 0.85, green: 0.42, blue: 0.58).opacity(0.4)
                                : .clear,
                            radius: 12, y: 6
                        )
                )
        }
        .disabled(!ready)
    }

    // MARK: Helpers

    func sectionLabel(_ text: String, icon: String) -> some View {
        Label(text, systemImage: icon)
            .font(.system(size: 15, weight: .semibold, design: .rounded))
            .foregroundColor(Color(red: 0.22, green: 0.15, blue: 0.10))
    }
}

private extension View {
    func cardStyle() -> some View {
        self
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.60)))
    }
}
