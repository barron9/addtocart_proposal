//
//  LoaderVC.swift
//  reducetotalproductcount
//
//  Created by 4A Labs on 17.11.2023.
//

import UIKit

class LoaderVC : UIViewController {
    var product = ""
    override func viewDidLoad() {
        
        let products = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 350) , size: CGSize(width: 500, height: 250)))
        products.text = product
        products.numberOfLines = 6
        products.textColor = .white
        let customFont = UIFont.systemFont(ofSize: 12)
        products.font = customFont
        
        
        let label = UILabel(frame: CGRect(origin: CGPoint(x: 50, y: 150) , size: CGSize(width: 150, height: 50)))
        label.text = "adding products..."
        label.numberOfLines = 6
        label.textColor = .white
        
        let act = UIActivityIndicatorView(style: .medium)
        act.color = .white
        act.startAnimating()
        act.layer.position.x = 60
        act.layer.position.y = 200
        
        view.backgroundColor = .systemBlue
        view.addSubview(label)
        view.addSubview(act)
        view.addSubview(products)
        
        DataMaster.shared.dataTx(data: (self.product.data(using: .utf32))!,completion: {[weak self] in
            self?.dismiss(animated: true)
        },vc: self)
        
    }
}

class DataMaster{
    static var shared = DataMaster()
    init() {}
    //https://mockbin.io/bins/00ea8f6e86044937b150f2240aea36d0
    func dataTx(data:Data,completion:@escaping ()->Void,vc:UIViewController?) {
        var reuqest = URLRequest(url: URL(string: "https://00ea8f6e86044937b150f2240aea36d0.api.mockbin.io/")!)
        reuqest.httpMethod = "post"
        reuqest.httpBody = data
        reuqest.timeoutInterval = 10
        let task = URLSession.shared.dataTask(with: reuqest, completionHandler: {data, resp, err in
            if((err) != nil){
                let alert = UIAlertController(title: "Error", message: "\(String(describing: err?.localizedDescription ?? ""))", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "ok", style: .cancel) { act in
                    completion()
                }
                alert.addAction(cancel)
                DispatchQueue.main.async {
                    vc?.present(alert, animated: true)
                }
                return
            }
            DispatchQueue.main.async {
                completion()
            }
        })
        task.resume()
    }
}
