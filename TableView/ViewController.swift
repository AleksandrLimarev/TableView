//
//  ViewController.swift
//  TableView
//
//  Created by Александр Лимарев on 10.03.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView!
    var data: [String] = (1...30).map { "Cell \($0)" }
    var checkedCells: [Bool] = Array(repeating: false, count: 30)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: view.bounds.inset(by: UIEdgeInsets(top: 100, left: 20, bottom: 50, right: 20)))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10
        view.addSubview(tableView)
        
        let shuffleButton = UIButton(frame:CGRect(x:view.frame.width-80,y:view.frame.minY+50,width :60,height :40));
        shuffleButton.setTitle("Shuffle",for:.normal);
        shuffleButton.setTitleColor(.blue ,for:.normal);
        
        shuffleButton.addTarget(self ,action:#selector(shuffleCells),for:.touchUpInside);
        
        view.addSubview(shuffleButton);
    }
    
    @objc func shuffleCells(){
       let shuffledData=data.enumerated().map{($0,$1)};
       let shuffledChecked=checkedCells.enumerated().map{($0,$1)};
       
       let zipped=zip(shuffledData ,shuffledChecked).shuffled();
       
       data=zipped.map{$0.0.1};
       checkedCells=zipped.map{$0.1.1};
       
       self.tableView.reloadData();
   }

    func tableView(_ tableView:UITableView,didSelectRowAt indexPath :IndexPath){
        if checkedCells[indexPath.row]{
            checkedCells[indexPath.row]=false;
        }else{
            checkedCells[indexPath.row]=true;
            
            let tempDataValue=data.remove(at:indexPath.row);
            data.insert(tempDataValue ,at :0);
            
            let tempCheckedValue=checkedCells.remove(at:indexPath.row);
            checkedCells.insert(tempCheckedValue ,at :0);
            
            let topIndexpath=IndexPath(row :0 ,section :0);

             // Begin updates before animating row movement
             tableView.beginUpdates()
             tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
             tableView.endUpdates()

             UIView.animate(withDuration: 0.3) {
                 self.tableView.scrollToRow(at :topIndexpath ,at :.top ,animated:true)
             }

             // Reload row at top index path to update its appearance
             tableView.reloadRows(at: [topIndexpath], with: .none)
        }

        // Reload row at index path to update its appearance
        tableView.reloadRows(at: [indexPath], with: .none)
    }
   
   func tableView(_ tableView:UITableView,cellForRowAt indexPath :IndexPath)->UITableViewCell{
      let cell=UITableViewCell(style:.default,reuseIdentifier:nil)
      cell.textLabel?.text=data[indexPath.row]
      
      if checkedCells[indexPath.row]{
          cell.accessoryType = .checkmark
      }else{
          cell.accessoryType = .none
      }
      
      return cell
   }
   
   func tableView(_ tableView:UITableView,numberOfRowsInSection section:Int)->Int{
      return data.count
   }
}







