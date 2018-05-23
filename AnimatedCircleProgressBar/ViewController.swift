//
//  ViewController.swift
//  AnimatedCircleProgressBar
//
//  Created by Tandem on 23/05/2018.
//  Copyright © 2018 Tandem. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
    let shapeLayer = CAShapeLayer()
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
        
        //start drawing circle

        let center  = view.center
        
        //create the track layer, the softer color underneath the bar that it is going to fill
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10 //the width of the bar
        trackLayer.fillColor = UIColor.clear.cgColor //amek the middle area have clear color
        trackLayer.lineCap = kCALineCapRound //this to make the bar has rounded corner
        trackLayer.position = center
        view.layer.addSublayer(trackLayer)
        
//        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true) //start angle like this to have the bar start at 12 o'clock
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10 //the width of the bar
        shapeLayer.fillColor = UIColor.clear.cgColor //amek the middle area have clear color
        shapeLayer.lineCap = kCALineCapRound //this to make the bar has rounded corner
        shapeLayer.strokeEnd = 0
        shapeLayer.position = center
        
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        
        view.layer.addSublayer(shapeLayer)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    let urlString = "https://www.hdwallpapers.in/download/for_honor_season_6_rite_of_champions_4k_8k-HD.jpg"
    
    //the require func for URLSessionDownloadDelegate delegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("finish downloading file")
    }
    
    //optional func from the delegate URLSessionDownloadDelegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
//        print(totalBytesWritten, totalBytesExpectedToWrite)
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        print("percentage : ", percentage)
        
        //this need to be in the main thread because the url session downloading is not on the main thread, so if without DispatchQueue.main, then the UI wont update
        DispatchQueue.main.async {
            self.percentageLabel.text = "\(Int(percentage * 100))%"
            self.shapeLayer.strokeEnd = percentage
        }
        
    }
    
    private func begindDownloadFile(){
        
        //this fix the bar going back and forth
        shapeLayer.strokeEnd = 0
        
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        
        guard let url = URL(string: urlString) else { return }
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    fileprivate func animateCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd") //animate the shapeLayer.strokeEnd
        basicAnimation.toValue = 1
        
        basicAnimation.duration = 2
        
        //need these 2 lines to make the bar stopped at the final point, if not it will be removed upon completion
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation,forKey: "customString")
    }
    
    @objc private func handleTap(){
        print("animate here")
        
        begindDownloadFile()
        
//        animateCircle()//custom string for forKey value, not sure where will use it later
        
    }


}

