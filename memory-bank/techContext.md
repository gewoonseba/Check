# Technical Context

## Technologies Used

### Core Frameworks
- **SwiftUI**: Primary UI framework
- **Swift Data**: Persistence framework
- **CloudKit**: For future sync capabilities
- **WidgetKit**: For home screen widgets

### iOS Features
- **App Groups**: For widget data sharing
- **Share Extensions**: For exporting progress cards
- **Haptic Feedback**: For satisfying completion interactions
- **Deep Linking**: For widget-to-app navigation

### Development Tools
- **Xcode**: Primary development environment
- **SwiftLint**: For code style enforcement
- **SwiftFormat**: For consistent formatting
- **XCTest**: For unit and UI testing

## Development Setup

### Project Configuration
- **Deployment Target**: iOS 17.0+
- **Device Support**: iPhone and iPad
- **Orientation**: Portrait only (iPhone), Portrait and Landscape (iPad)
- **App Groups**: group.com.gewoonseba.Check
- **Bundle Identifier**: com.gewoonseba.Check

### Development Workflow
- **Version Control**: Git with GitHub
- **Branching Strategy**: Feature branches with pull requests
- **CI/CD**: GitHub Actions for automated testing
- **Code Review**: Required for all PRs
- **Documentation**: In-code documentation with DocC

## Technical Constraints

### Platform Constraints
- **iOS 17 Requirement**: Using Swift Data requires iOS 17+
- **Widget Limitations**: Limited interactivity in widgets
- **CloudKit Limitations**: Sync conflicts and offline handling
- **App Size**: Keep under 30MB for easy installation

### Performance Constraints
- **Widget Performance**: Must render quickly with limited resources
- **Animation Smoothness**: Maintain 60fps for all animations
- **Battery Usage**: Minimize background processing
- **Launch Time**: Under 2 seconds on supported devices

## Dependencies

### First-Party Dependencies
- SwiftUI
- Swift Data
- CloudKit
- WidgetKit

### Third-Party Dependencies
- None initially (minimize dependencies)

### Future Considerations
- May add limited dependencies for specific features:
  - Charts/visualization libraries if needed
  - CSV parsing for import/export
  - Testing utilities

## Accessibility Requirements

- **VoiceOver Support**: All screens must be fully compatible with VoiceOver
- **Dynamic Type**: Support for all text elements
- **Color Contrast**: Sufficient contrast for all UI elements
- **Reduce Motion**: Support for users with motion sensitivity
- **Voice Control**: Compatibility for motor-limited users