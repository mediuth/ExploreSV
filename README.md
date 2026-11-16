# ExploreSV

**Aplicación iOS para explorar destinos turísticos de El Salvador**

ExploreSV es una aplicación móvil desarrollada con SwiftUI que permite descubrir lugares turísticos de El Salvador mediante un mapa interactivo, consultar información de los destinos y calcular rutas desde diferentes puntos de partida.

El proyecto utiliza **MapKit** para las funcionalidades geográficas y **Firebase Cloud Firestore** para almacenar y consultar información turística.

## Objetivo general

Desarrollar una aplicación móvil para iOS que facilite la exploración de destinos turísticos de El Salvador, integrando herramientas de visualización geográfica, almacenamiento de datos en la nube y cálculo de rutas.

## Funcionalidades principales

- **Mapa interactivo:** visualización de El Salvador mediante Apple Maps y MapKit.
- **Destinos turísticos:** inicialmente ocho lugares registrados con nombre, departamento, categoría, descripción y coordenadas geográficas.
- **Marcadores visuales:** identificación visual de los destinos según su categoría.
- **Búsqueda de destinos:** localización de lugares turísticos registrados en la aplicación.
- **Filtros por categoría:** clasificación de destinos de naturaleza, aventura, playa y cultura.
- **Información detallada:** consulta de los datos de cada destino turístico.
- **Favoritos:** posibilidad de guardar y eliminar destinos favoritos.
- **Persistencia local:** conservación de favoritos mediante UserDefaults.
- **Ubicación actual:** identificación de la posición del usuario mediante Core Location.
- **Origen manual:** selección de un punto de partida directamente sobre el mapa.
- **Búsqueda de ubicaciones:** búsqueda de ciudades, direcciones y establecimientos mediante Apple Maps.
- **Cálculo de rutas:** generación de recorridos hacia los destinos turísticos.
- **Información del recorrido:** visualización de distancia y tiempo estimado.
- **Controles del mapa:** navegación, acercamiento y restablecimiento de la vista general.

## Tecnologías utilizadas

| Tecnología | Función |
|---|---|
| Swift | Lenguaje de programación |
| SwiftUI | Desarrollo de la interfaz de usuario |
| MapKit | Visualización de mapas, búsqueda geográfica y cálculo de rutas |
| Core Location | Obtención de la ubicación del usuario |
| Firebase Cloud Firestore | Almacenamiento de información turística |
| UserDefaults | Persistencia local de favoritos |
| Xcode | Entorno de desarrollo |
| Git y GitHub | Control de versiones y alojamiento del código fuente |

## Arquitectura del proyecto

ExploreSV utiliza una organización basada en el patrón **MVVM (Model-View-ViewModel)**, que permite separar la presentación de la información, la lógica de la aplicación y el acceso a los datos.

### Models

Contiene la estructura que representa los datos de los destinos turísticos.

- `TouristPlace.swift`: modelo de información de cada lugar.

### Views

Contiene las pantallas y los componentes visuales de la aplicación.

- `TouristMapView.swift`: mapa interactivo y controles principales.
- `PlaceDetailView.swift`: información detallada de cada destino.
- `FavoritesView.swift`: destinos guardados como favoritos.
- `LocationSearchView.swift`: búsqueda de ubicaciones para establecer el punto de partida.
- `ExploreSVTheme.swift`: colores e iconos de la interfaz.

### ViewModels

- `MapViewModel.swift`: administra destinos, filtros, favoritos, ubicación de origen y rutas.

### Services

- `FirebaseService.swift`: consulta de información almacenada en Firestore.
- `LocationService.swift`: gestión de la ubicación del usuario.
- `RouteService.swift`: cálculo de rutas mediante MapKit.
- `LocationSearchService.swift`: búsqueda de lugares mediante Apple Maps.

## Base de datos

La aplicación utiliza **Firebase Cloud Firestore**, una base de datos NoSQL alojada en la nube.

La colección principal se denomina `lugares`.

Cada documento contiene los siguientes campos:

| Campo | Tipo | Descripción |
|---|---|---|
| `nombre` | String | Nombre del destino turístico |
| `departamento` | String | Departamento de El Salvador |
| `categoria` | String | Clasificación turística |
| `descripcion` | String | Información del destino |
| `latitud` | Number | Coordenada geográfica |
| `longitud` | Number | Coordenada geográfica |

