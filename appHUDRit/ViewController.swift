//
//  ViewController.swift
//  appHUDRit
//
//  Created by Maxorax on 19.03.2021.
//

import UIKit
import CoreLocation
class ViewController: UIViewController{
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var speedView: SpeedView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var footerView: FooterView!
    private var previousLocation: CLLocation?
    private var previousLocationForAverageSpeed: CLLocation?
    private let dataStoreManager = DataStoreManager()
    private var distance: Double = 0
    private var lastDistance: Double = 0
    private var lastLocation: CLLocation?
    private  var temp = 0
    private var count = 0
    private var timer = Timer()
    var mSys = "км"
    var koef = 1.0
  
    
    override func viewDidLoad() {
        if let lastState = dataStoreManager.obtainLastState(){
            distance = lastState.distance
            mSys = lastState.mSys ?? "км"
            koef = lastState.koef
            headerView.hudSwitch.setOn(lastState.isHUDOn, animated: true)
            changeHUDMode(target: headerView.hudSwitch)
            
        }
        super.viewDidLoad()
        manager.delegate = self
        manager.startUpdatingLocation()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.MyTimer), userInfo: nil, repeats: true)
        
        headerView.hudSwitch.addTarget(self, action: #selector(changeHUDMode(target:)), for: .valueChanged)
    }
    
    @IBAction func unwindToSettingsViewController(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source as! SettingsViewController
        self.koef = sourceViewController.koef
        self.footerView.averageSpeed.text?.removeAll()
        self.mSys = sourceViewController.mSys
        self.footerView.averageSpeed.text? += "0.0 \(self.mSys)"        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let dest = segue.destination as? SettingsViewController {
                dest.mSys = self.mSys
                dest.koef = self.koef
            }
        }
    
    @objc func changeHUDMode(target: UISwitch){
        if target.isOn {
            speed.transform = CGAffineTransform(scaleX: -1, y: 1)
            headerView.hudSwitch.transform = CGAffineTransform(scaleX: -1, y: 1)
            headerView.weather.transform = CGAffineTransform(scaleX: -1, y: 1)
            headerView.weatherLabel.transform = CGAffineTransform(scaleX: -1, y: 1)
            headerView.HUDLabel.transform = CGAffineTransform(scaleX: -1, y: 1)
            footerView.averageSpeed.transform = CGAffineTransform(scaleX: -1, y: 1)
            footerView.distanceCovered.transform = CGAffineTransform(scaleX: -1, y: 1)
            footerView.resetDataButton.transform = CGAffineTransform(scaleX: -1, y: 1)
            footerView.averageSpeedLabel.transform = CGAffineTransform(scaleX: -1, y: 1)
            footerView.distanceCoveredLabel.transform = CGAffineTransform(scaleX: -1, y: 1)
            speedView.transform = CGAffineTransform(scaleX: -1, y: 1)
        } else {
            speed.transform = CGAffineTransform(scaleX: 1, y: 1)
            headerView.hudSwitch.transform = CGAffineTransform(scaleX: 1, y: 1)
            headerView.weather.transform = CGAffineTransform(scaleX: 1, y: 1)
            headerView.weatherLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            headerView.HUDLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            footerView.averageSpeed.transform = CGAffineTransform(scaleX: 1, y: 1)
            footerView.distanceCovered.transform = CGAffineTransform(scaleX: 1, y: 1)
            footerView.resetDataButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            footerView.averageSpeedLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            footerView.distanceCoveredLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            speedView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        
    }
    
    @objc func showSettings(target: UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        show(controller, sender: nil)
    }
    
    @objc func MyTimer(){
        count += 1
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            
            if !footerView.flag {
                previousLocation = locations.last!
                previousLocationForAverageSpeed = locations.last!
                footerView.flag = true
                
                self.footerView.distanceCovered.text = "0.0 \(mSys)"
                self.footerView.averageSpeed.text = "0.0 \(mSys)/ч"
            }
            if footerView.flagForDistance{
                distance = 0
            }
            let lastLocation = locations.last!
            if count == 10, let pLFAS = previousLocationForAverageSpeed {
                count = 0
                footerView.averageSpeed.text = String(format: "%.1f", lastLocation.distance(from: pLFAS) * koef * 3.6 / 600  ) + " \(mSys)"
                previousLocationForAverageSpeed = locations.last!
            }
            guard let previousLocation = previousLocation else {
                return
            }
            lastDistance = lastLocation.distance(from: previousLocation)/1000
            footerView.distanceCovered.text = String(format: "%.3f", (lastDistance + distance) * koef)  + " \(mSys)"
            
            let speed = Int(location.speed * 3.6 * koef)
            speedView.speedometrView.speed = CGFloat(speed)
            self.speed.text = String(" \(speed) \(mSys)/ч")
            let coordinate = location.coordinate
            getWeather(latitude: coordinate.latitude.rounded(), longitude: coordinate.longitude.rounded())
            headerView.weather.text = String(temp) + "℃"
            dataStoreManager.SaveLastState(distance: lastDistance, mSys: mSys, koef: koef, isHUDOn: headerView.hudSwitch.isOn)
        }
    }
    
    let manager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.distanceFilter = 10
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.activityType = .automotiveNavigation
        locationManager.showsBackgroundLocationIndicator = true
        return locationManager
    }()

    func getWeather( latitude: CLLocationDegrees, longitude: CLLocationDegrees ) {
        let stringUrl = "https://api.openweathermap.org/data/2.5/weather?lat=\(Int(latitude))&lon=\(Int(longitude))&units=metric&appid=2bef8b6a15288e1fd8dee52321af737e"
        guard let url = URL(string: stringUrl) else { return }
        let _ = URLSession.shared.dataTask(with: url){
            (data, response, error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "noDesc")
                return
            }
            guard let data = data else {
                return
            }
            guard let weatherInfo = try? JSONDecoder().decode(WeatherEntity.self, from: data)  else {
                print("Error: can't parse Weather")
                return
            }
            self.temp = Int(weatherInfo.main.temp )
    }.resume()
        return
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Отключаем локацию")
        case .authorizedWhenInUse:
            print("Включаем базовые функции")
            manager.requestAlwaysAuthorization()
        case .authorizedAlways:
            print("Локация всегда включена")
         default:
            NSLog("error")
        }
    }
}

