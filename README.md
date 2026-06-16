# 🌸 Swasth Maa AI

**An AI-powered maternal and child health companion for rural India — built to work in regional Indian languages.**

> Swasth Maa AI — Because every mother deserves a doctor in her pocket.

---

## 📌 The Problem

Every year, India loses tens of thousands of mothers to preventable causes during pregnancy and childbirth. The majority of these deaths occur not in cities, but in rural villages — where the nearest doctor is hours away, ASHA workers are stretched across thousands of people, and health guidance simply doesn't exist in the language a mother actually speaks.

Three critical gaps cost lives every day:

- **No early warning system** — Conditions like preeclampsia are silent and treatable if caught early, but go unnoticed without guidance.
- **Missed vaccinations** — Children miss critical immunisations simply because no one reminds the family in time.
- **No one to ask** — Overworked ASHA workers can't be available 24/7, leaving mothers without answers when they need them most.

**Swasth Maa AI** exists to close this gap.

---

## 💡 The Solution

Swasth Maa AI is a mobile app that puts a knowledgeable, compassionate health companion in the hands of every rural pregnant woman and new mother — one that speaks her language, is available around the clock, and requires no literacy to use.

It doesn't replace doctors. It bridges the gap between a mother noticing something is wrong and her reaching the care she needs.

---

## ✨ Features

| Feature | Description |
|---|---|
| 🩺 **Health Check** | Daily symptom logging (blood pressure, swelling, fever, headache) with AI-powered risk analysis that flags warning signs like preeclampsia |
| 💉 **Vaccination Reminder** | Tracks each child's immunisation schedule (OPV, Pentavalent, BCG, etc.) with due-date alerts |
| 🎙️ **Maa Se Baat (AI Chat)** | Voice + text AI assistant powered by the **BharatGen AI API** — ask health questions by speaking or typing in your own regional language |
| 🚨 **Emergency SOS** | One-tap access to call an ambulance (108), locate the nearest health centre, or contact an ASHA worker |

---

## 🛠️ Tech Stack

- **Frontend:** Flutter (cross-platform — Android & iOS)
- **AI / Chat & Voice:** BharatGen AI API (multilingual Indian-language LLM)
- **Backend & Auth:** Firebase (Auth + Firestore)
- **Native builds:** C++, CMake (Flutter engine), Swift (iOS)

---

## 📱 Screenshots

| Home | Health Check | Vaccination |
|---|---|---|
| Daily overview & quick actions | Symptom logging + risk analysis | Child immunisation tracking |

| Maa Se Baat (AI Chat) | Emergency SOS |
|---|---|
| Voice/text AI assistant in regional language | One-tap emergency help |

*(Add actual screenshot images to a `/screenshots` folder and embed them here using `![Home](screenshots/home.png)`)*

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed
- A BharatGen AI API key
- Firebase project set up (Auth + Firestore)

### Installation

```bash
# Clone the repository
git clone https://github.com/Priyanshu-Raj81/Swasth_maa_AI.git
cd Swasth_maa_AI/swasth_maa_ai

# Install dependencies
flutter pub get

# Add your API keys
# Create a .env file or update lib/config with your BharatGen API key and Firebase config

# Run the app
flutter run
```

---

## 🗺️ Roadmap

- [ ] Offline mode using on-device models for low-connectivity areas
- [ ] ASHA worker dashboard for monitoring assigned families
- [ ] Integration with India's official immunisation registry (eVIN)
- [ ] Support for additional regional languages and dialects

---

## 🌍 Why This Matters

Rural India is home to over 70% of the country's population, yet receives a fraction of its healthcare infrastructure. Literacy rates among rural women hover around 50% in many districts — making a voice-first, regional-language experience essential, not optional.

Swasth Maa AI is built on the belief that the most important AI applications aren't the flashiest ones — they're the ones that reach people who have been left out of the conversation about where technology goes next.

---

## 🏆 Recognition

Submitted to **Google Cloud Gen AI Academy — Meet the Builders** (APAC), a campaign recognising developers using Generative AI to solve real, local problems across Asia Pacific.

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome. Feel free to check the [issues page](https://github.com/Priyanshu-Raj81/Swasth_maa_AI/issues).

---

## 📄 License

This project is open source. Add your preferred license here (e.g., MIT).

---

## ⚠️ Disclaimer

This AI tool provides general health information and guidance. It is **not** a substitute for professional medical advice, diagnosis, or treatment. Always consult a qualified healthcare provider for medical concerns.

---

## 👤 Author

**Priyanshu Raj**
