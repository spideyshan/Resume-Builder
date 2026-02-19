import SwiftUI
import RealityKit
import ARKit
import CoreImage.CIFilterBuiltins

struct ARBusinessCardView: View {
    let resume: Resume
    @State private var showingAR = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Header
            Text("Digital Business Card")
                .font(.title2.bold())
                .padding(.top)
            
            // QR Code Section
            VStack {
                if let qrImage = generateQRCode(from: vCardString(for: resume)) {
                    Image(uiImage: qrImage)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(radius: 5)
                }
                
                Text("Scan to Save Contact")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, 8)
            }
            

            
            Spacer()
        }
    }
    
    // MARK: - Helpers
    func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            // Scale up for sharpness
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = outputImage.transformed(by: transform)
            
            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
    
    func vCardString(for resume: Resume) -> String {
        return """
        BEGIN:VCARD
        VERSION:3.0
        FN:\(resume.fullName)
        TITLE:\(resume.experience.first?.title ?? "Professional")
        TEL:\(resume.phone)
        EMAIL:\(resume.email)
        URL:\(resume.linkedinURL?.absoluteString ?? "")
        END:VCARD
        """
    }
}

// MARK: - AR View Container
struct ARResumeView: View {
    let resume: Resume
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ARViewContainer(resume: resume)
                .edgesIgnoringSafeArea(.all)
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding()
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    let resume: Resume
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Config
        let config = ARWorldTrackingConfiguration()
        // No plane detection needed for HUD style
        arView.session.run(config)
        
        // Add Floating Resume Entity (Camera Anchor)
        // Positioned 0.5 meters in front of camera
        let anchor = AnchorEntity(.camera)
        let resumeEntity = ARResumeEntity.createResumeEntity(for: resume)
        
        // Adjust position: 0.5m forward (-Z), slightly up if needed
        resumeEntity.position = [0, 0, -0.5]
        
        // Rotation: Plane defaults to XZ (flat). Rotate -90 deg X to face user.
        // We already rotate in createResumeEntity, so just attach.
        
        anchor.addChild(resumeEntity)
        arView.scene.anchors.append(anchor)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}
