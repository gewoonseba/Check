# Product Context

## Why This Project Exists

Check exists to solve the problem of habit tracking fatigue. Many users start using habit trackers but abandon them because:
- They're too complex and overwhelming
- They lack intrinsic motivation beyond gamification
- The tracking itself doesn't feel satisfying

Check addresses these issues by creating a visualization-first approach that makes the act of tracking visually rewarding and intrinsically motivating.

## Problems It Solves

1. **Habit Abandonment**: By making tracking visually satisfying, users are more likely to maintain their habits long-term
2. **Tracking Friction**: Through widgets and intuitive interactions, tracking becomes effortless
3. **Motivation Decay**: The GitHub-style visualization provides continuous visual motivation
4. **Feature Overload**: By focusing on doing one thing exceptionally well, users aren't overwhelmed

## How It Should Work

### Basic Functionality
- **Creating Habits**: 
  - Simple creation flow requiring only a name and frequency (daily/weekly/monthly)
  - Optional specific days selection for weekly habits
  - Optional specific date for monthly habits
  - Minimal required fields to reduce friction
  - Quick duplication of existing habits

- **Checking Off Habits**:
  - Signature long-press interaction that feels intentional and rewarding
  - Visual feedback during the press (filling animation)
  - Haptic feedback pattern upon completion
  - Immediate reflection in the GitHub-style visualization
  - Ability to uncheck if marked by mistake

- **Deleting/Archiving Habits**:
  - Simple swipe-to-delete gesture with confirmation
  - Archive option for temporary pausing without losing history
  - Batch selection for managing multiple habits
  - Data preservation options when deleting

### Onboarding Flow
- **3-Step Visual Tutorial**: 
  1. Create a habit (with sample pre-filled)
  2. Complete it (showcasing the satisfying interaction)
  3. Watch the visualization grow (time-lapse preview)
- **Sample Data Option**: Toggle to view Check with sample data to understand future state
- **Widget Setup Guidance**: Help setting up widgets during onboarding

### Home Screen Integration
- **Small Widget**: Today's habits with completion status
- **Medium Widget**: Week view of completion status
- **Large Widget**: Monthly grid visualization 
- **Widget Interactions**: Complete habits directly from any widget size
- **Widget Configuration**: Customizable to show specific habits or all habits

### Progress Sharing
- **Progress Cards**: 
  - Auto-generated visual summaries at milestone completions
  - Custom date range selection for generating cards
  - Multiple visual templates (monthly grid, streak highlights, etc.)
  - Privacy controls for what data is included
- **Share Sheet Integration**: Easy sharing to messages, social media, or save to photos

### Data Management
- **Export Options**:
  - One-tap CSV export via share sheet
  - JSON export for developers/power users
  - Optional export scheduling (monthly backup to iCloud)
- **Import Capability**: Basic import from CSV for migration from other apps

## User Experience Goals

1. **Satisfying**: Every interaction should feel good, especially completing habits
2. **Motivating**: The visualization should create intrinsic motivation to maintain streaks
3. **Frictionless**: Tracking should be quick and accessible from multiple entry points
4. **Clear**: The UI should be intuitive without requiring explanation
5. **Focused**: The app should do one thing exceptionally well rather than many things adequately