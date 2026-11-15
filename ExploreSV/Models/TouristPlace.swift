//
//  TouristPlace.swift
//  ExploreSV
//
//  Created by Wilson on 14/11/26.
//


import Foundation
import CoreLocation

struct TouristPlace: Identifiable {
    let id: String
    let nombre: String
    let departamento: String
    let categoria: String
    let descripcion: String
    let latitud: Double
    let longitud: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: latitud,
            longitude: longitud
        )
    }
}
