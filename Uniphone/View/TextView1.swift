//
//  TextView1.swift
//  Uniphone
//
//  Created by Julia Komorowska on 25/04/2022.
//

import SwiftUI

struct TextView1: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        return TextView1.Coordinator(parent: self)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    
    @Binding var text : String
    @Binding var height : CGFloat
    var fontSize : CGFloat
    func makeUIView(context: Context) -> some UIView {
        let view = UITextView()
        view.backgroundColor = .clear
        view.font = .systemFont(ofSize: fontSize)
        view.text = text
        view.delegate = context.coordinator
        return view
    }
    class Coordinator : NSObject,UITextViewDelegate{
        var parent: TextView1
        init(parent: TextView1){
            self.parent = parent
            
        }
        func textViewDidChange(_ textView: UITextView) {
            let height = textView.contentSize.height
            self.parent.height = height
            self.parent.text = textView.text
        }
        func textViewDidBeginEditing(_ textView: UITextView) {
            let height = textView.contentSize.height
            self.parent.height = height
        }
    }
    
}

