import SwiftUI
import MapKit

struct MapPickerView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var selectedCoordinate: CLLocationCoordinate2D?

    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.delegate = context.coordinator
        map.region = region
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.isPitchEnabled = false
        map.isRotateEnabled = false
        let tap = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleTap(_:))
        )
        map.addGestureRecognizer(tap)
        return map
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject, MKMapViewDelegate {
        let parent: MapPickerView

        init(_ parent: MapPickerView) { self.parent = parent }

        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let map = gesture.view as? MKMapView else { return }
            let pt = gesture.location(in: map)
            let coord = map.convert(pt, toCoordinateFrom: map)
            map.removeAnnotations(map.annotations)
            let pin = MKPointAnnotation()
            pin.coordinate = coord
            map.addAnnotation(pin)
            parent.selectedCoordinate = coord
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let v = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            v.markerTintColor = UIColor(red: 0.85, green: 0.42, blue: 0.58, alpha: 1)
            return v
        }
    }
}
