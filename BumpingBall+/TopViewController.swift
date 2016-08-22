//
//  TopViewController.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/04/01.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SpriteKit

class TopViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let util = Utils()
    let skView = SKView()
    @IBOutlet weak var onePlayBtn: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    private let difficulties: NSArray = ["Easy", "Normal", "Hard"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "topVC"
        util.setStatusBar(self.view)
        pickerViewInit()
    
        if let scene = TopScene(fileNamed:"TopScene") {
            // Configure the view.
            skView.frame = CGRectMake(0, 0, define.WIDTH, define.HEIGHT)
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .ResizeFill
            
            skView.allowsTransparency = true
            skView.presentScene(scene)
        }
        self.view.addSubview(skView)
        self.view.sendSubviewToBack(skView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    
    
    @IBAction func onePlayBtnClicked(sender: UIButton) {
        self.performSegueWithIdentifier("toOnePlayVC", sender: self)
    }
    
    /** picker view setting **/
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return difficulties.count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let label = UILabel.init(frame: CGRectMake(0, 0, pickerView.frame.width, 40))
        label.text = String(difficulties[row])
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont(name: "Candara", size: 24)
        label.textColor = UIColor.whiteColor()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5.0
//        switch row {
//            case 0:
//                label.textColor = colorUtils.blue
//            case 1:
//                label.textColor = colorUtils.green
//            case 2:
//                label.textColor = colorUtils.red
//            default:
//                label.textColor = colorUtils.clear
//        }
        
        return label
    }
    
    // 選択された時
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("selected: \(row), \(difficulties[row])")
        app.selectedDiffculty = row
        setSelectedBkColor(row)
    }
    
    func pickerViewInit() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = colorUtils.clear
        pickerView.layer.masksToBounds = true
        pickerView.layer.cornerRadius = 10.0
        pickerView.selectRow(app.selectedDiffculty!, inComponent: 0, animated: false)
        setSelectedBkColor(app.selectedDiffculty!)
    }
    
    func setSelectedBkColor (row: Int) {
        switch row {
        case 0:
            pickerView.backgroundColor = colorUtils.blue
        case 1:
            pickerView.backgroundColor = colorUtils.green
        case 2:
            pickerView.backgroundColor = colorUtils.red
        default:
            pickerView.backgroundColor = colorUtils.clear
        }
    }
}
