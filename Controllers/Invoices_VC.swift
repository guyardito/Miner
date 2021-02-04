//  InvoicesViewController.swift
//
//  Created for Miner by Michael Simone
//


/* NOTES

the 'View' button in the storyboard is NOT hooked up to any callback/action


*/



import UIKit

class Invoices_VC: UIViewController {

    @IBOutlet weak var costSlider: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var consumptionLabel: UILabel!
    @IBOutlet weak var currentTotalLabel: UILabel!
    @IBOutlet weak var invoiceNumberLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var energyLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var invoiceLabel: UILabel!
    
    private var request: AnyObject?
    private var invoice: Invoice?
    
	
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchInvoice()
    }
	
	
    
	
    private func fetchInvoice() {
        let invoiceRequest = APIRequest(resource: InvoiceResource())
        request = invoiceRequest
        invoiceRequest.load(withCompletion: { [weak self] (invoice: Invoice?) in
            guard let invoice = invoice else {
                return
            }
            self?.invoice = invoice
            self?.drawSliderValue()
            self?.drawLabels()
        })
    }
    
	
	
	private func drawSliderValue() {
		let trackRect: CGRect  = costSlider.trackRect(forBounds: costSlider.bounds)
		let thumbRect: CGRect  = costSlider.thumbRect(forBounds: costSlider.bounds , trackRect: trackRect, value: costSlider.value)
		let x = thumbRect.origin.x + costSlider.frame.origin.x
		let y = costSlider.frame.origin.y - 20
		sliderLabel.center = CGPoint(x: x, y: y)
		
		sliderLabel.text = String(format:"$%.02f", invoice!.amount_due)
		costSlider.setValue(Float(invoice!.amount_due)!, animated: false)
	}
	
	
	
    private func drawLabels() {
        consumptionLabel.text = "\(invoice!.electricity_used) kWh"
        currentTotalLabel.text = String(format:"$%.02f", invoice!.amount_due)
        invoiceNumberLabel.text = invoice?.id_user ?? " "
        
        let month = invoice?.month_name ?? "January"
        let year = invoice?.year ?? "2000"
        monthLabel.text = String(format: "%s - $%s", month, year)
        
        amountLabel.text = String(format:"$%.02f", invoice!.amount_due)
        energyLabel.text = invoice?.electricity_used
        
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        dueDateLabel.text = formatter1.string(from: invoice!.due_date)
    }
}
