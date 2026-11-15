//
//  LocationSearchView.swift
//  ExploreSV
//
//  Created by Wilson on 15/11/26.
//


import SwiftUI
import MapKit

struct LocationSearchView: View {

    @ObservedObject var viewModel: MapViewModel

    @StateObject private var buscador = LocationSearchService()
    @State private var textoBusqueda = ""

    @Environment(\.dismiss) private var dismiss

    var body: some View {

        NavigationStack {

            VStack(spacing: 0) {

                HStack {

                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)

                    TextField(
                        "Buscar ciudad, dirección o lugar",
                        text: $textoBusqueda
                    )
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                    .submitLabel(.search)
                    .onSubmit {
                        Task {
                            await buscador.buscar(textoBusqueda)
                        }
                    }

                    if !textoBusqueda.isEmpty {
                        Button {
                            textoBusqueda = ""
                            buscador.resultados = []
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(
                    RoundedRectangle(cornerRadius: 14)
                )
                .padding()

                if buscador.buscando {

                    ProgressView("Buscando lugares...")
                        .padding()

                } else if let error = buscador.mensajeError {

                    ContentUnavailableView(
                        "Error de búsqueda",
                        systemImage: "wifi.exclamationmark",
                        description: Text(error)
                    )

                } else if buscador.resultados.isEmpty {

                    ContentUnavailableView(
                        "Buscar ubicación",
                        systemImage: "map",
                        description: Text(
                            "Escribí un lugar de El Salvador y presioná Buscar."
                        )
                    )

                } else {

                    List(buscador.resultados) { lugar in

                        Button {

                            viewModel.establecerOrigenManual(
                                lugar.coordenada
                            )

                            dismiss()

                        } label: {

                            HStack(spacing: 12) {

                                Image(systemName: "mappin.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(
                                        ExploreSVTheme.verde
                                    )

                                VStack(
                                    alignment: .leading,
                                    spacing: 5
                                ) {

                                    Text(lugar.nombre)
                                        .font(.headline)
                                        .foregroundStyle(.primary)

                                    Text(lugar.direccion)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Elegir punto de partida")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .topBarTrailing) {

                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

