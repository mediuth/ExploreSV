//
//  FirebaseService.swift
//  ExploreSV
//
//  Created by Wilson on 14/11/26.
//


import Foundation
import FirebaseFirestore

struct FirebaseService {

    private let db = Firestore.firestore()

    func obtenerLugares() async throws -> [TouristPlace] {

        let snapshot = try await db
            .collection("lugares")
            .getDocuments()

        return snapshot.documents.compactMap { document in

            let data = document.data()

            guard
                let nombre = data["nombre"] as? String,
                let departamento = data["departamento"] as? String,
                let categoria = data["categoria"] as? String,
                let descripcion = data["descripcion"] as? String,
                let latitud = data["latitud"] as? Double,
                let longitud = data["longitud"] as? Double
            else {
                return nil
            }

            return TouristPlace(
                id: document.documentID,
                nombre: nombre,
                departamento: departamento,
                categoria: categoria,
                descripcion: descripcion,
                latitud: latitud,
                longitud: longitud
            )
        }
    }
}

