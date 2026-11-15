//
//  LocationSearchService.swift
//  ExploreSV
//
//  Created by Wilson on 15/11/26.
//


import Foundation
import MapKit
import Combine

struct SearchLocation: Identifiable {
    let id = UUID()
    let nombre: String
    let direccion: String
    let coordenada: CLLocationCoordinate2D
}

@MainActor
final class LocationSearchService: ObservableObject {

    @Published var resultados: [SearchLocation] = []
    @Published var buscando = false
    @Published var mensajeError: String?

    func buscar(_ texto: String) async {

        guard !texto.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty else {
            resultados = []
            return
        }

        buscando = true
        mensajeError = nil

        defer {
            buscando = false
        }

        let solicitud = MKLocalSearch.Request()
        solicitud.naturalLanguageQuery = texto

        // Región aproximada de El Salvador
        solicitud.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 13.7942,
                longitude: -88.8965
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 2.5,
                longitudeDelta: 2.5
            )
        )

        // Limitar la búsqueda a la región indicada
        solicitud.regionPriority = .required

        do {
            let respuesta = try await MKLocalSearch(
                request: solicitud
            ).start()

            resultados = respuesta.mapItems.map { item in
                SearchLocation(
                    nombre: item.name ?? "Ubicación",
                    direccion: item.address?.fullAddress
                        ?? "El Salvador",
                    coordenada: item.location.coordinate
                )
            }

        } catch {
            resultados = []
            mensajeError = "No se pudo completar la búsqueda."
        }
    }
}

