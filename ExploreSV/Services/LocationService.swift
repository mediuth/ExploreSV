//
//  LocationService.swift
//  ExploreSV
//
//  Created by Wilson on 15/11/26.
//


import Foundation
import CoreLocation
import Combine

@MainActor
final class LocationService: NSObject, ObservableObject,
                             CLLocationManagerDelegate {

    @Published var ubicacionActual: CLLocationCoordinate2D?
    @Published var permiso: CLAuthorizationStatus = .notDetermined
    @Published var mensajeError: String?

    private let manager = CLLocationManager()

    override init() {
        super.init()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest

        permiso = manager.authorizationStatus
    }

    func solicitarUbicacion() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()

        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()

        case .denied, .restricted:
            mensajeError = "Activá el permiso de ubicación en Configuración."

        @unknown default:
            break
        }
    }

    nonisolated func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        let estado = manager.authorizationStatus

        Task { @MainActor in
            permiso = estado

            if estado == .authorizedWhenInUse ||
               estado == .authorizedAlways {
                manager.startUpdatingLocation()
            }
        }
    }

    nonisolated func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else { return }

        let coordinate = location.coordinate

        Task { @MainActor in
            ubicacionActual = coordinate
        }
    }

    nonisolated func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        let descripcion = error.localizedDescription

        Task { @MainActor in
            mensajeError = descripcion
        }
    }
}

