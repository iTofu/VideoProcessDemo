//
//  ViewController.swift
//  VideoProcessDemo
//
//  Created by Leo on 10/07/2017.
//  Copyright © 2017 Leo. All rights reserved.
//

import UIKit
import GPUImage
import Then

class ViewController: UIViewController {
    
    var movieFile: GPUImageMovie!
    var filter: GPUImageInput!
    var movieWriter: GPUImageMovieWriter!
    var preview: GPUImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let videoUrl = Bundle.main.url(forResource: "sample_iPod", withExtension: ".m4v")!
        
        self.movieFile = GPUImageMovie(url: videoUrl).then {
//            $0.runBenchmark = true
            $0.playAtActualSpeed = true
            $0.shouldRepeat = true
        }
        self.filter = GPUImageLowPassFilter()
        
        self.movieFile.addTarget(self.filter)
        
        self.preview = GPUImageView().then {
            $0.frame = UIScreen.main.bounds
            self.view.addSubview($0)
        }
        
        (self.filter as! GPUImageOutput).addTarget(self.preview)
        
        self.movieFile.startProcessing()
        
        UIButton(type: .contactAdd).do {
//            $0.setTitle("Change Filter", for: .normal)
            $0.addTarget(self, action: #selector(changeFilter), for: .touchUpInside)
            
            self.view.addSubview($0)
            $0.center = self.view.center
            $0.bounds.size = CGSize(width: 100.0, height: 40.0)
        }
        
        if #available(iOS 10.0, *) {
            let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
                print(self.movieFile.progress)
            }
            RunLoop.main.add(timer, forMode: .commonModes)
        }
    }
    
    func changeFilter() {
        self.movieFile.cancelProcessing()
        
        self.movieFile.removeTarget(self.filter)
        (self.filter as! GPUImageOutput).removeTarget(self.preview)
        
        self.filter = GPUImageMissEtikateFilter()
        self.movieFile.addTarget(self.filter)
        (self.filter as! GPUImageOutput).addTarget(self.preview)
        
        self.movieFile.startProcessing()
    }
}

