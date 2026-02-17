import SwiftUI
import RealityKit

class ARResumeEntity {
    static func createResumeEntity(for resume: Resume) -> ModelEntity {
        // Create a parent entity to hold everything
        let parentEntity = ModelEntity()
        
        // 1. Background Plane (Glass Effect)
        let planeMesh = MeshResource.generatePlane(width: 0.6, depth: 0.4, cornerRadius: 0.02)
        var material = SimpleMaterial(color: .black.withAlphaComponent(0.8), isMetallic: false)
        material.roughness = 0.2
        let background = ModelEntity(mesh: planeMesh, materials: [material])
        background.transform.rotation = simd_quatf(angle: -.pi/2, axis: [1, 0, 0]) // Rotate to face camera
        parentEntity.addChild(background)
        
        // 2. Name Text
        let nameMesh = MeshResource.generateText(
            resume.fullName,
            extrusionDepth: 0.01,
            font: .systemFont(ofSize: 0.05, weight: .bold),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byTruncatingTail
        )
        let nameMaterial = SimpleMaterial(color: .white, isMetallic: false)
        let nameEntity = ModelEntity(mesh: nameMesh, materials: [nameMaterial])
        // Center text estimation (approximate width based on char count)
        let nameWidth = Float(resume.fullName.count) * 0.025
        nameEntity.position = [-nameWidth/2, 0.1, 0.01] // Slightly in front of plane
        background.addChild(nameEntity) // Attach to background
        
        // 3. Title Text
        let titleText = resume.experience.first?.title ?? "Professional"
        let titleMesh = MeshResource.generateText(
            titleText,
            extrusionDepth: 0.005,
            font: .systemFont(ofSize: 0.025, weight: .medium),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byTruncatingTail
        )
        let titleMaterial = SimpleMaterial(color: .cyan, isMetallic: false)
        let titleEntity = ModelEntity(mesh: titleMesh, materials: [titleMaterial])
        let titleWidth = Float(titleText.count) * 0.012
        titleEntity.position = [-titleWidth/2, 0.04, 0.01]
        background.addChild(titleEntity)
        
        // 4. Contact Text
        let contactText = "\(resume.email) • \(resume.phone.isEmpty ? "No Phone" : resume.phone)"
        let contactMesh = MeshResource.generateText(
            contactText,
            extrusionDepth: 0.002,
            font: .systemFont(ofSize: 0.015, weight: .regular),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byTruncatingTail
        )
        let contactMaterial = SimpleMaterial(color: .gray, isMetallic: false)
        let contactEntity = ModelEntity(mesh: contactMesh, materials: [contactMaterial])
        let contactWidth = Float(contactText.count) * 0.007
        contactEntity.position = [-contactWidth/2, -0.05, 0.01]
        background.addChild(contactEntity)
        
        return parentEntity
    }
}
