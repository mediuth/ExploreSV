//
//  TouristMapView.swift
//  ExploreSV
//
//  Created by Wilson on 14/11/26.
//


import SwiftUI
import MapKit

struct TouristMapView: View {

    @ObservedObject var viewModel: MapViewModel
    @ObservedObject private var locationService: LocationService

    @State private var posicion: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 13.7942,
                longitude: -88.8965
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 2.5,
                longitudeDelta: 2.5
            )
        )
    )

    @State private var lugarSeleccionado: TouristPlace?
    @State private var mostrarOpcionesOrigen = false
    @State private var mostrarBuscadorOrigen = false

    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        self.locationService = viewModel.locationService
    }

    var body: some View {

        MapReader { proxy in

            ZStack(alignment: .top) {

                Map(position: $posicion) {

                    // Ubicación del dispositivo
                    UserAnnotation()

                    // Destinos turísticos
                    ForEach(viewModel.lugaresFiltrados) { lugar in
                        Annotation(
                            lugar.nombre,
                            coordinate: lugar.coordinate
                        ) {
                            Button {
                                lugarSeleccionado = lugar
                            } label: {
                                
                                Image(
                                    systemName: ExploreSVTheme.iconoCategoria(
                                        lugar.categoria
                                    )
                                )
                                .font(.system(size: 19, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(width: 44, height: 44)
                                .background(
                                    ExploreSVTheme.colorCategoria(
                                        lugar.categoria
                                    )
                                )
                                .clipShape(Circle())
                                .overlay {
                                    Circle()
                                        .stroke(.white, lineWidth: 3)
                                }
                                .shadow(
                                    color: .black.opacity(0.25),
                                    radius: 5,
                                    y: 3
                                )

                            }
                            .buttonStyle(.plain)
                        }
                    }

                    // Punto de partida manual
                    if viewModel.usarOrigenManual,
                       let origen = viewModel.origenManual {

                        Annotation(
                            "Mi punto de partida",
                            coordinate: origen
                        ) {
                            Image(systemName: "flag.circle.fill")
                                .font(.system(size: 36))
                                .foregroundStyle(.blue)
                                .background(
                                    Circle().fill(.white)
                                )
                        }
                    }

                    // Ruta calculada
                    if let ruta = viewModel.rutaActual {
                        MapPolyline(ruta.polyline)
                            .stroke(.blue, lineWidth: 6)
                    }
                }
                .mapStyle(.standard)
                .mapControls {
                    MapCompass()
                    MapScaleView()
                }
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.7)
                        .sequenced(
                            before: DragGesture(minimumDistance: 0)
                        )
                        .onEnded { valor in
                            if case .second(true, let arrastre) = valor,
                               let punto = arrastre?.location,
                               let coordenada = proxy.convert(
                                    punto,
                                    from: .local
                               ) {
                                viewModel.establecerOrigenManual(
                                    coordenada
                                )
                            }
                        }
                )

                VStack(spacing: 10) {

                    // Buscador
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)

                        TextField(
                            "Buscar destinos...",
                            text: $viewModel.busqueda
                        )
                        .autocorrectionDisabled()

                        if !viewModel.busqueda.isEmpty {
                            Button {
                                viewModel.busqueda = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                            }
                        }
                    }
                    .padding()
                    .background(.regularMaterial)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 14)
                    )

                    // Categorías
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(
                                viewModel.categorias,
                                id: \.self
                            ) { categoria in

                                Button {
                                    viewModel.categoriaSeleccionada =
                                        categoria
                                } label: {
                                    Text(categoria)
                                        .font(.subheadline)
                                        .padding(.horizontal, 15)
                                        .padding(.vertical, 10)
                                        .background(
                                            viewModel.categoriaSeleccionada
                                            == categoria
                                            ? Color.green
                                            : Color.white
                                        )
                                        .foregroundStyle(
                                            viewModel.categoriaSeleccionada
                                            == categoria
                                            ? Color.white
                                            : Color.black
                                        )
                                        .clipShape(Capsule())
                                }
                            }
                        }
                    }
                    
                


                    // Botones de ubicación
                    HStack {
                        Spacer()
                        
                        VStack(spacing: 12) {
                            
                            
                            Button {
                                mostrarBuscadorOrigen = true
                            } label: {
                                Image(systemName: "magnifyingglass.circle.fill")
                                    .font(.system(size: 25))
                                    .foregroundStyle(ExploreSVTheme.verde)
                                    .frame(width: 52, height: 52)
                                    .background(.regularMaterial)
                                    .clipShape(Circle())
                                    .shadow(
                                        color: .black.opacity(0.15),
                                        radius: 5,
                                        y: 3
                                    )
                            }
                            .accessibilityLabel("Buscar punto de partida")

                            
                            
                            Button {
                                viewModel.usarMiUbicacion()
                            } label: {
                                Image(systemName: "location.fill")
                                    .font(.system(size: 20))
                                /*Label(
                                    "Mi ubicación",
                                    systemImage: "location.fill"
                                )*/
                            }
                            .buttonStyle(.borderedProminent)
                            
                            Button {
                                mostrarOpcionesOrigen = true
                            } label: {
                                Image(systemName: "hand.point.up.left.fill")
                                    .font(.system(size: 20))
                                /*Label(
                                    "Origen manual",
                                    systemImage: "hand.tap"
                                )*/
                            }
                            .buttonStyle(.bordered)
                            
                            
                            Button {
                                withAnimation(.easeInOut(duration: 0.6)) {
                                    posicion = .region(
                                        MKCoordinateRegion(
                                            center: CLLocationCoordinate2D(
                                                latitude: 13.7942,
                                                longitude: -88.8965
                                            ),
                                            span: MKCoordinateSpan(
                                                latitudeDelta: 2.5,
                                                longitudeDelta: 2.5
                                            )
                                        )
                                    )
                                }
                            } label: {
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(ExploreSVTheme.verde)
                                    .frame(width: 48, height: 48)
                                    .background(.regularMaterial)
                                    .clipShape(Circle())
                                    .shadow(
                                        color: .black.opacity(0.15),
                                        radius: 5,
                                        y: 3
                                    )
                            }
                            .accessibilityLabel("Restablecer mapa")
                            
                        }

                    }
                    .font(.caption)

                    if viewModel.cargando {
                        ProgressView("Cargando destinos...")
                            .padding()
                            .background(.regularMaterial)
                    }

                    if viewModel.calculandoRuta {
                        ProgressView("Calculando ruta...")
                            .padding()
                            .background(.regularMaterial)
                    }

                    Spacer()

                    // Información de ruta
                    if viewModel.rutaActual != nil {

                        VStack(spacing: 10) {

                            Text(
                                viewModel.destinoRuta?.nombre
                                ?? "Destino"
                            )
                            .font(.headline)

                            HStack {
                                Label(
                                    viewModel.distanciaRuta,
                                    systemImage: "car.fill"
                                )

                                Spacer()

                                Label(
                                    viewModel.tiempoRuta,
                                    systemImage: "clock"
                                )
                            }

                            Button("Limpiar ruta") {
                                viewModel.limpiarRuta()
                            }
                            .buttonStyle(.bordered)
                        }
                        .padding()
                        .background(.regularMaterial)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 16)
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("ExploreSV")
            .navigationBarTitleDisplayMode(.inline)

            .onChange(of: viewModel.destinoRuta?.id) {
                if let ruta = viewModel.rutaActual {
                    
                    let rect = ruta.polyline.boundingMapRect

                    let margen = 0.25

                    let rectAmpliado = rect.insetBy(
                        dx: -rect.size.width * margen,
                        dy: -rect.size.height * margen
                    )

                    posicion = .rect(rectAmpliado)

                    /*posicion = .rect(
                        ruta.polyline.boundingMapRect
                    )*/
                }
            }
            
            
            .onChange(of: viewModel.origenManual?.latitude) {
                guard let origen = viewModel.origenManual else {
                    return
                }

                withAnimation(.easeInOut(duration: 0.6)) {
                    posicion = .region(
                        MKCoordinateRegion(
                            center: origen,
                            span: MKCoordinateSpan(
                                latitudeDelta: 0.015,
                                longitudeDelta: 0.015
                            )
                        )
                    )
                }
            }


            .sheet(item: $lugarSeleccionado) { lugar in
                PlaceDetailView(
                    lugar: lugar,
                    viewModel: viewModel
                )
                .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $mostrarBuscadorOrigen) {
                LocationSearchView(viewModel: viewModel)
            }

            .alert(
                "Seleccionar origen manual",
                isPresented: $mostrarOpcionesOrigen
            ) {
                Button("Entendido") {}
            } message: {
                Text(
                    "Mantené presionado un punto del mapa " +
                    "para establecer tu punto de partida."
                )
            }

            .alert(
                "Aviso de ruta",
                isPresented: Binding(
                    get: { viewModel.errorRuta != nil },
                    set: {
                        if !$0 {
                            viewModel.errorRuta = nil
                        }
                    }
                )
            ) {
                Button("Aceptar") {
                    viewModel.errorRuta = nil
                }
            } message: {
                Text(viewModel.errorRuta ?? "")
            }

            .alert(
                "Error al cargar destinos",
                isPresented: Binding(
                    get: { viewModel.error != nil },
                    set: {
                        if !$0 {
                            viewModel.error = nil
                        }
                    }
                )
            ) {
                Button("Aceptar") {
                    viewModel.error = nil
                }
            } message: {
                Text(viewModel.error ?? "")
            }
        }
    }
}



