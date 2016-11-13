//
//  HelpViewController.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/11/13.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.navigationController?.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.white ]
        self.navigationController?.navigationBar.barTintColor = ColorUtil.main
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onClickTutorialBtn(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toTutorial", sender: self)
        
    }
    
    @IBAction func onClickMultiModeBtn(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toMultiModeHelp", sender: self)
    }
    
    @IBAction func onClickColorBallListBtn(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toColorBallList", sender: self)
    }
    
    @IBAction func onClickCloseBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
