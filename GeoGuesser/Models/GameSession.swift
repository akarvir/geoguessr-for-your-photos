import Foundation

class GameSession: ObservableObject {
    @Published var photos: [GamePhoto] = []
    @Published var results: [GuessResult] = []
    @Published var currentPhotoIndex: Int = 0

    var currentPhoto: GamePhoto? {
        guard currentPhotoIndex < photos.count else { return nil }
        return photos[currentPhotoIndex]
    }

    var isComplete: Bool { currentPhotoIndex >= photos.count }
    var totalScore: Int { results.reduce(0) { $0 + $1.totalScore } }
    var maxTotalScore: Int { photos.count * 10 }
}
