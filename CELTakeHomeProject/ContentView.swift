//
//  ContentView.swift
//  CELTakeHomeProject
//
//  Created by Dan Payne on 3/15/23.
//

import SwiftUI


class Change: ObservableObject {
  @Published var hundreds: Int?
  @Published var fifties: Int?
  @Published var twenties: Int?
  @Published var tens: Int?
  @Published var fives: Int?
  @Published var twos: Int?
  @Published var ones: Int?
  @Published var quarters: Int?
  @Published var dimes: Int?
  @Published var nickels: Int?
  @Published var pennies: Int?
}






struct ContentView: View {
  
  let changeURL = "http://localhost:3010/"
  
 @ObservedObject var changeData = Change()
  
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
  
  
  func fetchQuote(amount: Int) {
    let urlString = "\(changeURL)"
    performRequest(urlString: urlString)
  }
  
  func performRequest(urlString: String) {
    if let url = URL(string: urlString) {
      let session = URLSession(configuration: .default)
      let task = session.dataTask(with: url) { (data, response, error) in
        if error != nil {
          print(error!)
          return
        }
        
        if let safeData = data {
          self.parseJSON(changeData: safeData)
        }
        
      }
      task.resume()
    }
  }
  
  func parseJSON(changeData: Data) {
    let decoder = JSONDecoder()
    do {
      let decodedData = try decoder.decode(ChangeData.self, from: changeData)
      
      DispatchQueue.main.async {
        self.changeData.dimes = decodedData.dimes
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func doStuff() {
    DispatchQueue.global(qos: .userInitiated).async {
      // fetchQuote(amount: amount)
    }
  }
  
  
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
