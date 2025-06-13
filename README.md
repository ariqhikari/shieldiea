# Shieldiea - Safe Content For Children

**Shieldiea** is a mobile application built with Flutter that enables parents to monitor their child's screen activity in real-time. The app captures screen frames, analyzes content using AI to detect inappropriate material, and overlays a block screen when necessary. It also provides activity reports and notifications to help parents maintain a safe digital environment for their children.

## 🌟 Features

- 📸 **Screen Capture Monitoring**: Continuously captures screen frames while the app runs, even in the background.
- 🛡️ **Automatic Content Blocking**: Displays a blocking overlay over detected inappropriate content to prevent children from viewing it.
- 🧠 **AI-Based Content Detection**: Integrates with  Azure OpenAI to analyze screen content and detect harmful material such as pornography or violence.
- 📩 **Parental Notifications**: Sends real-time alerts via Firebase Cloud Messaging when negative content is detected.
- 📊 **Activity Reports**: Provides detailed logs of app usage, screen time, and the number of content violations detected.
- ⚙️ **Detection Personalization**: Parents can enable or disable specific detection categories, such as adult content, violence, etc.
- 📱 **Runs in Background**: The monitoring continues even after the user switches apps or presses the home button.

## 🚀 Technologies Used

- **Flutter**: For cross-platform mobile app development.
- **Firebase**: For database, notifications, and authentication.
- **Azure OpenAI**: For content analysis from screen captures.

## 🖥️ Getting Started

Follow these steps to set up the project locally:

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Firebase configuration for real-time database and notifications.

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/ariqhikari/shieldiea.git

2. Navigate to the project directory:

    ```bash
    cd shieldiea
    
4. Install the necessary dependencies:

    ```bash
   flutter pub get
  
6. Run the app:

    ```bash
   flutter run
