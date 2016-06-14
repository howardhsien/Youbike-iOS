//
//  MapCell.swift
//  youbike
//
//  Created by howard hsien on 2016/5/22.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import MapKit

class MapCell: UITableViewCell,MKMapViewDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    var station:YoubikeStation? = nil
    var locMgr = CLLocationManager()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("mapview layout subviews")
   //     setUpMapview()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib")
    }
    
    func setUpMapview(){
        //set up center location to display on map
        if let station = station{
            let location = CLLocationCoordinate2D(latitude: station.stationLatitude, longitude: station.stationLongitude)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
            
            //set up annotation(pin point)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = station.youbikeLocation
            annotation.subtitle = station.youbikeAreas
            mapView.addAnnotation(annotation)
            mapView.showsUserLocation = true
            mapView.delegate = self
        }
        else{
            print("ERROR: no location loaded")
        }
    }
    
    func setUpLocationMgr() {
        //set up location manager
        locMgr.desiredAccuracy = kCLLocationAccuracyBest
        locMgr.requestWhenInUseAuthorization()
        locMgr.startUpdatingLocation()
        locMgr.delegate = self
    }
    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        guard mapView.userLocation.coordinate.latitude != 0 else{return}
        addRoutesOverLayForMapView()
        mapView.showAnnotations(mapView.annotations, animated: true)
        
        //        print("did add annotation")
        
    }
    
    
    //add route
    func addRoutesOverLayForMapView(){
        
        var source:MKMapItem?
        var destination:MKMapItem?
        if let station = station{
            let Scoordinate = CLLocationCoordinate2D(latitude: station
                .stationLatitude, longitude: station.stationLongitude)
            
            let sourcePlacemark = MKPlacemark(coordinate: Scoordinate, addressDictionary: nil)
            
            source = MKMapItem(placemark: sourcePlacemark)
        }
        let DCoordinate = mapView.userLocation.coordinate
        let desitnationPlacemark = MKPlacemark(coordinate: DCoordinate, addressDictionary: nil)
        destination = MKMapItem(placemark: desitnationPlacemark)
        let request:MKDirectionsRequest = MKDirectionsRequest()
        request.source = source
        request.destination = destination
        request.transportType = MKDirectionsTransportType.Walking
        
        let directions = MKDirections(request: request)
        directions.calculateDirectionsWithCompletionHandler ({
            (response: MKDirectionsResponse?, error: NSError?) in
            
            if error == nil {
                
                self.showRoute(response!)
            }
            else{
                
                print(error)
                
            }
        })
    }
    
    func showRoute(response:MKDirectionsResponse){
        for route in response.routes {
            mapView.addOverlay(route.polyline, level: MKOverlayLevel.AboveRoads)
        }
    }
    
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        
        if overlay is MKPolyline {
            
            polylineRenderer.strokeColor = UIColor.ybkBarneyColor()
            polylineRenderer.lineWidth = 10
            return polylineRenderer
        }
        return polylineRenderer
        
    }
    
    
    
}
