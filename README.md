# 🚆 Where is My Train – Flutter App Clone

An ultimate clone of the **"Where is My Train"** app built using **Flutter**.  
This is my **first showcase Flutter project**, developed over **40+ hours** with a strong focus on UI design, functionality, and user experience.

## About the Project

This is a UI clone of a train booking app, featuring a responsive design and smooth navigation. It showcases train search, schedule view, and station tracking elements visually.

### Built With:
- **Flutter** – UI Toolkit by Google
- **Dart** – Programming Language
- **Stateful and Stateless Widgets**
- **Material Design Components**
- Custom animations and responsive UI

## Features
- Train Track UI     
- Adaptive and responsive UI  
- Smooth transitions and navigation

## 📸 Screenshots
<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/2e313169-54db-4dd0-9d9e-310901cfb83a" width="250" height="500" /></td>
    <td><img src="https://github.com/user-attachments/assets/a98e598c-8859-4bb9-9ab1-dfde43ceab3a" width="250" height="500" /></td>
    <td><img src="https://github.com/user-attachments/assets/98b8e34e-a5c8-4c33-9bb9-05fcf94a7dc1" width="250" height="500" /></td>
    <td><img src="https://github.com/user-attachments/assets/5b8c21fd-6ab8-4ad2-bff2-a1f04fb098c2" width="250" height="500" /></td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/938fdfa4-f348-4578-ba9d-b2ad3bba8eb7" width="250" height="500" /></td>
    <td><img src="https://github.com/user-attachments/assets/c1c0ef3d-7002-43e3-b322-2b97ea73e667" width="250" height="500" /></td>
    <td><img src="https://github.com/user-attachments/assets/5dd806b8-8934-4a25-a1f9-5676e65f756f" width= "250" height="500"/></td>
    <td><img src="https://github.com/user-attachments/assets/53088524-2b2f-47d6-bb3a-4fa3f9b34c37" width="250" height="500" /></td>
  </tr>
</table> </br>

## Getting Started

### Prerequisites
- Flutter SDK installed
- Android Studio or VS Code
- Dart plugin enabled

## Installation
```sh
git clone https://github.com/your-username/where-is-my-train-clone.git
cd where-is-my-train-clone/app_clone
flutter pub get
flutter run
```

## Contributing
- Pull requests are welcome! If you’d like to improve the app or fix bugs, feel free to fork and submit a PR.

---
## Credits: Google
---

## Connect with Me
If you found this project helpful or have any suggestions, feel free to connect:

- [![LinkedIn](https://img.shields.io/badge/LinkedIn-anshmnsoni-0077B5.svg?logo=linkedin)](https://www.linkedin.com/in/anshmnsoni)  
- [![GitHub](https://img.shields.io/badge/GitHub-AnshMNSoni-181717.svg?logo=github)](https://github.com/AnshMNSoni)
- [![Reddit](https://img.shields.io/badge/Reddit-u/AnshMNSoni-FF4500.svg?logo=reddit)](https://www.reddit.com/user/AnshMNSoni)

## 📜 License
This project is licensed under the [MIT License](LICENSE).

### Thankyou


## Cell-tower tracking and offline-status roadmap

The `feature/cell-tower-offline-status` branch adds an Android cell-information reader and a dedicated UI entry point. Android can report cell identifiers and signal strength when the device and carrier expose them and the user grants the requested permissions.

**Important limitations**
- A cell ID is not a latitude/longitude. A tower-coordinate dataset is required before cell IDs can be mapped to places or matched to a railway route.
- Cell coverage can span a large area, so cell-only train positions must be estimates and confidence must reflect actual evidence. No location or confidence is fabricated when tower coordinates are missing.
- The current app is a Flutter UI clone; it does not yet include an authoritative live running-status provider or a bundled offline train timetable/route database. Therefore an accurate current `On time` / `Late` result cannot be produced offline yet.
- A safe offline-first design should cache the last real status with its timestamp, ship a licensed route/timetable dataset, and label schedule-derived estimates separately from live railway data.
- GPS is optional and should be used only with the user's permission as a cross-check.

The new Cell Tower Tracking screen currently reads device cell information only. Railway location matching, the offline timetable database, live delay source, and persisted last-known status are follow-up integrations, not claimed as implemented.
