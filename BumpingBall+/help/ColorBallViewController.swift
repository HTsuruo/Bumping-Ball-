//
//  ColorBallViewController.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/11/12.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit

class ColorBallViewController: UITableViewController {
    
    let commonIcon: [String] = [
        ballImage.BLUE, ballImage.GREEN, ballImage.ORANGE, ballImage.RED, ballImage.GOLD
    ]
    let commonTxt: [String] = [
        NSLocalizedString("commonTxt_1", comment: ""),
        NSLocalizedString("commonTxt_2", comment: ""),
        NSLocalizedString("commonTxt_3", comment: ""),
        NSLocalizedString("commonTxt_4", comment: ""),
        NSLocalizedString("commonTxt_5", comment: "")
    ]
    let commonSubTxt: [String] = [
        NSLocalizedString("commonSubTxt_1", comment: ""),
        NSLocalizedString("commonSubTxt_2", comment: ""),
        NSLocalizedString("commonSubTxt_3", comment: ""),
        NSLocalizedString("commonSubTxt_4", comment: ""),
        NSLocalizedString("commonSubTxt_5", comment: "")
    ]
    
    let itemIcon: [String] = [
        ballImage.ITEM_REVERSE, ballImage.ITEM_SPEEDUP, ballImage.ITEM_ONEUP
    ]
    let itemTxt: [String] = [
        NSLocalizedString("itemTxt_1", comment: ""),
        NSLocalizedString("itemTxt_2", comment: ""),
        NSLocalizedString("itemTxt_3", comment: "")
    ]
    let itemSubTxt: [String] = [
        NSLocalizedString("itemSubTxt_1", comment: ""),
        NSLocalizedString("itemSubTxt_2", comment: ""),
        NSLocalizedString("itemSubTxt_3", comment: "")
    ]
    
    private let COMMON = 0
    private let ITEM = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ColorBallCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.backgroundColor = ColorUtil.main
        self.tableView.separatorColor = UIColor.clear
    }

    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.navigationController?.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.white ]
        self.navigationController?.navigationBar.barTintColor = ColorUtil.main
        
        //戻ってきたときにどのボタンを選択していたかを提示する.
        if let indexPathForSelectedRow = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.alwaysBounceVertical = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60.0)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    //セクション名
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("color_ball_section_1", comment: "")
        case 1:
            return NSLocalizedString("color_ball_section_2", comment: "")
        default:
            return "error"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case COMMON:
            return commonIcon.count
        case ITEM:
            return itemIcon.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ColorBallCell
        let section = indexPath.section
        switch section {
        case COMMON:
            cell.colorBallIcon.image = UIImage(named: commonIcon[indexPath.row])
            cell.titleTxt.text = commonTxt[indexPath.row]
            cell.subTxt.text = commonSubTxt[indexPath.row]
            break
        case ITEM:
            cell.colorBallIcon.image = UIImage(named: itemIcon[indexPath.row])
            cell.titleTxt.text = itemTxt[indexPath.row]
            cell.subTxt.text = itemSubTxt[indexPath.row]
            break
        default:
            break
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
