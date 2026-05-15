# 📱 Smart Wallet App

A sleek, modern expense tracker application built with **Flutter** using **Clean Architecture** principles. This project demonstrates full CRUD functionality, local data persistence, and professional UI/UX design.

---

## 🚀 Features

- **Full CRUD Operations:** Seamlessly Add, Read, Update, and Delete your financial transactions.
- **Visual Insights:** Beautiful and interactive **Pie Charts** to visualize spending habits by category.
- **Multi-Currency Support:** Choose from over 15+ global and local currencies (USD, EGP, SAR, EUR, etc.).
- **Local Persistence:** High-performance data storage using **Hive** for a lightning-fast offline experience.
- **Modern UI:** Clean, intuitive interface with smooth transitions and a focus on user experience.
- **Customizable Profile:** Personalize the app with your name and preferred settings.

---

## 🏗️ Architecture & Tech Stack

This project is built using **Clean Architecture** to ensure scalability, maintainability, and testability.

* **Frontend:** [Flutter](https://flutter.dev) (Dart)
* **State Management:** [Provider](https://pub.dev/packages/provider)
* **Database:** [Hive](https://pub.dev/packages/hive) (Local NoSQL)
* **Charts:** [fl_chart](https://pub.dev/packages/fl_chart)
* **Key Packages:** `shared_preferences`, `intl`, `font_awesome_flutter`

---

## 📁 Project Structure

The project follows a modular structure:
- `core/`: Shared constants, themes, and utility functions.
- `data/`: Data sources, repositories, and models (Hive Adapters).
- `screens/`: UI implementation divided into feature-based modules (Home, Insights, Settings, Transactions).

---

## 🛠️ Getting Started

To get a local copy up and running, follow these simple steps:

1. **Clone the repo:**
   ```bash
   git clone [https://github.com/ahmedrezk8219/smart_wallet.git](https://github.com/ahmedrezk8219/smart_wallet.git)