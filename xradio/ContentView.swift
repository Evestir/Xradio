//
//  ContentView.swift
//  xradio
//
//  Created by vesolis on 2023/10/01.
//

import SwiftUI

struct ContentView: View {
    @State private var queue: [Music] = []
    @State private var lastQueue: [Music] = []
    @State var LinkUrl:String = ""
    @State var currentPlayingMusic:Music = Music(name: "", author: "", coverImage: "")
    @State var isPlaying:Bool = false
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: currentPlayingMusic.coverImage), content: { image in
                image.resizable().ignoresSafeArea().blur(radius: 8).opacity(0.8).blendMode(.hardLight).transition(.slide).animation(.easeInOut)
            }, placeholder: { Image("stationCover").resizable().ignoresSafeArea().opacity(0.8).blendMode(.hardLight).transition(.slide).animation(.easeInOut) })
            
            VStack (alignment: .center) {
                Spacer()
                AsyncImage(url: URL(string: "https://media.socastsrm.com/uploads/station/716/fbShare.png?"), content: { image in
                    image.resizable().scaledToFit().colorInvert().shadow(radius: 10).musicBox()
                }, placeholder: { ProgressView().musicBox() })
                Spacer()
                HStack {}.padding(.bottom, 70)
            }.ignoresSafeArea()
            
            /*ScrollView {
                ForEach($queue, id: \.self) { item in
                    HStack {
                        AsyncImage(url: URL(string: item.coverImage.wrappedValue))
                        Spacer()
                        VStack {
                            Text(item.name.wrappedValue).padding()
                            Text(item.author.wrappedValue)
                        }
                        Spacer()
                    }
                }
            }*/
            
            VStack {
                Spacer()
                HStack {
                    Image(systemName: "dot.radiowaves.left.and.right").resizable().frame(width: 12, height: 12).symbolEffect(.bounce.down.byLayer, options: .repeating, value: isPlaying).padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 0))
                    Text(currentPlayingMusic.name.lowercased().capitalized).fontWeight(.semibold).padding(.leading, 4)
                    Image(systemName: "music.mic").resizable().frame(width: 10, height: 10)
                    Text(currentPlayingMusic.author.lowercased().capitalized).fontWeight(.thin)
                    Spacer()
                }.background(.regularMaterial).border(Color.primary.opacity(0.1))
                HStack {}
                HStack {
                    Button {
                        isPlaying = !isPlaying
                        
                        if (isPlaying) {
                            playFromUrl(uri: "https://icy.jpbgdigital.com/CIBH.aac?player_type=tunein&np=1")
                        } else {
                            player.pause()
                        }
                        
                        currentPlayingMusic = currentMusic
                        print(isPlaying)
                        fetchFromTheBeach { result in
                            switch result {
                            case .success(let musicArray):
                                // Handle the success case with the musicArray
                                queue = musicArray
                            case .failure(let error):
                                // Handle the error case with the error
                                print("Error: \(error)")
                            }
                        }
                    } label: {
                        Image(systemName: isPlaying ?  "square.fill" : "play.fill").resizable().contentTransition(.symbolEffect(.replace.downUp.byLayer)).scaledToFill().frame(width: 25, height: 25)
                    }.padding(.trailing, 20).padding(.vertical, 25).padding(.leading, 25).cornerRadius(3.0).buttonStyle(.plain).shadow(color: Color(red: 35, green: 35, blue: 35).opacity(0.2), radius: 2)
                    
                    VStack (alignment: .leading) {
                        Text("88.5 The Beach").fontWeight(.bold)
                        Text("Oceanside's Soft Rock").font(.system(size: 10)).fontWeight(.light)
                    }
                    Spacer()
                }.background(.thickMaterial)
            }
        }.background(xradio.blur().ignoresSafeArea()).onAppear(perform: {
            fetchFromTheBeach { result in
                switch result {
                case .success(let musicArray):
                    // Handle the success case with the musicArray
                    queue = musicArray
                    currentPlayingMusic = currentMusic
                case .failure(let error):
                    // Handle the error case with the error
                    print("Error: \(error)")
                }
            }
        })
    }
}

struct blur: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let effectView = NSVisualEffectView()
        effectView.state = .active
        return effectView
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().frame(width: 480, height: 480)
    }
}
