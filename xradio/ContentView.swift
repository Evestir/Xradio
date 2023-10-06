//
//  ContentView.swift
//  xradio
//
//  Created by vesolis on 2023/10/01.
//

import SwiftUI

class ImageLoader: ObservableObject {
    @Published var image: NSImage?
    
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data {
                DispatchQueue.main.async {
                    self.image = NSImage(data: data)
                }
            }
        }.resume()
    }
}

struct ContentView: View {
    @ObservedObject var imageLoader = ImageLoader()
    @State private var queue: [Music] = []
    @State private var lastQueue: [Music] = []
    @State var LinkUrl: String = ""
    @State var isPlaying:Bool = false
    var body: some View {
        VStack {
            ScrollView {
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
            }
            Spacer()
            ZStack {
                HStack {
                    Button {
                        isPlaying = !isPlaying
                        
                        if (isPlaying) {
                            playFromUrl(url: "https://icy.jpbgdigital.com/CIBH.aac?player_type=tunein&np=1")
                        } else {
                            player.pause()
                        }
                        
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
                        Image(systemName: isPlaying ?  "pause.fill" : "play.fill").contentTransition(.symbolEffect(.replace.downUp.byLayer)).padding()
                    }.padding().controlSize(.extraLarge)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(width: 480.0, height: 600.0)
    }
}
