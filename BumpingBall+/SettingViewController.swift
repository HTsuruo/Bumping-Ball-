//
//  SettingViewController.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/10/30.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import FontAwesomeKit

class SettingViewController: UITableViewController {
    
    let setting = ["Music", "Sound"]
    let info = ["Review", "License", "Version"]
    var settingIcon: [UIImage] = []
    var infoIcon: [UIImage] = []
    let settingTypeArray: [SettingType] = [SettingType.music, SettingType.sound]
    let infoTypeArray: [SettingType] = [SettingType.review, SettingType.licence, SettingType.version]
    
    private let SETTING = 0
    private let INFO = 1

    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.navigationController?.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.white ]
        self.navigationController?.navigationBar.barTintColor = ColorUtil.main
        
        //戻ってきたときにどのボタンを選択していたかを提示する.
        if let indexPathForSelectedRow = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.alwaysBounceVertical = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier: "cell")
        setIcons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            return "基本設定"
        case 1:
            return "アプリ情報"
        default:
            return "エラー"
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case SETTING:
            return setting.count
        case INFO:
            return info.count
        default:
            return 0
        }
    }

    //セルのセット
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingCell
        let section = indexPath.section
        switch section {
        case SETTING:
            cell.titleLabel.text = setting[indexPath.row]
            cell.imgView.image = settingIcon[indexPath.row]
            cell.settingType = settingTypeArray[indexPath.row]
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.switchBtn.isHidden = false
            var isOff: Bool = false
            switch cell.settingType {
            case .music:
                isOff = UserDefaults.standard.bool(forKey: udKey.off_music)
                break
            case .sound:
                isOff = UserDefaults.standard.bool(forKey: udKey.off_sound)
                break
            default:
                break
            }
            cell.switchBtn.setOn(!isOff, animated: false)
            break
        case INFO:
            cell.titleLabel.text = info[indexPath.row]
            cell.imgView.image = infoIcon[indexPath.row]
            cell.settingType = infoTypeArray[indexPath.row]
            switch cell.settingType {
            case .licence:
                cell.selectionStyle = UITableViewCellSelectionStyle.default
                break
            case .version:
                cell.contentLabel.text = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String?
                cell.contentLabel.isHidden = false
                cell.accessoryType = UITableViewCellAccessoryType.none
                break
            default:
                break
            }
            break
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == INFO {
            let row = indexPath.row
            switch row {
            case 0:
                let url = NSURL(string: define.APPSTORE_URL)
                if UIApplication.shared.canOpenURL(url as! URL) {
                    UIApplication.shared.openURL(url as! URL)
                }
                break
            case 1:
                self.performSegue(withIdentifier: "toLicence", sender: self)
                break
            default:
                break
            }

        }
    }
    
    @IBAction func onClickCloseBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setIcons() {
        let size = CGSize(width: 50, height: 50)
        
        // music
        var icon = FAKFontAwesome.musicIcon(withSize:size.width)
        icon?.addAttribute(NSForegroundColorAttributeName, value: ColorUtil.main)
        settingIcon.append((icon?.image(with: size))!)
        
        // sound
        icon = FAKFontAwesome.volumeUpIcon(withSize:size.width)
        icon?.addAttribute(NSForegroundColorAttributeName, value: ColorUtil.main)
        settingIcon.append((icon?.image(with: size))!)
        
        // review
        icon = FAKFontAwesome.editIcon(withSize:size.width)
        icon?.addAttribute(NSForegroundColorAttributeName, value: ColorUtil.main)
        infoIcon.append((icon?.image(with: size))!)
        
        // licence
        icon = FAKFontAwesome.fileTextIcon(withSize:size.width)
        icon?.addAttribute(NSForegroundColorAttributeName, value: ColorUtil.main)
        infoIcon.append((icon?.image(with: size))!)
        
        // version
        icon = FAKFontAwesome.levelUpIcon(withSize:size.width)
        icon?.addAttribute(NSForegroundColorAttributeName, value: ColorUtil.main)
        infoIcon.append((icon?.image(with: size))!)
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