La aplicación consulta estos documentos para generar dinámicamente los marcadores del mapa.

## Destinos turísticos incluidos

1. Lago de Coatepeque.
2. Volcán de Santa Ana.
3. Parque Nacional El Boquerón.
4. Playa El Tunco.
5. Suchitoto.
6. Parque Nacional El Imposible.
7. Joya de Cerén.
8. Costa del Sol.

## Funcionamiento de las rutas

ExploreSV permite establecer el origen de un recorrido de tres maneras:

1. Utilizando la ubicación actual del dispositivo.
2. Buscando una ubicación mediante Apple Maps.
3. Seleccionando manualmente un punto del mapa.

Después de seleccionar un destino turístico y presionar **Cómo llegar**, la aplicación solicita a MapKit una ruta disponible.

El recorrido se representa gráficamente en el mapa, acompañado de la distancia y el tiempo estimado de llegada.

La disponibilidad de rutas depende de la información geográfica proporcionada por Apple Maps.

## Requisitos

- Una Mac compatible con Xcode.
- Xcode con soporte para el SDK de iOS utilizado por el proyecto.
- Un simulador de iPhone o un dispositivo iOS compatible.
- Conexión a internet para consultar Firestore y los servicios de mapas.
- Configuración válida de Firebase para ejecutar el proyecto.

## Ejecución del proyecto

1. Clonar o descargar el repositorio.
2. Abrir `ExploreSV.xcodeproj` en Xcode.
3. Esperar a que Xcode resuelva las dependencias de Firebase.
4. Verificar que el proyecto tenga configurado el archivo `GoogleService-Info.plist` correspondiente.
5. Seleccionar un simulador de iPhone compatible.
6. Compilar y ejecutar la aplicación.
7. Conceder permiso de ubicación cuando sea necesario.

**Nota:** para utilizar otra instancia de Firebase, es necesario registrar la aplicación en el proyecto correspondiente, configurar Firestore y proporcionar los datos turísticos con la estructura indicada.

## Limitaciones

- La aplicación presenta inicialmente ocho destinos turísticos registrados.
- La búsqueda de ubicaciones depende de la cobertura de Apple Maps.
- El cálculo de rutas depende de la disponibilidad de recorridos en MapKit.
- La aplicación no cuenta con un servicio de navegación GPS en tiempo real.
- Algunas funciones requieren conexión a internet.
- El proyecto está orientado a fines académicos y demostrativos.

## Propósito académico

ExploreSV fue desarrollado como proyecto académico para demostrar la integración de herramientas de programación iOS, servicios geográficos y almacenamiento de datos en la nube.

El proyecto permite aplicar conceptos de desarrollo móvil, arquitectura de software, consultas a bases de datos, interfaces interactivas y persistencia de información.

## Estado del proyecto

**Versión académica funcional.**

Las principales funcionalidades han sido implementadas y probadas en el simulador de iOS.

## Aviso de seguridad y limitación de responsabilidad

**ExploreSV es una aplicación desarrollada con fines académicos, educativos e informativos.** Su propósito principal es facilitar la exploración de destinos turísticos de El Salvador y demostrar la integración de tecnologías de geolocalización y almacenamiento de datos.

ExploreSV **no está diseñada para funcionar como un sistema de navegación GPS en tiempo real**, ni pretende sustituir aplicaciones especializadas de navegación o las indicaciones oficiales de tránsito.

Las rutas, distancias, tiempos estimados y ubicaciones mostradas son proporcionadas por servicios externos, como Apple Maps, y pueden presentar imprecisiones, información desactualizada o variaciones respecto a las condiciones reales.

**Se recomienda a los usuarios:**

- Verificar las condiciones de las carreteras antes de iniciar un recorrido.
- Respetar las leyes de tránsito y la señalización vial.
- No manipular la aplicación mientras conducen.
- Utilizar herramientas de navegación especializadas cuando necesiten indicaciones en tiempo real.

Los desarrolladores de ExploreSV no garantizan la exactitud, disponibilidad o seguridad de las rutas proporcionadas. En la medida permitida por la legislación aplicable, no asumen responsabilidad por daños, pérdidas o incidentes derivados del uso de la información presentada por la aplicación.

**La seguridad durante cualquier desplazamiento es responsabilidad de cada usuario.**

---

**ExploreSV: descubrí El Salvador, un destino a la vez.**
