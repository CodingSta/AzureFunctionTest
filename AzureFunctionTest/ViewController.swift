//
//  ViewController.swift
//  AzureFunctionTest
//
//  Created by jumingyu on 2017. 3. 21..
//  Copyright © 2017년 jumingyu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var btnA: UIButton!
    @IBOutlet var labelA: UILabel!
    var reqA: URLRequest?
    var sessionA: URLSession?
    var numA: Int = 0

    let urlA: URL = URL(string: "https://changchang.azurewebsites.net/api/ChangFunc?code=c0q4piYah1EJoDOBLwAxsG9ls9YISulyL/FQzc1d0BqN95N4VZ9WLg==")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reqA = URLRequest(url: urlA)
        self.reqA?.httpMethod = "POST"
        self.reqA?.setValue("text/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        self.sessionA = URLSession.shared
    }
    
    @IBAction func btnPressed() {
        self.labelA.text = "Getting from Azure Functions..."
        numA+=1
        let dicJ: Dictionary = ["first":"MinGyu", "last":"\(numA)"]
        if let jsonData = try? JSONSerialization.data(withJSONObject: dicJ, options: []) {
            self.reqA?.httpBody = jsonData
        }
        let taskA = self.sessionA!.dataTask(with: self.reqA!) { (data, resp, err) in
            if err != nil {
                print(err!)
            } else {
                let dicB = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: String]
                //print(dicB!)
                OperationQueue.main.addOperation {
                    self.labelA.text = "\(dicB)"
                }
            }
            print(resp!)
        }
        taskA.resume()
    }
    
}

/* Bundle 내의 JSON 파일을 불러올 때.
if let bodyUrl = Bundle.main.url(forResource: "bodyValue", withExtension: "json") {
    if let dataA = try? Data(contentsOf: bodyUrl) {
        self.reqA?.httpBody = dataA
        self.reqA?.addValue("text/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    }
}
 */

/* Bundle 내의 JSON 로딩 후 Dictionary 로 리턴.
 func loadJson(forFilename fileName: String) -> Dictionary<String, String>? {
 
 if let bodyValue = Bundle.main.url(forResource: fileName, withExtension: "json") {
 
 if let dataA = NSData(contentsOf: bodyValue) {
 do {
 let dicA = try JSONSerialization.jsonObject(with: dataA as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, String>
 return dicA
 } catch {
 print("Error!! Unable to parse  \(fileName).json")
 }
 }
 print("Error!! Unable to load  \(fileName).json")
 }
 return nil
 }
 */

/* JSON 변환 Sample Source
 let dic = ["2": "B", "1": "A", "3": "C"]
 
 do {
 let jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
 // here "jsonData" is the dictionary encoded in JSON data
 
 let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
 // here "decoded" is of type `Any`, decoded from JSON data
 
 // you can now cast it with the right type
 if let dictFromJSON = decoded as? [String:String] {
 // use dictFromJSON
 }
 } catch {
 print(error.localizedDescription)
 }
 */
