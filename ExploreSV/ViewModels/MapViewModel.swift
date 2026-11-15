//
//  MapViewModel.swift
//  ExploreSV
//
//  Created by Wilson on 14/11/26.
//


import Foundation
import Combine
import MapKit

@MainActor
final class MapViewModel: ObservableObject {

    // MARK: - Firebase

    @Published var lugares: [TouristPlace] = []
    @Published var cargando = false
    @Published var error: String?

    private let firebaseService = FirebaseService()

    // MARK: - Búsqueda y categorías

    @Published var busqueda = ""
    @Published var categoriaSeleccionada = "Todas"

    let categorias = [
        "Todas", "Naturaleza",
        "Aventura", "Playa", "Cultura"
    ]

    var lugaresFiltrados: [TouristPlace] {
        lugares.filter { lugar in
            let coincideBusqueda =
                busqueda.isEmpty ||
                lugar.nombre.localizedCaseInsensitiveContains(busqueda)

            let coincideCategoria =
                categoriaSeleccionada == "Todas" ||
                lugar.categoria == categoriaSeleccionada

            return coincideBusqueda && coincideCategoria
        }
    }

    // MARK: - Favoritos

    @Published var favoritos: Set<String> = []

    private let favoritosKey = "exploresv_favoritos"

    var lugaresFavoritos: [TouristPlace] {
        lugares.filter { favoritos.contains($0.id) }
    }

    func esFavorito(_ lugar: TouristPlace) -> Bool {
        favoritos.contains(lugar.id)
    }

    func alternarFavorito(_ lugar: TouristPlace) {
        if favoritos.contains(lugar.id) {
            favoritos.remove(lugar.id)
        } else {
            favoritos.insert(lugar.id)
        }

        UserDefaults.standard.set(
            Array(favoritos),
            forKey: favoritosKey
        )
    }

    // MARK: - Ubicación

    let locationService = LocationService()

    @Published var origenManual: CLLocationCoordinate2D?
    @Published var usarOrigenManual = false

    var coordenadaOrigen: CLLocationCoordinate2D? {
        if usarOrigenManual {
            return origenManual
        }

        return locationService.ubicacionActual
    }

    func establecerOrigenManual(
        _ coordenada: CLLocationCoordinate2D
    ) {
        origenManual = coordenada
        usarOrigenManual = true
        limpiarRuta()
    }

    func usarMiUbicacion() {
        usarOrigenManual = false
        limpiarRuta()
        locationService.solicitarUbicacion()
    }

    // MARK: - Rutas

    @Published var rutaActual: MKRoute?
    @Published var destinoRuta: TouristPlace?
    @Published var calculandoRuta = false
    @Published var errorRuta: String?

    private let routeService = RouteService()

    func calcularRuta(hacia lugar: TouristPlace) async {

        guard let origen = coordenadaOrigen else {
            errorRuta = "Primero seleccioná un punto de partida."
            return
        }

        calculandoRuta = true
        errorRuta = nil
        limpiarRuta()
        calculandoRuta = true

        do {
            let ruta = try await routeService.calcularRuta(
                desde: origen,
                hasta: lugar.coordinate
            )

            rutaActual = ruta
            destinoRuta = lugar

        } catch {
            errorRuta = "No se pudo calcular la ruta: \(error.localizedDescription)"
        }

        calculandoRuta = false
    }

    func limpiarRuta() {
        rutaActual = nil
        destinoRuta = nil
        errorRuta = nil
    }

    var distanciaRuta: String {
        guard let rutaActual else { return "" }

        return String(
            format: "%.1f km",
            rutaActual.distance / 1000
        )
    }

    var tiempoRuta: String {
        guard let rutaActual else { return "" }

        let minutos = Int(rutaActual.expectedTravelTime / 60)

        if minutos >= 60 {
            return "\(minutos / 60) h \(minutos % 60) min"
        }

        return "\(minutos) min"
    }

    // MARK: - Inicialización

    init() {
        let ids = UserDefaults.standard.stringArray(
            forKey: favoritosKey
        ) ?? []

        favoritos = Set(ids)
    }

    // MARK: - Cargar destinos

    func cargarLugares() async {
        cargando = true
        error = nil

        defer {
            cargando = false
        }

        do {
            lugares = try await firebaseService.obtenerLugares()
        } catch {
            self.error = error.localizedDescription
        }
    }
}



