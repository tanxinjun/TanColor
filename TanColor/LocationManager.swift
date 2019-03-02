//
//  LocationManager.swift
//  苹果定位
//
//  Created by 谭新均 on 2018/10/29.
//  Copyright © 2018年 谭新均. All rights reserved.
//

import UIKit
//导入定位的库
import CoreLocation

//继承NSObject
open class LocationManager:NSObject,CLLocationManagerDelegate{
    
    ///1.使用单例，必须要调用的方法
   public static let shareManager:LocationManager = LocationManager()
    
    ///2.单例的初始化:必须使用private
    private override init(){
        
    }

    //管理器
    var manager:CLLocationManager?
    //当前坐标
    var curLocation:CLLocation?
    //当前选中位置的坐标
    var curAddressCoordinate:CLLocationCoordinate2D?
    //当前位置地址
    var curAddress:String?

    //回调闭包:冒号后面是一个闭包变量
    var  callBack:((_ currentLocation:CLLocation?,_ currentAddress:String?,_ errorMsg:String?)->())?
    
    
    //这样写返回自己的目的是先调用设置的代理
   public func setLocationManager() -> LocationManager{
        
        //初始化定位管理器
        manager = CLLocationManager()
        //设置定位服务管理器代理
        manager?.delegate = self
        //设置定位模式：最佳的模式
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        //更新距离：20米更新
        manager?.distanceFilter = 20
        //发送授权申请：app使用期间
        manager?.requestWhenInUseAuthorization()
        //发送授权申请：app一直都在使用定位
        //manager?.requestAlwaysAuthorization()
        
        return self
    }
    
    
    
    //先检查是否开启了定位权限，若没有开启，那就跳转到设置页面开启
   public func checkLocationAuth(view:UIViewController) -> LocationManager{

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            ///检查定位权限///
            if(CLLocationManager.authorizationStatus() == .authorizedAlways) || (CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
                print("应用拥有定位权限")
            }else if(CLLocationManager.authorizationStatus() == .notDetermined){
                print("没有选择定位，需要再次弹出")
                self.manager?.requestWhenInUseAuthorization()
            }else if (CLLocationManager.authorizationStatus() == .denied) {
                print("关闭了定位权限，需要提示打开权限")
                self.OpenAppSet(view:view)
            }

        }

        return self
    }



    
    
    //打开app设置,开启定位服务
   public func OpenAppSet(view:UIViewController){

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            let alertController = UIAlertController(title: "请打开定位服务",message:"请进入设置，选择位置，选择使用应用期间",preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "设置", style: .default) { (alertAction) in
                if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            view.present(alertController, animated: true, completion: nil)
        }

    }


    
    
    //更新位置
    public func startLocation(resultBack:@escaping (_ currentLocation:CLLocation?,_ currentAddress:String?,_ errorMsg:String?)->()){
        
        //回调方法
        self.callBack = resultBack
        //在设置里，需要打开定位服务
        if CLLocationManager.locationServicesEnabled(){
            //开启定位服务更新
            manager?.startUpdatingLocation()
            print("定位开始")
        }
        
    }
    
    
    
    
    
    /****************实现定位的代理方法******************/
    ///-定位开始
   public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //获取最新的坐标
        curLocation = locations.last!
        //停止定位
        if locations.count > 0{
            //停止定位
            manager.stopUpdatingLocation()
            //调用逆地理编码，转换为具体的地址
            self.LonLatToCity()
        }
        
    }
    
   
    ///-定位失败调用的方法
   public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        callBack!(nil,nil,"定位失败===\(error)")
    }
    
    
    
    ///经纬度逆编
    func LonLatToCity() {
        
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(self.curLocation!) { (placemark, error) -> Void in
            if(error == nil){
                let firstPlaceMark = placemark!.first
                
                self.curAddress = ""
                //省
                if let administrativeArea = firstPlaceMark?.administrativeArea {
                    self.curAddress?.append(administrativeArea)
                }
                //自治区
                if let subAdministrativeArea = firstPlaceMark?.subAdministrativeArea {
                    self.curAddress?.append(subAdministrativeArea)
                }
                //市
                if let locality = firstPlaceMark?.locality {
                    self.curAddress?.append(locality)
                }
                //区
                if let subLocality = firstPlaceMark?.subLocality {
                    self.curAddress?.append(subLocality)
                }
                //地名
                if let name = firstPlaceMark?.name {
                    self.curAddress?.append(name)
                }
                //调用回调方法，把当前的坐标和定位的地址传过去
                self.callBack!(self.curLocation,self.curAddress,nil)
                
            }else{
                //调用回调方法，把错误代码传过去
                self.callBack!(nil,nil,"\(String(describing: error))")
            }
        }
        
    }
    

}
