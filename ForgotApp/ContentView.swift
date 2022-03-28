//
//  ContentView.swift
//  ForgotApp
//
//  Created by Eshaan Kunchur on 2022-02-23.
//

import SwiftUI
import MapKit
import ComposableArchitecture

//Equatable structs. Made to replicate Apple's already existent MK structs, but are equatable.
struct CoordinateRegion: Equatable {
    var center = LocationCoordinate2D()
    var span = CoordinateSpan()
}

extension CoordinateRegion {
    init(rawValue: MKCoordinateRegion) {
        self.init (
            center: .init(rawValue: rawValue.center),
            span: .init(rawValue: rawValue.span)
        )
    }

    var rawValue: MKCoordinateRegion {
        .init(center: self.center.rawValue, span: self.span.rawValue)
    }
}

struct LocationCoordinate2D: Equatable {
    var latitude: CLLocationDegrees = 0
    var longitude: CLLocationDegrees = 0
}

extension LocationCoordinate2D {
    init(rawValue: CLLocationCoordinate2D) {
        self.init(latitude: rawValue.latitude, longitude: rawValue.longitude)
    }
    
    var rawValue: CLLocationCoordinate2D {
        .init(latitude: self.latitude, longitude: self.longitude)
    }
}

struct CoordinateSpan: Equatable {
    var latitudeDelta: CLLocationDegrees = 0
    var longitudeDelta: CLLocationDegrees = 0
}

extension CoordinateSpan {
    init(rawValue: MKCoordinateSpan) {
        self.init(latitudeDelta: rawValue.latitudeDelta, longitudeDelta:rawValue.longitudeDelta)
    }
    
    var rawValue: MKCoordinateSpan {
        .init(latitudeDelta: self.latitudeDelta, longitudeDelta: self.longitudeDelta)
    }
}

//State variables
struct AppState: Equatable {
    var completions: [MKLocalSearchCompletion] = []
    var mapItems: [MKMapItem] = []
    var query = ""
    var region = CoordinateRegion (center: .init(latitude: 40.7, longitude: -74), span: .init(latitudeDelta: 0.075, longitudeDelta: 0.075))
    var locationSelected = false
}

//Actions
enum AppAction {
    case completionsUpdated(Result<[MKLocalSearchCompletion], Error>)
    case onAppear
    case queryChanged(String)
    case regionChanged(CoordinateRegion)
    case mapItemsChanged([MKMapItem])
    case tappedCompletion(MKLocalSearchCompletion)
    case tappedPlaceMark(MKMapItem)
    case searchResponse(Result<MKLocalSearch.Response, Error>)
            
}
       
//Environment Dependencies
struct AppEnvironment {
    var localSearch: LocalSearchClient
    var localSearchCompleter: LocalSearchCompleter
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

//App Reducer used for state management
let appReducer = Reducer<AppState, AppAction, AppEnvironment> {
    state, action, environment
    in switch action {
        
    case .mapItemsChanged(let mapItems):
        state.mapItems = mapItems
        return .none

    case let .completionsUpdated(.success(completions)):
        state.completions = completions
        return .none
        
    case let .completionsUpdated(.failure(error)):
        return .none
        
    case .onAppear:
        return environment.localSearchCompleter.completions()
        .map(AppAction.completionsUpdated)
        
    case let .queryChanged(query):
        state.query = query
        return environment.localSearchCompleter.search(query)
            .fireAndForget()
        
    case let .regionChanged(region):
        state.region = region
        return .none
        
    case let .searchResponse(.success(response)):
        state.mapItems = response.mapItems
        state.region = .init(rawValue: response.boundingRegion)
        return .none
        
    case let .searchResponse(.failure(error)):
        return .none
        
    case let .tappedCompletion(completion):
        return environment.localSearch.search(completion)
            .receive(on: environment.mainQueue.animation())
            .catchToEffect()
            .map(AppAction.searchResponse)
        
    case let .tappedPlaceMark(mapItem):
        state.mapItems = [mapItem]
        return .none
    }
}

//Extend MKLocalSearchCimpletion to give a unique ID to each location object
extension MKLocalSearchCompletion {
    var id: [String] { [self.title, self.subtitle]}
}

//Make MKMapItem Identifiable
extension MKMapItem: Identifiable {}



struct ContentView: View {
    let store: Store<AppState, AppAction>
    @State private var sheetMode: SheetMode = .none
    @State private var currentMapItemFromPlaceMark: MKMapItem?
    
