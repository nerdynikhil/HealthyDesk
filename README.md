# HealthyDesk 💧🚶‍♀️

A beautiful, production-grade SwiftUI app designed to help you stay healthy while working at your desk. HealthyDesk provides intelligent reminders for water intake and walking breaks, helping you maintain healthy habits throughout your workday.

## Features

### 🏠 Home Screen
- **Beautiful Progress Cards**: Visual progress tracking for water intake and walking time
- **Circular Progress Indicators**: Elegant circular progress bars showing daily completion
- **Quick Actions**: One-tap buttons for common actions (drink water, 5-minute walk)
- **Real-time Updates**: Progress updates automatically as you log activities

### 💧 Water Tracking
- **Smart Reminders**: Customizable water intake reminders
- **Quick Selection**: Pre-set amounts (125ml, 250ml, 500ml, 750ml, 1L)
- **Custom Amounts**: Enter any custom water amount
- **Daily Goal Tracking**: Set and track your daily water intake goal
- **Visual Feedback**: Beautiful blue-themed UI with progress visualization

### 🚶‍♀️ Walking Tracking
- **Movement Reminders**: Regular walking break notifications
- **Flexible Durations**: Quick selection from 5 to 30 minutes
- **Custom Walking Time**: Log any walking duration
- **Activity Encouragement**: Motivational messages for staying active
- **Green-themed UI**: Consistent design with nature-inspired colors

### 📊 Statistics & Analytics
- **Today's Summary**: Complete overview of daily progress
- **Weekly Charts**: Visual bar charts showing 7-day trends
- **Achievement Tracking**: Monitor goal completion streaks
- **Recent Activity**: Timeline of recent water and walking entries
- **Progress Insights**: Detailed statistics and trends

### ⚙️ Settings & Customization
- **Goal Configuration**: Set custom daily water and walking goals
- **Notification Settings**: Customize reminder frequency and timing
- **Data Management**: Export data or reset all entries
- **About Information**: App version and feature details

### 🔔 Smart Notifications
- **Customizable Intervals**: Set reminder frequency (15 minutes to 4 hours)
- **Motivational Messages**: Varied, encouraging notification content
- **Respectful Timing**: Smart scheduling to avoid interruption
- **Toggle Control**: Enable/disable specific reminder types

## Technical Features

### Architecture
- **MVVM Pattern**: Clean separation of concerns
- **ObservableObject**: Reactive data management
- **UserDefaults**: Persistent local data storage
- **Modular Design**: Well-organized file structure

### UI/UX
- **SwiftUI**: Modern, declarative UI framework
- **Adaptive Design**: Works on iPhone and iPad
- **Dark Mode Support**: Automatic theme adaptation
- **Accessibility**: VoiceOver and accessibility features
- **Smooth Animations**: Polished transitions and interactions

### Data Management
- **Local Storage**: Secure data storage with UserDefaults
- **Codable Models**: Type-safe data serialization
- **Real-time Updates**: Automatic UI updates with @Published properties
- **Data Persistence**: Automatic save/load functionality

## Getting Started

### Requirements
- iOS 17.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later

### Installation
1. Clone the repository
2. Open `HealthyDesk.xcodeproj` in Xcode
3. Build and run the project

### First Launch
1. Allow notification permissions for reminders
2. Set your daily water goal (default: 2L)
3. Set your daily walking goal (default: 30 minutes)
4. Start logging your activities!

## Usage

### Adding Water Intake
1. Tap the water progress card or quick action button
2. Select a pre-set amount or enter a custom amount
3. Tap "Add Water Intake" to log the entry

### Logging Walking Time
1. Tap the walking progress card or quick action button
2. Choose from preset durations or enter custom time
3. Tap "Add Walking Time" to record the activity

### Viewing Statistics
1. Navigate to the "Stats" tab
2. View today's progress, weekly trends, and achievements
3. Check recent activity timeline

### Customizing Settings
1. Go to the "Settings" tab
2. Adjust daily goals using the sliders
3. Configure notification preferences
4. Manage your data and app preferences

## App Structure

```
HealthyDesk/
├── Models/
│   └── HealthModel.swift          # Data models and business logic
├── Views/
│   ├── WaterEntrySheet.swift      # Water logging interface
│   ├── WalkEntrySheet.swift       # Walking logging interface
│   ├── StatsView.swift            # Statistics and analytics
│   └── SettingsView.swift         # Configuration and preferences
├── Managers/
│   └── NotificationManager.swift  # Notification handling
├── Assets.xcassets/               # App icons and images
├── ContentView.swift              # Main app interface
├── HealthyDeskApp.swift          # App entry point
└── Info.plist                    # App configuration
```

## Customization

### Daily Goals
- Water: 500ml - 4000ml (customizable in 250ml increments)
- Walking: 15 - 120 minutes (customizable in 15-minute increments)

### Notification Intervals
- Water reminders: 15 minutes to 4 hours
- Walking reminders: 15 minutes to 2 hours

### Theme Colors
- Water activities: Blue (#007AFF)
- Walking activities: Green (#34C759)
- Interface: System adaptive colors

## Health Benefits

### Proper Hydration
- Improved cognitive function
- Better energy levels
- Enhanced metabolism
- Healthier skin
- Better kidney function

### Regular Movement
- Reduced risk of cardiovascular disease
- Improved posture and back health
- Better circulation
- Enhanced mood and mental health
- Increased productivity

## Contributing

We welcome contributions! Please feel free to submit pull requests or create issues for bugs and feature requests.

## Privacy

HealthyDesk respects your privacy:
- All data is stored locally on your device
- No data is transmitted to external servers
- You have full control over your data
- Data can be exported or deleted at any time

## Support

For support, feature requests, or bug reports, please create an issue in the repository.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Built with SwiftUI and love for health and productivity
- Designed with modern iOS design principles
- Inspired by the need for healthier work habits

---

**Stay healthy, stay productive!** 💪✨