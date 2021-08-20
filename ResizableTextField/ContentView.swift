//
//  ContentView.swift
//  ResizableTextField
//
//  Created by 김정민 on 2021/08/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    @State private var txt: String = ""
    @State private var height: CGFloat = 0
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        VStack {
            HStack {
                Text("Chats")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
            }
            .padding()
            .background(Color.white)
            
            ScrollView(.vertical, showsIndicators: false) {
                // Chat Content
                Text("")
            }
            
            HStack(spacing: 8) {
                ResizableTF(txt: self.$txt, height: self.$height)
                    .frame(height: self.height < 150 ? self.height : 150)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(15)
                
                Button(action: {
                    
                }, label: {
                    Image(systemName: "paperplane")
                        .resizable()
                        .frame(width: 24, height: 20)
                        .foregroundColor(.black)
                        .padding(10)
                })
                .background(Color.white)
                .clipShape(Circle())
            }
            .padding(.horizontal)
            
        }
//        .padding(.bottom, self.keyboardHeight)
        .padding(.bottom)
        .background(Color.black.opacity(0.06).edgesIgnoringSafeArea(.bottom))
        .onTapGesture {
            UIApplication.shared.windows.first?.rootViewController?.view.endEditing(true)
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main) { (data) in
                let height1 = data.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
                self.keyboardHeight = height1.cgRectValue.height - 20
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main) { _ in
                self.keyboardHeight = 0
            }
        }
    }
}

struct ResizableTF: UIViewRepresentable {
    
    @Binding var txt: String
    @Binding var height: CGFloat
    
    func makeCoordinator() -> Coordinator {
        return ResizableTF.Coordinator(parent1: self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isEditable = true
        view.isScrollEnabled = true
        view.text = "Enter Message"
        view.font = .systemFont(ofSize: 18)
        view.textColor = .gray
        view.backgroundColor = .clear
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        DispatchQueue.main.async {
            self.height = uiView.contentSize.height
        }
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: ResizableTF
        
        init(parent1: ResizableTF) {
            parent = parent1
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if self.parent.txt == "" {
                textView.text = ""
                textView.textColor = .black
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if self.parent.txt == "" {
                textView.text = "Enter Message"
                textView.textColor = .gray
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.height = textView.contentSize.height
                self.parent.txt = textView.text
            }
        }
    }
}
