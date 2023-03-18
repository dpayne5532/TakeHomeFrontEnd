//
//  ContentView.swift
//  CELTakeHomeProject
//
//  Created by Dan Payne on 3/15/23.
//

import SwiftUI


class Change: ObservableObject {
  @Published var hundreds: Int = 0
  @Published var fifties: Int = 0
  @Published var twenties: Int = 0
  @Published var tens: Int = 0
  @Published var fives: Int = 0
  @Published var twos: Int = 0
  @Published var ones: Int = 0
  @Published var quarters: Int = 0
  @Published var dimes: Int = 0
  @Published var nickels: Int = 0
  @Published var pennies: Int = 0
}


struct ContentView: View {
  
  let changeURL = "https://frosty-glade-1979.fly.dev/"
  @FocusState private var focusedField: Field?
  @State private var amount:Double = 150.00
  @State private var showSheet = false
  @ObservedObject var changeData = Change()
  
  private let numberFormatter: NumberFormatter
  
  init() {
    numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .currency
    numberFormatter.maximumFractionDigits = 2
  }
  
  enum Field: Hashable {
    case myField
  }
  
  var body: some View {
    ZStack {
      //      Color(.gray)
      Image("background2")
        .resizable()
        .scaledToFill()
        .ignoresSafeArea()
      VStack {
        VStack {
          
          HStack {
            VStack {
              Text(changeData.hundreds < 2 ? "" : "\(changeData.hundreds)x")
                .font(.title)
                .bold()
              Image(changeData.hundreds == 0 ? "" : "hundreds1")
                .padding(.leading)
              
            }
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
          
          HStack {
            Image("quarters\(changeData.quarters)")
              .padding(.leading)
            Image("dimes\(changeData.dimes)")
              .padding()
            Image("nickels\(changeData.nickels)")
              .padding()
            Image("pennies\(changeData.pennies)")
              .padding(.trailing)
            
          }
          .padding()
          
          // end inner VStack Here
        }
        .padding()
        
        Spacer()
        
        HStack {
          
          Text("$\(amount, specifier: "%.2f")")
            .font(.title)
            .foregroundColor(.black)
          
          VStack {
            
            Stepper("Dollars:", onIncrement: {
              amount += 1
            }, onDecrement: {
              amount -= 1
            })
            .frame(width: 160)
            .foregroundColor(.black)
            
            Stepper("Cents:", onIncrement: {
              amount += 0.01
            }, onDecrement: {
              amount -= 0.01
            })
            .frame(width: 160)
            .foregroundColor(.black)
            
            
          }.padding()
          
          
        }
        HStack {
          Spacer()
          Spacer()
          Button(action: doStuff) {
            ZStack(alignment: .leading) {
              
              Text("Make Change")
                .frame(width: 200, height: 60)
                .background(.blue)
                .foregroundColor(.white)
                .bold()
                .font(.title2)
                .clipShape(Capsule())
              
            }
          }
          
          Spacer()
            .frame(width: 25)
          
          Button(action: toggleSheet) {
            Image(systemName: "info.circle")
              .foregroundColor(.black)
          }.sheet(isPresented: $showSheet) {
            ZStack {
              Color("newGray")
                .ignoresSafeArea()
              VStack {
                Image("meee")
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 158, height: 150)
                  .clipShape(Circle())
                  .overlay( Circle().stroke(Color.black, lineWidth: 5))
                  
                
                Text("This app was built as a take home project for \nCalifornia Eastern Laboratories")
                Text("")
                Text("Thank you for your consideration!")
                  .presentationDetents([.medium, .large])
                  .presentationDragIndicator(.hidden)
                Text("Dan Payne")
                Text("dpaynebills@gmail.com")
                Text("https://danpayne.info")
                Text("(605) 760-7817")
                
              }
            }
          }
          
          Spacer()
            
          
        }
      }
      .padding()
      .preferredColorScheme(.light)
      
    }
  }
  
  func toggleSheet() {
    showSheet.toggle()
  }
  
  
  func fetchQuote(amount: Double) {
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
        self.changeData.quarters = decodedData.quarters ?? 0
        self.changeData.dimes = decodedData.dimes ?? 0
        self.changeData.nickels = decodedData.nickels ?? 0
        self.changeData.pennies = decodedData.pennies ?? 0
        
        
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
