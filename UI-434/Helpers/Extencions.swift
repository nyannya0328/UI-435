//
//  Extencions.swift
//  UI-434
//
//  Created by nyannyan0328 on 2022/01/24.
//

import SwiftUI

extension View{
    
    
    
    func ConvertScrollView<Content : View>(@ViewBuilder content : @escaping()->Content) -> UIScrollView{
        
        let scroll = UIScrollView()
        
        
        let hostingController = UIHostingController(rootView: content()).view!
        
        hostingController.translatesAutoresizingMaskIntoConstraints = false
        
        
        let contains = [
        
            hostingController.topAnchor.constraint(equalTo: scroll.topAnchor),
            hostingController.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            hostingController.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            hostingController.trailingAnchor.constraint(equalTo: scroll.trailingAnchor),
            
            hostingController.widthAnchor.constraint(equalToConstant: getRect().width)
        
        
        ]
        
        scroll.addSubview(hostingController)
        scroll.addConstraints(contains)
        
        scroll.layoutIfNeeded()
        
        
        
        
        
        return scroll
        
        
    }
    
    
    func exportPDF<Content : View>(@ViewBuilder content : @escaping()->Content,cometion : @escaping(Bool,URL?) -> ()){
        
        
        let doucmentDirectry = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        
        let outPutFileURL = doucmentDirectry.appendingPathComponent("YOYRENAM\(UUID().uuidString).pdf")
        
        let pdfView = ConvertScrollView {
            
            
            content()
            
        }
        
        
        pdfView.tag = 1009
        
        let size = pdfView.contentSize
        
        pdfView.frame = CGRect(x: 0, y: getSafeArea().top, width: size.width, height: size.height)
        
        
        getRootView().view.insertSubview(pdfView, at: 0)
        
        
        let rendererd = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        
        do{
            
            
            
            try rendererd.writePDF(to: outPutFileURL, withActions: {context in
                
                
                context.beginPage()
                pdfView.layer.render(in: context.cgContext)
                
                
                
                
            })
            
            
            cometion(true, outPutFileURL)

            
            
        }
        
        catch{
            
            
            cometion(false, nil)
            
            print(error.localizedDescription)
          
        }
        
        getRootView().view.subviews.forEach { view in

            if view.tag == 1009{

                view.removeFromSuperview()

            }

        }

            
            
        }
        
    
    func getRect()->CGRect{
        
        return UIScreen.main.bounds
    }
    
    func Hleading()->some View{
        
        self
            .frame(maxWidth:.infinity,alignment: .leading)
    }
    
    func HTrailing()->some View{
        
        self
            .frame(maxWidth:.infinity,alignment: .trailing)
    }
    
    func HCenter()->some View{
        
        self
            .frame(maxWidth:.infinity)
    }
    
    func VTop() -> some View{
        
        
        self
            .frame(maxHeight:.infinity,alignment: .top)
        
        
    }
    
    func VBottome() -> some View{
        
        
        self
            .frame(maxHeight:.infinity,alignment: .bottom)
        
        
    }
    
    
    func getRootView() -> UIViewController{
        
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            
            return .init()
        }
        
        guard let rootView = screen.windows.first?.rootViewController else{
            
            
            return .init()
        }
        
        return rootView
        
        
        
    }
    
    func getSafeArea() -> UIEdgeInsets{
        
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else{
            
            
            return .zero
        }
        
        return safeArea
        
        
        
    }
    
    
    
    
    
}

        
        
        
        
    
    
    
  
