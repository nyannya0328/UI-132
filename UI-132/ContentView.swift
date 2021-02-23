//
//  ContentView.swift
//  UI-132
//
//  Created by にゃんにゃん丸 on 2021/02/23.
//

import SwiftUI
import AVKit
struct ContentView: View {
    var body: some View {
        
        NavigationView{
            
            Home()
               
                .navigationTitle("")
                .navigationBarHidden(true)
                .preferredColorScheme(.dark)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View  {
    
    @State var audioplayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
    @StateObject var model = alubum_data()
    @State var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    @State var animatedvalue : CGFloat = 55
    @State var MaxWith = UIScreen.main.bounds.width / 2.2
    @State var time : Float = 0
    var body: some View{
        
        VStack{
            
            HStack{
                
                VStack(alignment: .leading, spacing: 8, content: {
                    Text(model.title)
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    HStack(spacing:5){
                        
                        Text(model.artist)
                            .font(.callout)
                            .fontWeight(.semibold)
                        
                        Text(model.type)
                            .font(.caption2)
                            .fontWeight(.semibold)
                    }
                    
                    
                })
                
                
                Spacer()
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "suit.heart.fill")
                        .foregroundColor(.white)
                        .frame(width: 45, height: 45)
                        .background(Color.red)
                        .clipShape(Circle())
                })
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "bookmark.fill")
                        .foregroundColor(.white)
                        .frame(width: 45, height: 45)
                        .background(Color.red)
                        .clipShape(Circle())
                        .padding(.leading,10)
                })
                
            }
            .padding()
            
           
            Spacer(minLength: 0)
            
            
            if model.artwork.count != 0{
                
                Image(uiImage: UIImage(data: model.artwork)!)
                    .resizable()
                    .frame(width: 250, height: 250)
                    .cornerRadius(15)
                
                
            }
            
            ZStack{
                
                ZStack{
                    
                    
                    Circle()
                        .fill(Color.white.opacity(0.05))
                    
                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: animatedvalue / 2, height: animatedvalue / 2)
                }
                .frame(width: animatedvalue, height: animatedvalue)
                
                Button(action: play, label: {
                    Image(systemName: model.isplaying ? "pause.fill" : "play.fill")
                        .frame(width: 55, height: 55)
                        .background(Color.white)
                        .clipShape(Circle())
                })
                
            }
            .frame(width: MaxWith, height: MaxWith)
            .padding(.top,30)
            
            Slider(value: Binding(get: {time}, set: { (newValue) in
                
                time = newValue
                audioplayer.currentTime = Double(time) * audioplayer.duration
                audioplayer.play()
                
            }))
            .padding()
            
            Spacer(minLength: 0)
           
        }
       
        .onReceive(timer, perform: { _ in
            
            if audioplayer.isPlaying{
                audioplayer.updateMeters()
                model.isplaying = true
                print(audioplayer.currentTime)
                
                time = Float(audioplayer.currentTime / audioplayer.duration)
                startAnimation()
            }
            else{
                
                model.isplaying = false
            }
            
        })
        .onAppear(perform: {
            getAudiodata()
        })
    }
    func play(){
        
        if audioplayer.isPlaying{
            
            audioplayer.pause()
        }
        else{
            audioplayer.play()
        }
        
        
        
    }
    
    func getAudiodata(){
        
        
        audioplayer.isMeteringEnabled = true
        
        let Asset = AVAsset(url:audioplayer.url!)
        Asset.metadata.forEach { (meta) in
            switch(meta.commonKey?.rawValue){
            
            case "artwork" : model.artwork = meta.value == nil ? UIImage(named: "Any Sample Pic")!.pngData()! : meta.value as! Data
            case "artist" : model.artist = meta.value == nil ? "" : meta.value as! String
            case "type" : model.type = meta.value == nil ? "" : meta.value as! String
            case "title" : model.title = meta.value == nil ? "" : meta.value as! String
                
            
            default : ()
            
            
            }
        }
        
    }
    
    func startAnimation(){
        
        var power : Float = 0
        
        for i in 0..<audioplayer.numberOfChannels{
            
            power += audioplayer.averagePower(forChannel: i)
        }
        let value = max(0, power + 55)
        
        let animated = CGFloat(value) * (MaxWith / 55)
        
        withAnimation(.linear(duration: 0.01)){
            
            
            self.animatedvalue = animated + 55
        }
        
    }
    
}

let url = Bundle.main.path(forResource: "audio_490bfdaf28", ofType: "mp3")

class alubum_data : ObservableObject{
    @Published var isplaying = false
    @Published var artwork = Data(count: 0)
    @Published var title = ""
    @Published var type = ""
    @Published var artist = ""
    
    
}
