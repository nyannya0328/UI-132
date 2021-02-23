//
//  UI_132App.swift
//  UI-132
//
//  Created by にゃんにゃん丸 on 2021/02/23.
//

import SwiftUI
import AVKit
@main
struct UI_132App: App {
    
    @UIApplicationDelegateAdaptor(AppDele.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDele : NSObject,UIApplicationDelegate{
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let session = AVAudioSession.sharedInstance()
        
        do{
            
            try session.setCategory(.playback,mode: .default)
            
        }
        catch{
            fatalError("Faile")
            
            
        }
        
        do{
            
            
            try session.setActive(true)
        }
        
        catch{
            
            fatalError("Faile")
        }
        
        return true
        
    }
}
