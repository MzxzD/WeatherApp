//
//  ErrorController.swift
//  WeatherApp
//
//  Created by Mateo Došlić on 27/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//
import UIKit

// MARK: Error Function

func downloadError(viewToPresent: UIViewController){
    let alertController = UIAlertController(title: "Whoops!", message: "Something went Wrong :(", preferredStyle: .alert)
    
    let defaultAction = UIAlertAction(title: "Okay :(", style: .default, handler: nil)
    alertController.addAction(defaultAction)
    
    viewToPresent.present(alertController, animated: true, completion: nil)
}

func errorOccured(value: Error){
    let alert = UIAlertController(title: "Whoops!", message: "Something went wrong, Error: \(value)", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Okay. :(", style: .default, handler: nil))
}
func errorOccured(){
    let alert = UIAlertController(title: "Whoops!", message: "Something went wrong", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Okay. :(", style: .default, handler: nil))
}

