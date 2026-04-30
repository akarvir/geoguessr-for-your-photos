import SwiftUI
import Photos

struct ContentView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var authStatus: PHAuthorizationStatus =
        PHPhotoLibrary.authorizationStatus(for: .readWrite)

    var body: some View {
        Group {
            switch authStatus {
            case .notDetermined:
                PermissionView {
                    PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                        DispatchQueue.main.async { authStatus = status }
                    }
                }
            case .denied, .restricted:
                PermissionDeniedView()
            default:
                gameContent
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
        ) { _ in
            authStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        }
    }

    @ViewBuilder
    var gameContent: some View {
        switch viewModel.state {
        case .home:
            HomeView(viewModel: viewModel)
        case .playing:
            if let photo = viewModel.session.currentPhoto {
                PhotoRoundView(viewModel: viewModel, photo: photo)
                    .id(viewModel.session.currentPhotoIndex)
            } else {
                HomeView(viewModel: viewModel)
            }
        case .roundResult:
            if let result = viewModel.lastResult {
                RoundResultView(viewModel: viewModel, result: result)
                    .id(viewModel.session.currentPhotoIndex)
            } else {
                HomeView(viewModel: viewModel)
            }
        case .finalResult:
            FinalResultsView(viewModel: viewModel)
        }
    }
}
