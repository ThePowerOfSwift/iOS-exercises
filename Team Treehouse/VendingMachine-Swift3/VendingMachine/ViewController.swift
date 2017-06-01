//
//  ViewController.swift
//  VendingMachine
//
//  Created by Pasan Premaratne on 12/1/16.
//  Copyright © 2016 Treehouse Island, Inc. All rights reserved.
//

import UIKit

fileprivate let reuseIdentifier = "vendingItem"
fileprivate let screenWidth = UIScreen.main.bounds.width

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityStepper2: UIStepper!
    
    let vendingMachine: VendingMachine
    var currentSelection: VendingSelection?
    
    required init?(coder aDecoder: NSCoder) {
        do {
            let dictionary = try PListConverter.dictionary(fromFile: "VendingInventory", ofType: "plist")
            let inventory = try InventoryUnarchiver.vendingInventory(fromDictionary: dictionary)
            self.vendingMachine = FoodVendingMachine(inventory: inventory)
        } catch let error {
            fatalError("\(error)")
        }
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupCollectionViewCells()
        //print(vendingMachine.inventory)
        updateDisplay(totalPrice: 0, itemPrice: 0,
                      itemQuantity: Int(quantityStepper2.value))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDisplay(totalPrice: Double? = nil, itemPrice: Double? = nil,
                       itemQuantity: Int? = nil) {
        balanceLabel.text = "$\(vendingMachine.amountDeposited)"
        
        if let totalValue = totalPrice {
            totalLabel.text = "$\(totalValue)"
        }
        
        if let price = itemPrice {
            priceLabel.text = "$\(price)"
        }
        
        if let quantity = itemQuantity {
            quantityLabel.text = "\(quantity)"
        }
    }
    
    func updateTotalPrice(for item: VendingItem) {
        let totalPrice = item.price * quantityStepper2.value
        totalLabel.text = "$\(totalPrice)"
        updateDisplay(totalPrice: totalPrice)
    }
    
    @IBAction func updateQuantity(_ sender: UIStepper) {
        let quantity = quantityStepper2.value
        quantityLabel.text = "\(quantity)"
        updateDisplay(itemQuantity: Int(quantity))
        
        if let selection = currentSelection,
            let item = vendingMachine.item(forSelection: selection) {
            updateTotalPrice(for: item)
        }
    }
    
    // MARK: - Setup

    func setupCollectionViewCells() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        let padding: CGFloat = 10
        let itemWidth = screenWidth/3 - padding
        let itemHeight = screenWidth/3 - padding
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        collectionView.collectionViewLayout = layout
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vendingMachine.selection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? VendingItemCell else { fatalError() }
        
        let item = vendingMachine.selection[indexPath.row]
        cell.iconView.image = item.icon()
        return cell
    }
    
    func getItem(_ index: Int) -> VendingSelection {
        return vendingMachine.selection[index]
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateCell(having: indexPath, selected: true)
        currentSelection = self.getItem(indexPath.row)
        quantityStepper2.value = 1
        updateDisplay(totalPrice: 0, itemQuantity: Int(quantityStepper2.value))
        
        if let selectedItem = currentSelection,
            let item = vendingMachine.item(forSelection: selectedItem) {
            priceLabel.text = "$\(item.price)"
            let totalPrice = item.price * quantityStepper2.value
            totalLabel.text = "$\(totalPrice)"
            
            updateDisplay(totalPrice: totalPrice, itemPrice: item.price)
        } else {
            updateDisplay()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateCell(having: indexPath, selected: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        updateCell(having: indexPath, selected: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        updateCell(having: indexPath, selected: false)
    }
    
    func updateCell(having indexPath: IndexPath, selected: Bool) {
        let selectedBackgroundColor = UIColor(red: 41/255.0, green: 211/255.0, blue: 241/255.0, alpha: 1.0)
        let defaultBackgroundColor = UIColor(red: 27/255.0, green: 32/255.0, blue: 36/255.0, alpha: 1.0)
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = selected ? selectedBackgroundColor : defaultBackgroundColor
        }
    }
    
    
    @IBAction func purchase() {
        if let selectedItem = currentSelection {
            do {
                try vendingMachine.vend(selectedItem, quantity: Int(quantityStepper2.value))
                quantityStepper2.value = 1
                updateDisplay(totalPrice: 0.0, itemPrice: 0,
                              itemQuantity: Int(quantityStepper2.value))
            } catch VendingMachineError.outOfStock {
                showAlert(title: "Out of stock", message: "This item is unavailable, please make another selection")
            } catch VendingMachineError.invalidSelection {
                showAlert(title: "Out of stock", message: "This item is unavailable, please make another selection")
            } catch VendingMachineError.insufficientFunds {
                showAlert(title: "You ain't got enough money", message: "Go to work")
            } catch let error {
                fatalError("\(error)")
            }
            
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                collectionView.deselectItem(at: indexPath, animated: true)
                updateCell(having: indexPath, selected: false)
            }
            
        } else {
            showAlert(
                title: "Item not found",
                message: "It was not possible to find the item selected in the vending machine"
            )
        }
    }
    
    func showAlert(title: String, message: String, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: style)
        
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: alertDismissed)
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func depositFunds() {
        vendingMachine.deposit(5.0)
        updateDisplay()
    }
    
    @IBAction func depositFunds2() {
        depositFunds()
    }
    func alertDismissed(sender: UIAlertAction) {
        updateDisplay(totalPrice: 0, itemPrice: 0, itemQuantity: 0)
    }
}
