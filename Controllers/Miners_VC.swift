//  MinersViewController.swift
//
//  Created for Miner by Michael Simone
//


/* NOTES

this view has *NO* backing code



*/



import UIKit

class Miners_VC: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var poolTableView: UITableView!
    @IBOutlet weak var minerTableView: UITableView!
    
    private var request: AnyObject?
    private var miner: Miner?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Enable the view to scroll
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 100)
    
        fetchMiners()
    }
    
	
    private func fetchMiners() {
        let minerRequest = APIRequest(resource: MinerResource())
        request = minerRequest
        minerRequest.load(withCompletion: { [weak self] (miner: Miner?) in
            guard let miner = miner else {
                return
            }
            self?.miner = miner
            self!.poolTableView.reloadData()
            self!.minerTableView.reloadData()
        })
    }
    
	
    @IBAction func sortBy(_ sender: Any) {
    }
    
	
    @IBAction func sortByMinerType(_ sender: Any) {
    }
    
	
    @IBAction func addNewPool(_ sender: Any) {
    }
    
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
	
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell?
        switch tableView {
            case poolTableView:
                cell = tableView.dequeueReusableCell(withIdentifier: "PoolCell")
                if cell == nil {
                    cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "PoolCell")
                }
                break
            
			case minerTableView:
                cell = tableView.dequeueReusableCell(withIdentifier: "MinerCell")
                if cell == nil {
                    cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "MinerCell")
                }
                break
            
			default:
                break
        }
        
        return cell!
    }
    
	
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
