import SwiftUI
import CoreData
import CoreLocation
import MapKit

//*****************************************************//
//***************** IMPLEMENT MAPVIEW *****************//
//*****************************************************//

struct Location: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    
    @State private var searchText = ""
    @Environment(\.presentationMode) var presentationMode

    private var searchBar: some View {
        HStack {
            Button {
                let searchRequest = MKLocalSearch.Request()
                searchRequest.naturalLanguageQuery = searchText
                searchRequest.region = region
                
                MKLocalSearch(request: searchRequest).start { response, error in
                    guard let response = response else {
                        print("Error: \(error?.localizedDescription ?? "Unknown error").")
                        return
                    }
                    region = response.boundingRegion
                    markers = response.mapItems.map { item in
                        print(item.name ?? "No name")
                        return Location(
                            name: item.name ?? "",
                            coordinate: item.placemark.coordinate
                        )
                    }
                }
                
            } label: {
                Image(systemName: "location.magnifyingglass")
                    .resizable()
                    .foregroundColor(.accentColor)
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 12)
            }
            TextField("Find market nearest to you?", text: $searchText)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.white)
        }
        .padding()
    }

    @Environment(\.dismiss) private var dismiss
    let city: String
    
    @State private var isButtonActive = false
    
    @State private static var defaultLocation = CLLocationCoordinate2D(
        latitude: 33.4255,
        longitude: -111.9400
    )
    // state property that represents the current map region
    @State private var region = MKCoordinateRegion(
        center: defaultLocation,
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    // state property that stores marker locations in current map region
    @State private var markers = [
        Location(name: "Tempe", coordinate: defaultLocation)
    ]
    
    var body: some View {
        VStack {
            HStack {
                Button("<< Back", action: {
                    self.presentationMode.wrappedValue.dismiss()
                })
                .padding(10)
                Spacer()
            }
            Text("You are living in \(city)?")
            
            Map(coordinateRegion: $region,
                interactionModes: .all,
                annotationItems: markers
            ){ location in
                MapMarker(coordinate: location.coordinate)
            }
        }
        .onAppear {
            forwardGeocoding(addressStr: city)
            isButtonActive = true
        }
        searchBar
    }
    
    func forwardGeocoding(addressStr: String)
    {
        let geoCoder = CLGeocoder();
        let addressString = addressStr
        CLGeocoder().geocodeAddressString(addressString, completionHandler:
                                            {(placemarks, error) in
            
            if error != nil {
                print("Geocode failed: \(error!.localizedDescription)")
            } else if placemarks!.count > 0 {
                let placemark = placemarks![0]
                let location = placemark.location
                let coords = location!.coordinate
                
                DispatchQueue.main.async
                {
                    region.center = coords
                    markers[0].name = placemark.locality!
                    markers[0].coordinate = coords
                    markers[0].coordinate.longitude = coords.longitude
                    markers[0].coordinate.latitude = coords.latitude
                }
            }
        })
    }
}

