import Foundation
import CoreLocation

struct GuessResult: Identifiable {
    let id = UUID()
    let photo: GamePhoto
    let guessedYear: Int
    let guessedMonth: Int
    let guessedCoordinate: CLLocationCoordinate2D?

    var actualYear: Int { Calendar.current.component(.year, from: photo.takenDate) }
    var actualMonth: Int { Calendar.current.component(.month, from: photo.takenDate) }

    var yearScore: Int { guessedYear == actualYear ? 2 : 0 }
    var monthScore: Int { guessedMonth == actualMonth ? 2 : 0 }

    var locationScore: Int {
        guard let coord = guessedCoordinate else { return 0 }
        let actual = CLLocation(latitude: photo.coordinate.latitude, longitude: photo.coordinate.longitude)
        let guessed = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        let km = actual.distance(from: guessed) / 1000
        if km <= 10 { return 6 }
        if km >= 500 { return 0 }
        return Int((6.0 * (1.0 - (km - 10) / 490.0)).rounded())
    }

    var totalScore: Int { yearScore + monthScore + locationScore }
    let maxScore = 10
}
