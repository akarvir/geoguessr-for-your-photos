import Foundation
import CoreLocation
import UIKit

struct GamePhoto: Identifiable {
    let id = UUID()
    let image: UIImage
    let takenDate: Date
    let coordinate: CLLocationCoordinate2D
}
