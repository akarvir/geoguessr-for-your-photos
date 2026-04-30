import Photos
import UIKit
import CoreLocation

class PhotoLibraryManager: ObservableObject {
    @Published var authorizationStatus: PHAuthorizationStatus =
        PHPhotoLibrary.authorizationStatus(for: .readWrite)

    func requestPermission(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            DispatchQueue.main.async {
                self?.authorizationStatus = status
                completion(status == .authorized || status == .limited)
            }
        }
    }

    func fetchRandomGeotaggedPhotos(count: Int, completion: @escaping ([GamePhoto]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)

            var geotagged: [PHAsset] = []
            allPhotos.enumerateObjects { asset, _, _ in
                if asset.location != nil, asset.creationDate != nil {
                    geotagged.append(asset)
                }
            }

            let selected = Array(geotagged.shuffled().prefix(count))
            var gamePhotos: [GamePhoto] = []
            let group = DispatchGroup()
            let manager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            options.deliveryMode = .highQualityFormat

            for asset in selected {
                group.enter()
                guard let date = asset.creationDate, let location = asset.location else {
                    group.leave()
                    continue
                }
                manager.requestImage(
                    for: asset,
                    targetSize: CGSize(width: 900, height: 900),
                    contentMode: .aspectFit,
                    options: options
                ) { image, _ in
                    defer { group.leave() }
                    guard let img = image else { return }
                    gamePhotos.append(GamePhoto(
                        image: img,
                        takenDate: date,
                        coordinate: location.coordinate
                    ))
                }
            }

            group.notify(queue: .main) { completion(gamePhotos) }
        }
    }
}
