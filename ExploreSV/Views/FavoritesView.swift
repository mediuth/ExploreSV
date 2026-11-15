//
//  FavoritesView.swift
//  ExploreSV
//
//  Created by Wilson on 15/11/26.
//


import SwiftUI

struct FavoritesView: View {

    @ObservedObject var viewModel: MapViewModel
    
    @Binding var pestañaSeleccionada: Int

    @State private var lugarSeleccionado: TouristPlace?

    var body: some View {

        NavigationStack {

            Group {

                if viewModel.lugaresFavoritos.isEmpty {

                    ContentUnavailableView(
                        "Todavía no hay favoritos",
                        systemImage: "heart",
                        description: Text(
                            "Explorá el mapa y guardá los destinos que más te gusten."
                        )
                    )

                } else {

                    ScrollView {

                        LazyVStack(spacing: 14) {

                            ForEach(viewModel.lugaresFavoritos) { lugar in

                                Button {
                                    lugarSeleccionado = lugar
                                } label: {

                                    HStack(spacing: 15) {

                                        Image(
                                            systemName:
                                                ExploreSVTheme.iconoCategoria(
                                                    lugar.categoria
                                                )
                                        )
                                        .font(.title2)
                                        .foregroundStyle(.white)
                                        .frame(
                                            width: 58,
                                            height: 58
                                        )
                                        .background(
                                            ExploreSVTheme.colorCategoria(
                                                lugar.categoria
                                            )
                                        )
                                        .clipShape(
                                            RoundedRectangle(
                                                cornerRadius: 14
                                            )
                                        )

                                        VStack(
                                            alignment: .leading,
                                            spacing: 6
                                        ) {

                                            Text(lugar.nombre)
                                                .font(.headline)
                                                .foregroundStyle(.primary)

                                            Text(lugar.departamento)
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)

                                            Text(lugar.categoria)
                                                .font(.caption)
                                                .foregroundStyle(
                                                    ExploreSVTheme.verde
                                                )
                                        }

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding()
                                    .background(
                                        Color.gray.opacity(0.08)
                                    )
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 18)
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Mis favoritos")
            .sheet(item: $lugarSeleccionado) { lugar in
                PlaceDetailView(
                    lugar: lugar,
                    viewModel: viewModel,
                    alSolicitarRuta: {
                        pestañaSeleccionada = 0
                    }
                )
            }
        }
    }
}


