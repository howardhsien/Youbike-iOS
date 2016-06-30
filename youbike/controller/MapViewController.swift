//
//  MapViewController.swift
//  week_3_part_7

//
//  Created by howard hsien on 2016/4/27.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
   
//    @IBOutlet weak var mapViewTopContraint: NSLayoutConstraint!
//    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var mapModeBarView: UIView!
    @IBOutlet weak var mapModeBar: UISegmentedControl!

    var station: YoubikeStation!
    //MARK: create cell to display cell info above the map
    let cell = UINib(nibName: "cell", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! YoubikeTableViewCell
    private var withCell = false;
    
    //MARK: create current location manager
    let locMgr = CLLocationManager()


    override func viewDidLoad() {
        
        super.viewDidLoad()
        tabBarController?.tabBar.hidden = true
        
        setUpMapview()
        setUpNavbar()
        setUpLocationMgr()
        setMapModeBar()
        //if press on "cell" show cell info on top, else if press "viewmap button" show full map
        if(withCell){
            setCellView()
            setMapConstraint()
        }
    }
    func setUpNavbar() {
        //set navbar style and title
        self.navigationController?.navigationBar.tintColor = UIColor.ybkPaleGoldColor()
        if let station = station{
            self.title = station.youbikeLocation
        }
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
    
    func setMapModeBar() {
        mapModeBarView.backgroundColor = UIColor.ybkCharcoalGreyColor()
        mapModeBar.tintColor = UIColor.ybkPaleGoldColor()
        mapModeBar.addTarget(self, action: "changeMapMode:", forControlEvents: .ValueChanged)
        
    }
    func changeMapMode(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = .Standard
        case 1:
            mapView.mapType = .Satellite
        case 2:
            mapView.mapType = .Hybrid
        default:
            break
        }
    }
    
    
    func setCellView(){
//        cellView.addSubview(cell)
//        cell.frame = CGRectMake(0,0,view.frame.width,cellView.frame.height)
    }
    
    func setMapConstraint() {
        // the following comment is the alternative way to set the mapview just below the cellView
        //        mapViewTopContraint.constant = 122
//        self.view.removeConstraint(mapViewTopContraint)
//        let newMapViewTopContraint = NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: cellView, attribute:NSLayoutAttribute.Bottom , multiplier: 1, constant: 0)
//        newMapViewTopContraint.active = true
//        view.addConstraint(newMapViewTopContraint)

    }
    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        guard mapView.userLocation.coordinate.latitude != 0 else{return}
        addRoutesOverLayForMapView()
        mapView.showAnnotations(mapView.annotations, animated: true)

//        print("did add annotation")

    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
 //       print("didUpdateLocations")
  
    }

    func mapView(mapView: MKMapView, didFailToLocateUserWithError error: NSError) {
        
//        print(error.localizedDescription)
        
    }
    
    func setCellExist(withCell: Bool){
        self.withCell = withCell
    }
    
    //set up mapUI from station info
    func setVariable(station: YoubikeStation){
        self.station = station
        self.cell.station = station
    }
    
    // handle the cell frame when rotate
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.cell.frame = CGRectMake(0, 0,  size.width, 122.0)
        print("rotate cell width:\(size.width)")
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
