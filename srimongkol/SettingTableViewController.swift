//
//  SettingTableViewController.swift
//  srimongkol
//
//  Created by NiM Thitipariwat on 20/7/2562 BE.
//  Copyright © 2562 Srimongkol. All rights reserved.
//

import UIKit

class SettingDays {
    var title = ""
    var selected = false
    
    init(title:String, selected:Bool = false) {
        self.title = title
    }
}

protocol SettingDateCellDelegate {
    func dateSelected(date:Date)
}

class SettingDateCell : UITableViewCell {
    var delegate:SettingDateCellDelegate?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        datePicker.addTarget(self, action: #selector(dateDidChanged), for: .valueChanged)
    }
    
    @objc
    func dateDidChanged() {
        delegate?.dateSelected(date: datePicker.date)
    }
}

class SettingTableViewController: UITableViewController, SettingDateCellDelegate {

    private var days:[SettingDays] = [
        SettingDays(title: "วันอาทิตย์", selected: false),
        SettingDays(title: "วันจันทร์", selected: false),
        SettingDays(title: "วันอังคาร", selected: false),
        SettingDays(title: "วันพุธ", selected: false),
        SettingDays(title: "วันพฤหัส", selected: false),
        SettingDays(title: "วันศุกร์", selected: false),
        SettingDays(title: "วันเสาร์", selected: false),
    ]
    
    private var showPicker:Bool = false
    private var selectedDate:Date = Date() {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            selectedDateString = dateFormatter.string(from: selectedDate)
        }
    }
    private var selectedDateString:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedDate = Date()
    }
    
    func dateSelected(date: Date) {
        selectedDate = date
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch section {
        
        case 0:
            return showPicker ? 2 : 1;
            
        case 1:
            return days.count;
            
        default:
            return 0;
            
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        switch indexPath.section {
        case 0:
            if showPicker && indexPath.row == 1 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as? SettingDateCell {
                    cell.delegate = self
                    return cell
                }
            } else {
                cell.textLabel?.text = "เวลา"
                cell.detailTextLabel?.text = selectedDateString
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
            let day = days[indexPath.row]
            cell.textLabel?.text = day.title
            cell.accessoryType = day.selected ? .checkmark : .none
            return cell
        default:
            break;
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            showPicker = !showPicker
            break;
        case 1:
            let day = days[indexPath.row]
            day.selected = !day.selected
        default:
            break;
        }
        
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
