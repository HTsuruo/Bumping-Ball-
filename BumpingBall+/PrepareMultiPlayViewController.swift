//
//  PrepareMultiPlayViewController.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/08/28.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class PrepareMultiPlayViewController: UIViewController {
    var app: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var bluetoothArea: UIView!
    @IBOutlet weak var networkArea: UIView!
    @IBOutlet weak var animationLabel: UILabel!
    @IBOutlet weak var bluetoothImg: UIImageView!
    @IBOutlet weak var globalImg: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        bluetoothArea.backgroundColor = UIColor.clear
        networkArea.backgroundColor = UIColor.clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btgesture = UITapGestureRecognizer(target: self, action: #selector(self.onTapBluetoothArea(_:)))
        bluetoothArea.layer.borderWidth = 2.0
        bluetoothArea.layer.borderColor = UIColor.white.cgColor
        bluetoothArea.isUserInteractionEnabled = true
        bluetoothArea.addGestureRecognizer(btgesture)
        bluetoothArea.sendSubview(toBack: bluetoothImg)
        
        let nwgesture = UITapGestureRecognizer(target: self, action: #selector(self.onTapNetoworkArea(_:)))
        networkArea.layer.borderWidth = 2.0
        networkArea.layer.borderColor = UIColor.white.cgColor
        networkArea.isUserInteractionEnabled = true
        networkArea.addGestureRecognizer(nwgesture)
        networkArea.sendSubview(toBack: globalImg)
        
        app.bluetoothSession = nil
    }
    
    @IBAction func onClickBackBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func onTapBluetoothArea(_ sender: UITapGestureRecognizer) {
        bluetoothArea.backgroundColor = ColorUtil.selected
        app.selectedPlay = PlayType.bluetooth
        self.performSegue(withIdentifier: "toMultiPlay", sender: self)
    }
    
    func onTapNetoworkArea(_ sender: UITapGestureRecognizer) {
        app.selectedPlay = PlayType.network
        networkArea.backgroundColor = ColorUtil.selected
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
