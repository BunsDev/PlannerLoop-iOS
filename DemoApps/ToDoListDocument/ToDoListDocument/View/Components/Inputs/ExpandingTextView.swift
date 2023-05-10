//
//  GrowingTextField.swift
//  ToDoListDocument
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct  ExpandingTextView : View {
    //Textfield that vertically grows with added content
    @Binding var text: String
    let minHeight: CGFloat = 40
    @State private var textViewHeight: CGFloat?

    var body: some View {
        TextView(text: $text, textDidChange: self.textDidChange)
            .frame(height: textViewHeight ?? minHeight)
    }

    private func textDidChange(_ textView: UITextView) {
        self.textViewHeight = max(textView.contentSize.height, minHeight)
    }
}


struct TextView: UIViewRepresentable {
    typealias UIViewType = UITextView

    @Binding var text: String
    let textDidChange: (UITextView) -> Void
    var textStyle: UIFont.TextStyle = .body


    func makeUIView(context: Context) -> UITextView {
        //initializing a text view with the preferred text style
        let textView = UITextView()
        textView.isSelectable = true
        textView.backgroundColor = UIColor(named: "Background")
        textView.font = UIFont.preferredFont(forTextStyle: textStyle)
        textView.autocapitalizationType = .sentences
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.delegate = context.coordinator
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = self.text

        DispatchQueue.main.async {
            self.textDidChange(uiView)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, textDidChange: textDidChange)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        //Bridge between UIKit and SwiftUI
        
        @Binding var text: String
        let textDidChange: (UITextView) -> Void

        init(text: Binding<String>, textDidChange: @escaping (UITextView) -> Void) {
            self._text = text
            self.textDidChange = textDidChange
        }

        func textViewDidChange(_ textView: UITextView) {
            self.text = textView.text
            self.textDidChange(textView)
        }
    }
}


struct GrowingTextField_Previews: PreviewProvider {
    static var previews: some View {
        NewEditTask()
    }
}
