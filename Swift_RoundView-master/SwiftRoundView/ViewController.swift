//
//  ViewController.swift
//  SwiftRoundView
//
//  Created by Pengfei_Luo on 15/12/22.
//  Copyright © 2015年 骆朋飞. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let imageArray =  ["http://pkimg.image.alimmdn.com/upload/20150113/34552bc6395342ce26ced17b2996cc81.PNG","http://pkimg.image.alimmdn.com/upload/20160429/bbda1ae03c730a16a81413f846bf6194.JPG","http://pkimg.image.alimmdn.com/upload/20150928/fb54a2286e42cd6022501bcdef391dd5.JPG"]
        let roundView = RoundView(frame: CGRectMake(0, 20, UIScreen.mainScreen().bounds.size.width, 150), imageList: imageArray)
        self.view.addSubview(roundView)
        
        roundView.delegate = self
        

    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController : RoundViewDelegate {
    func roundViewDidSelectedAtIndex(index: NSInteger) {
        debugPrint(index)
    }
}

