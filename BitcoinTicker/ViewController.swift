
import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","COP","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbolArray = ["$", "R$", "$", "¥", "$", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        finalURL = baseURL + currencyArray[0]
        print(finalURL)
        getBitCoinPrice(url: finalURL, symbol: currencySymbolArray[0])
       
    }
  

    
    //TODO: Place your 3 UIPickerView delegate methods here
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(currencyArray[row])
        
        finalURL = baseURL + currencyArray[row]
        print(finalURL)
        getBitCoinPrice(url: finalURL, symbol: currencySymbolArray[row])

    }
    
    
//    
//    //MARK: - Networking
//    /***************************************************************/
    
    func getBitCoinPrice(url: String, symbol: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the bitcoin price")
                    let bitCoinJSON : JSON = JSON(response.result.value!)

                    let currencySymbol = symbol
                    self.updateBitCoinPrice(json: bitCoinJSON, symbol: currencySymbol)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }

    
//    //MARK: - JSON Parsing
//    /***************************************************************/
    
    func updateBitCoinPrice(json : JSON, symbol: String) {
        
        if let priceResult = json["averages"]["day"].double {
            print(priceResult)
            bitcoinPriceLabel.text = "\(symbol)"+"\(priceResult)"
        }
        else {
            bitcoinPriceLabel.text = "Price unavailable"
        }
    }
    

}

