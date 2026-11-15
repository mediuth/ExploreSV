//
//  RouteService.swift
//  ExploreSV
//
//  Created by Wilson on 15/11/26.
//


import Foundation
import MapKit

struct RouteService {

    func calcularRuta(
        desde origen: CLLocationCoordinate2D,
        hasta destino: CLLocationCoordinate2D
    ) async throws -> MKRoute {

        let solicitud = MKDirections.Request()

        solicitud.source = MKMapItem(
            location: CLLocation(
                latitude: origen.latitude,
                longitude: origen.longitude
            ),
            address: nil
        )

        solicitud.destination = MKMapItem(
            location: CLLocation(
                latitude: destino.latitude,
                longitude: destino.longitude
            ),
            address: nil
        )

        solicitud.transportType = .automobile

        let directions = MKDirections(request: solicitud)

        let respuesta = try await directions.calculate()

        guard let ruta = respuesta.routes.first else {
            throw NSError(
                domain: "ExploreSV",
                code: 1,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "No se encontró una ruta disponible."
                ]
            )
        }

        return ruta
    }
}

