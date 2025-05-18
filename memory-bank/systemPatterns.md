# System Patterns

## System Architecture

### Simplicity-First Approach
- **Minimize Abstraction Layers**: Use SwiftUI's built-in patterns without additional architectural patterns
- **Leverage Apple's Frameworks**: Rely on SwiftUI, Swift Data, and CloudKit directly
- **Avoid Premature Optimization**: Start with the simplest implementation that works
- **Progressive Enhancement**: Add complexity only when needed for specific features

### SwiftUI-Native Architecture
- **View-Based Organization**: Structure around views rather than traditional MVC/MVVM
- **Declarative Data Flow**: Use SwiftUI's data flow mechanisms (@State, @Binding, @Environment)
- **Composition Over Inheritance**: Build complex views from simple, reusable components
- **Preview-Driven Development**: Design components with previews for rapid iteration

## Key Technical Decisions

### Swift Data Schema Design
- **Decision Made**: We'll use a simplified schema with just the essential fields:
  - **Habit Model:**
    - id: UUID (primary key)
    - name: String
    - frequency: Enum (daily, weekly, monthly)
    - isArchived: Boolean
    - createdAt: Date
    - One-to-many relationship with completions
  - **Completion Model:**
    - id: UUID (primary key)
    - date: Date (when the habit was completed)
    - Many-to-one relationship with habit

### CloudKit Container Setup
- **Decision Made**: We'll take a phased approach to CloudKit integration:
  - **Phase 1:** Start with local-only storage using Swift Data
    - Focus on core functionality first
    - Structure the app to be "sync-ready" from the beginning
    - Use UUIDs for all identifiers to ensure future compatibility
  - **Phase 2:** Add CloudKit sync later
    - Container identifier: iCloud.com.gewoonseba.Check
    - Use private database for user data privacy
    - Let Swift Data handle schema creation

### State Management Strategy
- **Decision**: Minimalist state management with deferred app-level state
- **Primary State Approach:**
  - Swift Data for all persistent data (habits, completions)
    - Access via @Query and @Environment(\.modelContext)
    - Use for all core domain data
  - View-Specific State for UI concerns
    - Use @State for view-internal state (animations, form inputs, etc.)
    - Use @Binding for parent-child state sharing
    - Use @FocusState for managing input focus
  - Computed Properties for derived data
    - Calculate filtered lists, statistics, and visualizations on-demand
    - Avoid storing redundant state that can be derived

### Navigation Approach
- **Decision**: Fluid, single-flow navigation without TabView
- **Primary Structure:**
  - Home Screen as the central hub:
    - Shows ongoing habits in a summarized form
    - Displays recent completion status (last few time units)
    - GitHub-style visualization integrated directly into this view
    - Settings accessible via icon in navigation bar
- **Navigation Pattern:**
  - Drill-down Navigation from home screen:
    - Tap on a habit to see detailed history and edit
    - Tap on visualization cells to see/edit specific dates
    - Modal sheets for creation and focused editing
- **Implementation Approach:**
  - Use NavigationStack as the primary container
  - Leverage .navigationDestination() for type-based navigation
  - Use .sheet() for modal creation/editing flows
  - Implement custom transitions for fluid movement between views

### Widget Implementation Plan
- **Decision**: Single-habit visualization widgets
- **Widget Approach:**
  - Each widget represents a single habit with its GitHub-style visualization grid
  - Focus on the core visualization as the primary widget content
  - Support medium and large sizes only (skip small widgets)
- **Widget Sizes:**
  - Medium: Single habit with recent completion grid (e.g., last 2-4 weeks)
  - Large: Single habit with extended completion grid (e.g., last 2-3 months)

### Haptic Feedback Strategy
- **Decision**: Progressive and satisfying haptic patterns
- **Completion Interaction:**
  - Progressive feedback during long-press (increasing intensity)
  - Distinct "success" pattern when completion threshold is reached
  - Subtle feedback when uncompleting a habit

### Date Handling Approach
- **Decision**: Consistent, timezone-aware date handling
- **Date Calculations:**
  - Use Calendar API for all date calculations
  - Define midnight in the user's timezone as the day boundary
  - Handle edge cases like daylight saving time changes
  - Use date components for comparing dates (day, month, year)

## Design Patterns in Use

1. **Repository Pattern**: For data access abstraction (minimal implementation)
2. **Composition**: Building complex views from simple components
3. **Dependency Injection**: Via SwiftUI environment
4. **Observer Pattern**: Via SwiftUI's reactive updates
5. **Command Pattern**: For undo/redo support in editing

## Component Relationships

- **Data Layer** ↔ **View Layer**: Connected via @Query and @Environment
- **Widget Extension** ↔ **Main App**: Shared data via App Groups
- **Visualization Components** ↔ **Data Models**: Pure functions transform data to visual representations
- **Navigation System** ↔ **Feature Views**: Coordinated via NavigationStack and .navigationDestination()