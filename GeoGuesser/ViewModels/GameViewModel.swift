import Foundation
import CoreLocation
import Combine

class GameViewModel: ObservableObject {
    @Published var session = GameSession()
    @Published var state: AppState = .home
    @Published var isLoadingPhotos = false
    @Published var currentGuess = CurrentGuess()
    @Published var lastResult: GuessResult?

    private let photoManager = PhotoLibraryManager()

    enum AppState { case home, playing, roundResult, finalResult }

    struct CurrentGuess {
        var year: Int? = nil
        var month: Int? = nil
        var coordinate: CLLocationCoordinate2D? = nil

        var isReadyToSubmit: Bool { year != nil && month != nil }
    }

    func startRound() {
        isLoadingPhotos = true
        session = GameSession()
        currentGuess = CurrentGuess()
        photoManager.fetchRandomGeotaggedPhotos(count: 5) { [weak self] photos in
            guard let self else { return }
            self.session.photos = photos
            self.isLoadingPhotos = false
            self.state = photos.isEmpty ? .home : .playing
        }
    }

    func submitGuess() {
        guard let photo = session.currentPhoto,
              let year = currentGuess.year,
              let month = currentGuess.month else { return }
        let result = GuessResult(
            photo: photo,
            guessedYear: year,
            guessedMonth: month,
            guessedCoordinate: currentGuess.coordinate
        )
        session.results.append(result)
        lastResult = result
        state = .roundResult
    }

    func continueToNext() {
        session.currentPhotoIndex += 1
        currentGuess = CurrentGuess()
        state = session.isComplete ? .finalResult : .playing
    }

    func goHome() {
        state = .home
        session = GameSession()
    }

    func yearOptions(for photo: GamePhoto) -> [Int] {
        let actual = Calendar.current.component(.year, from: photo.takenDate)
        let currentYear = Calendar.current.component(.year, from: Date())
        let range = Array(max(2000, actual - 5)...min(currentYear, actual + 5))
        var options = Set<Int>([actual])
        var attempts = 0
        while options.count < min(4, range.count), attempts < 100 {
            if let r = range.randomElement() { options.insert(r) }
            attempts += 1
        }
        return options.sorted()
    }
}
