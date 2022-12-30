//
//  Menu.swift
//  The Third Eye
//
//  Created by Abhinav Bulusu on 7/30/22.
//

import Foundation


class Menu {
    
    private var restaurantName : NSString = ""
    private var restaurantMenu : NSString = ""
    
    public func getRestaurantName() -> NSString
    {
        return restaurantName
    }
    
    public func getRestaurantMenu() -> NSString
    {
        return restaurantMenu
    }
    
    public func setRestaurantName(name:NSString)
    {
        restaurantName = name
    }
    
    public func setRestaurantMenu(menu:NSString)
    {
        restaurantMenu = menu
    }

}
