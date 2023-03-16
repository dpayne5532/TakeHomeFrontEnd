//
//  ContentView.swift
//  CELTakeHomeProject
//
//  Created by Dan Payne on 3/15/23.
//

import SwiftUI


class Change: ObservableObject {
  @Published var hundreds: Int = 1
  @Published var fifties: Int = 1
  @Published var twenties: Int = 4
  @Published var tens: Int = 1
  @Published var fives: Int = 1
  @Published var twos: Int = 0
  @Published var ones: Int = 2
  @Published var quarters: Int = 0
  @Published var dimes: Int = 0
  @Published var nickels: Int = 0
  @Published var pennies: Int = 0
}






struct ContentView: View {
  
  let changeURL = "https://frosty-glade-1979.fly.dev/"
  
  @State private var amount:Float = 198.15
  @ObservedObject var changeData = Change()
  
  private let numberFormatter: NumberFormatter
  
  init() {
    numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .currency
    numberFormatter.maximumFractionDigits = 2
  }
  
  var body: some View {
    VStack {
      VStack {
        HStack {
          Image("hundreds\(changeData.hundreds)")
            .padding(.leading)
          Image("fifties\(changeData.fifties)")
            .padding()
          Image("twentie\(changeData.twenties)")
            .padding(.trailing)
        }
        HStack {
          Image("tens\(changeData.tens)")
            .padding(.leading)
          Image("fives\(changeData.fives)")
            .padding()
          Image("one\(changeData.ones)")
            .padding(.trailing)
          
          
        }
      }
      
      Spacer()
      HStack {
        
        TextField("amount", value: $amount, formatter: numberFormatter)
          .font(.title)
          .bold()
          .multilineTextAlignment(.center)
        
      }
      
      Button(action: doStuff) {
        Text("Change!")
        
          .frame(width: 150, height: 80)
          .background(.blue)
          .foregroundColor(.white)
          .bold()
          .font(.title2)
          .clipShape(Capsule())
        
      }
    }
    .padding()
  }
  
  
  func fetchQuote(amount: Float) {
    let urlString = "\(changeURL)\(amount)"
    print("urlString: ", urlString)
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
        self.changeData.hundreds = decodedData.hundreds ?? 0
        self.changeData.fifties = decodedData.fifties ?? 0
        self.changeData.twenties = decodedData.twenties ?? 0
        self.changeData.tens = decodedData.tens ?? 0
        self.changeData.fives = decodedData.fives ?? 0
        self.changeData.ones = decodedData.ones ?? 0
        
        
        self.changeData.dimes = decodedData.dimes ?? 0
        print("hundreds: ", self.changeData.hundreds)
        print("Fifties: ", self.changeData.fifties)
        print(self.changeData.hundreds)
        
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func doStuff() {
    
    DispatchQueue.global(qos: .userInitiated).async {
       fetchQuote(amount: amount)
    }
  }
  
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
