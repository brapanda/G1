//
//  examLocation.swift
//  G1
//
//  Created by Shawn on 2015-08-21.
//  Copyright (c) 2015 Shawn. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class examLocation: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate{
    var map_view : MKMapView!
    let locationManager = CLLocationManager()
    let screenSize : CGRect = UIScreen.mainScreen().bounds
    var infoView : UIView!
    var cancelInfo: UIButton!
    var centerPhoto: UIImageView!
    var infoTextView : UITextView!
    var examCenterList = ["Toronto Downsview":["星期一到星期五 早上8:30 到 下午5:00",43.7469489,-79.4784558,"星期一到星期五 早上8:30 到 下午5:00\n\n地址:\n37 Carl Hall Road\nToronto, ON M3K 2B6\n\n电话:\nTel : 416-398-3577","Downsview.jpg"],"Toronto Etobicoke":["星期一到星期六 早上8:30 到 下午5:00",43.6506493,-79.6028462,"星期一到星期六 早上8:30 到 下午5:00\n\n地址:\n5555 Eglinton Ave. W.\nEtobicoke, ON M9C 5M1\n\n电话:\n416-695-0621","Etobicoke.jpg"],"Toronto Metro East":["星期一到星期五 早上8:30 到 下午5:00",43.7420021,-79.3145487,"星期一到星期五 早上8:30 到 下午5:00\n\n地址:\nVictoria Terrace Plaza\n1448 Lawrence Ave E., Unit 15\nNorth York, ON M4A 2V6\n\n电话:\n416-757-2589 ","NorthYork.jpg"],"Toronto Morningside":["星期一到星期六 早上8:30 到 下午5:00",43.8027306,-79.1943877,"星期一到星期六 早上8:30 到 下午5:00\n\n地址:\n65 Grand Marshall Drive\nToronto, ON M1B 5N6\n\n电话:\n416-724-7520 ","Morningside.jpg"]]
    override func viewDidLoad() {
        super.viewDidLoad()
        map_view = MKMapView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        map_view.delegate = self
        locationManager.delegate = self
        let authstate = CLLocationManager.authorizationStatus()
        if authstate == CLAuthorizationStatus.NotDetermined {
            if (locationManager.respondsToSelector(Selector("requestWhenInUseAuthorization"))) {
                locationManager.requestWhenInUseAuthorization()
            }
            
        }
        locationManager.startUpdatingLocation()
        map_view.showsUserLocation = true
        
        
        infoView = UIView(frame: CGRect(x: screenSize.width*0.05,y: screenSize.height*0.15,width: screenSize.width*0.9, height: screenSize.height*0.72))
        infoView.backgroundColor = UIColorFromRGB(0xffffff)
        infoView.alpha = 0.95
        infoView.layer.cornerRadius = 10
        infoView.layer.shadowColor = UIColor.grayColor().CGColor
        infoView.layer.shadowOffset = CGSizeMake(10, 10)
        infoView.layer.shadowOpacity = 0.8
        
        cancelInfo = UIButton(frame: CGRect(x: 5,y: 5,width: 26,height: 26))
        cancelInfo.setTitle("✖", forState: UIControlState.Normal)
        cancelInfo.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        cancelInfo.addTarget(self, action: "closeInfo", forControlEvents: UIControlEvents.TouchUpInside)
        infoView.addSubview(cancelInfo)
        
        centerPhoto = UIImageView(frame: CGRect(x: 0, y: 0, width: infoView.frame.size.width, height: infoView.frame.size.height * 0.5))
        centerPhoto.roundCorners(.TopLeft | .TopRight, radius: 10)
        centerPhoto.layer.masksToBounds = true
        
        infoTextView = UITextView(frame: CGRect(x: 10, y: infoView.frame.size.height * 0.5, width: infoView.frame.size.width - 20, height: infoView.frame.size.height * 0.5))
        infoTextView.editable = false
        infoTextView.font = UIFont(name: "Helvetica Neue", size: 14)
        
        for (key,value) in examCenterList{
            var anotation = MKPointAnnotation()
            anotation.coordinate = CLLocationCoordinate2D(latitude: value[1] as! CLLocationDegrees,longitude: value[2] as! CLLocationDegrees)
            anotation.title = key as! String
            anotation.subtitle = value[0] as! String
            map_view.addAnnotation(anotation)
        }
        
        
        
        /*
        let longPress = UILongPressGestureRecognizer(target: self, action: "action:")
        longPress.minimumPressDuration = 1.0
        map_view.addGestureRecognizer(longPress)
        */
        
        var backButton = UIButton(frame: CGRect(x: 10, y: 25, width: 30, height: 30))
        backButton.setImage(UIImage(named: "backButton.png"), forState: UIControlState.Normal)
        backButton.layer.cornerRadius = 25
        backButton.addTarget(self, action: "backToMain", forControlEvents: .TouchUpInside)
        map_view.addSubview(backButton)
        
        self.view.addSubview(map_view)
    }
    
    func backToMain(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
       /*
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    let regionRadius : CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        map_view.setRegion(coordinateRegion, animated: true)
    }
    */
    var currentAnnotation : String!
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var pinView:MKPinAnnotationView = MKPinAnnotationView()
        pinView.annotation = annotation
        pinView.pinColor = MKPinAnnotationColor.Red
        pinView.animatesDrop = true
        pinView.canShowCallout = true
        if annotation.isKindOfClass(MKPointAnnotation){
            var infoButton: AnyObject = UIButton.buttonWithType(UIButtonType.DetailDisclosure)
            infoButton.addTarget(self, action: "examCenter", forControlEvents: .TouchUpInside)
            pinView.rightCalloutAccessoryView = infoButton as! UIView
        }
        return pinView
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        currentAnnotation = view.annotation.title
    }
    
    func mapViewWillStartLoadingMap(mapView: MKMapView!) {
    }
    
    
    func mapView(mapView: MKMapView!, regionWillChangeAnimated animated: Bool) {
        mapView.reloadInputViews()
        /*
        let annts = mapView.annotations
        mapView.removeAnnotations(annts)
        for a in annts{
            if let ant = a as? MKPointAnnotation {
                println("its annotation")
                mapView.addAnnotation(ant)
            }
        }
*/
    }

    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegion(center: newLocation.coordinate,span:span)
        
        map_view.setRegion(region, animated: true)
        
        locationManager.stopUpdatingLocation()
        
    }
    
    func examCenter(){
        let currentA = examCenterList[currentAnnotation] as! NSArray
        let scale1 = JNWSpringAnimation(keyPath: "transform.translation.y")
        scale1.damping = 100
        scale1.mass = 2
        scale1.fromValue = -200
        scale1.toValue = 0
        infoView.layer.addAnimation(scale1, forKey: scale1.keyPath)
        infoView.transform = CGAffineTransformMakeTranslation(0, 0)
        let imgName = currentA[4] as! String
        centerPhoto.image = UIImage(named: imgName)
        infoTextView.text = currentA[3] as! String
        infoView.addSubview(infoTextView)
        infoView.addSubview(centerPhoto)
        infoView.addSubview(cancelInfo)
        self.view.addSubview(infoView)
    }
    
    func closeInfo(){
        let scale2 = JNWSpringAnimation(keyPath: "transform.translation.y")
        scale2.fromValue = 0
        scale2.toValue = -screenSize.height
        infoView.layer.addAnimation(scale2, forKey: scale2.keyPath)
        infoView.transform = CGAffineTransformMakeTranslation(0, -screenSize.height)
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: Selector("removeView"), userInfo: nil, repeats: false)
    }
    
    func removeView(){
        infoView.removeFromSuperview()
    }
    
}

extension UIImageView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        self.layer.mask = mask
    }
}