    func changeModalVisibility(none: String, quarter: String) {
        switch sheetMode {
            case .none:
                if (none == "none") {
                    sheetMode = .none
                }
                else {
                    sheetMode = .quarter
                }
            case .quarter:
                if (quarter == "none") {
                    sheetMode = .none
                }
                else {
                    sheetMode = .quarter
                }
        }
    }

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                ZStack {
                    Map(
                        coordinateRegion: viewStore.binding(get: \.region.rawValue, send: { .regionChanged(.init(rawValue: $0))}),
                        annotationItems: viewStore.mapItems,
                        annotationContent: { mapItem in
                            MapAnnotation(coordinate:  mapItem.placemark.coordinate) {
                                Button(action: {
                                    viewStore.send(.tappedPlaceMark(mapItem))
                                    currentMapItemFromPlaceMark = mapItem
                                    changeModalVisibility(none: "quarter", quarter: "quarter")
                                }){
                                    Image(systemName: "mappin.circle.fill")
                                        .resizable()
                                        .foregroundColor(.red)
                                        .frame(width: 44, height: 44)
                                        .background(.white)
                                        .clipShape(Circle())
                                }.onAppear {
                                    currentMapItemFromPlaceMark = mapItem
                                }
                            }
                        }
                    )
                    FlexibleSheet(sheetMode: $sheetMode) {
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    changeModalVisibility(none: "quarter", quarter: "none")
                                }) {
                                    Image(systemName: "x.circle")
                                        .foregroundColor(.white)
                                        .padding(15)
                                }
                            }
                            
                            Text(currentMapItemFromPlaceMark?.name ?? "Could not find location")
                                    .foregroundColor(.white)
                            
                            if ((currentMapItemFromPlaceMark) != nil) {
                                NavigationLink(destination: ItemsView(currentMapItem: currentMapItemFromPlaceMark!)) {
                                    Text("Go")
                                }
                                .padding()
                                .background(Color(red: 0, green: 0, blue: 0.5))
                                .clipShape(Capsule())
                            }
                        
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .background(Color(red: 0.4, green: 0.7, blue: 0.8))
                        .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                    }
                }
                .navigationTitle("Places")
                .ignoresSafeArea(edges: .bottom)
                .onAppear {
                    changeModalVisibility(none: "none", quarter: "none")
                    viewStore.send(.onAppear)
                }
                
            }
            .preferredColorScheme(.dark)
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: viewStore.binding(get: \.query, send: AppAction.queryChanged)) {
                
                ForEach(viewStore.completions, id: \.id) { completion in
                    let index = viewStore.completions.firstIndex(of: completion)!
                    Button(action: {
                        viewStore.send(.tappedCompletion(completion))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if (!viewStore.mapItems.isEmpty) {
                                currentMapItemFromPlaceMark = viewStore.mapItems[0]
                            }
                            
                            //Only show sheet if one result is chosen
                            if (viewStore.mapItems.count == 1) {
                                changeModalVisibility(none: "quarter", quarter: "quarter")
                            }
                                
                            //If multiple results are chosen, do not show sheet
                            else {
                                changeModalVisibility(none: "none", quarter: "none")
                            }
                        }
                    }) {
                        VStack(alignment: .leading) {
                            Text(completion.title)
                            Text(String(describing: index))
                            Text(completion.subtitle)
                            .font(.caption)
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView(
                store: .init (
                    initialState: .init(),
                    reducer: appReducer,
                    environment: .init(
                        localSearch: .live,
                        localSearchCompleter: .live,
                        mainQueue: .main
                    )
                )
            )
        }
    }
}


//Rounded corner extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
