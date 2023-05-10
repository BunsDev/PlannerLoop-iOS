//
//  Extensions.swift
//  PlannerLoop
//
//  Created by Tomáš Tomala

import Foundation
import SwiftUI
import Combine

extension String {
    
    /// Decode Base64 string to data
    /// - Returns: Binary data
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }
    
    /// Encode data to Base64 string
    /// - Returns: string with Base64 encoded data
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

}

extension UIApplication {
    
    /// Dismiss keyboard when touch registered outside of textfield
    /// https://www.dabblingbadger.com/blog/2020/11/5/dismissing-the-keyboard-in-swiftui
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        tapGesture.name = "MyTapGesture"
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    /// Allow navigationView gesture pop
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false // set to `false` if you don't want to detect tap during other gestures
    }
}

/// Allow navigationView gesture pop
extension UINavigationController: UIGestureRecognizerDelegate {
    ///https://stackoverflow.com/a/60067845/9273242
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

extension View{
    
    ///get screen measurements
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
    
    
    ///get safearea measurements
    func getSafeArea() ->UIEdgeInsets {
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
     ///custom modifier to hide navigation bar
    func hiddenNavigationBarStyle() -> some View {
        modifier( HiddenNavigationBar() )
    }
    
    ///https://stackoverflow.com/a/58606176/9273242
    ///swiftui 2.0 Solution to different corners radius
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }

}

///View modifier to hide navigation bar
///https://stackoverflow.com/a/60492133/9273242
struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}

extension UserDefaults {
    
    ///Check if value in UD exists
    func valueExists(forKey key: String) -> Bool {
        return object(forKey: key) != nil
    }
    
    ///Get value from UD
    func getValue(forKey key: Keys) -> Any? {
        return object(forKey: key.rawValue)
    }
    
    ///User Data in UserDefaults
    enum Keys: String, CaseIterable {
        case email
        case appKey
        case uID
        case tokens
        case vip
        case disponibility
    }

    ///Set userdata to userdefaults from provided struct
    func setUserData(data: DBUser) {
        set(data.email, forKey: Keys.email.rawValue)
        set(data.appKey, forKey: Keys.appKey.rawValue)
        set(data.userID, forKey: Keys.uID.rawValue)
        set(data.tokens, forKey: Keys.tokens.rawValue)
        set(data.vip, forKey: Keys.vip.rawValue)
    }

    ///Set default disponibility to userdefaults
    func setDefaultDisponibility(info: DisponibilityInfo) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(info) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: Keys.disponibility.rawValue)
        }
    }
    
    ///Delete UserDefaults data
    func deleteData() {
        Keys.allCases.forEach { removeObject(forKey: $0.rawValue) }
    }

}

extension Calendar {
    
    ///Number of days between two dates
    func numberOfDaysBetween(from: Date, to: Date) -> Int {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to)
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
        
        return numberOfDays.day!
    }
    
 
    ///Number of minutes between two dates
    static func minutesBetween(from: Date, to: Date) -> Int {
        let timeComponents = current.dateComponents([.hour, .minute], from: from)
        let nowComponents = current.dateComponents([.hour, .minute], from: to)
        return current.dateComponents([.minute], from: timeComponents, to: nowComponents).minute!
    }
    
 
    ///Get name string of the day
    static func dayOfTheWeek(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: date)
    }
 
    ///Get hours string from date
    static func getHoursString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    ///Get day string from date
    static func getDayString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd. MM. yyyy"
        return dateFormatter.string(from: date)
    }
    
    ///Get day and hours string from date
    static func getDayHoursString(date: Date?) -> String?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd. MM. yyyy HH:mm:ss"
        if let dt = date {
            return dateFormatter.string(from: dt)
        }
        return nil
    }
    
    ///Get name of the day from date
    static func dayOfTheMonth(date: Date) -> String{
        let components = current.dateComponents([.day], from: date)
        if let day = components.day {
            return String(day)
        }
        return ""
    }
    
    ///Get day string from date
    static func areTheSameDay(first: Date,second: Date) -> Bool{
        return current.isDate(first, equalTo: second, toGranularity: .day)
    }
    
    ///Is date in the specified month
    static func areTheSameMonth(date: Date, month: Int) -> Bool{
        return  current.component(.month, from: date) == month
    }
    
    ///Get date of todays end
    static func getDayEnd() -> Date{
        return  Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date()) ?? Date()
    }
    
}



