//
//  GenerateRoutes.swift
//  UberProject
//
//  Created by Emma Shen on 9/17/23.
//

import UIKit

class GenerateRoutes: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // How many rows in tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    
    //Defines what cells are being used
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! CardCell
        print("bleh")
        cell.configure(modeIcons: modeIcons[indexPath.row], times: times[indexPath.row], prices: prices[indexPath.row], emissions: emissions[indexPath.row])
        return cell
    }
    @IBOutlet weak var sortByButton: UIButton!
    @IBOutlet weak var cardTableView: UITableView!
    @IBOutlet var sortButtons: [UIButton]!
    
    @IBAction func sortByAction(_ sender: Any) {
    }
    
    @IBAction func sortButtonsAction(_ sender: UIButton) {
        showButtonVisibility()
        switch sender.currentTitle {
        case "Time":
            sortByButton.backgroundColor = .systemBlue
            sortByButton.setTitle("Time", for: .normal)
        case "Price":
            sortByButton.backgroundColor = .systemYellow
            sortByButton.setTitle("Price", for: .normal)
        case "Emission":
            sortByButton.backgroundColor = .systemGreen
            sortByButton.setTitle("Emission", for: .normal)
        default:
            sortByButton.backgroundColor = .systemBlue
            sortByButton.setTitle("Time", for: .normal)
        }
    }
    // Generate certain icons depending on route
    let modeIcons: [UIImage] = [UIImage(named: "Bus.png")!, UIImage(named: "Car.png")!, UIImage(named: "Train.png")!, UIImage(named: "Subway.png")!, UIImage(named: "Light-rail.png")!]
    
    // Need to connect to backend
    let times: [String] = ["35", "65", "32", "12", "123"]
    let prices: [String] = ["55", "45", "97", "13", "34"]
    let emissions: [String] = ["4", "53", "34", "23", "16"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("yo")
    }
    
    func showButtonVisibility () {
        sortButtons.forEach {button in
            UIView.animate(withDuration: 0.3) {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        }
    }
}
