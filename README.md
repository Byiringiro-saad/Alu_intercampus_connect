# ALU Connect

Student engagement and opportunity discovery platform for the African Leadership University ecosystem.

## Features

- **Authentication**: Create an account, log in, and edit your profile (photo, name, program, campus, interests)
- **Home Feed**: Search, filter chips, featured events, recommended opportunities
- **Events**: RSVP, save, share, event details with hero animations
- **Communities**: ALU Community Hubs with join/leave
- **Chat**: Direct messages and user-created groups between registered accounts only
- **Profile**: Leadership score, impact dashboard, achievements, leaderboard
- **Create**: Authorized users publish events, hackathons, workshops, internships, leadership programs, startup initiatives, and community announcements
- **Extras**: Dark mode, pull-to-refresh, shimmer loading, QR check-in mock

## Tech Stack

- Flutter (Material 3)
- Provider (in-memory state management)
- Mock data only (no backend or database)
- Shimmer, Google Fonts, intl, uuid

## Project Structure

```
lib/
├── models/          # Data models
├── services/        # Mock data and scoring algorithms
├── providers/     # State management (Provider)
├── screens/         # UI screens by module
├── widgets/         # Reusable components
├── utils/           # Theme, routes, validators
└── main.dart
```

## Getting Started

```bash
flutter pub get
flutter run
```

## Accounts

### Create your own account

1. Open the app and complete onboarding.
2. Tap **Sign Up** on the login screen.
3. Fill in name, email, password, program, and campus.
4. After sign-up you can edit your profile from **Profile → Settings → Edit Profile** or the edit icon on your profile.

Accounts are stored in memory for the session only (no backend). If the app is fully restarted, you will need to sign up again unless you use the pre-seeded demo account below.

### Demo account (for evaluation)

Use this pre-registered account to explore organizer features and sample data:

| Field    | Value                            |
|----------|----------------------------------|
| Email    | `student@alustudent.com` |
| Password | `alu2026`                  |

The demo account (**Demo User**) has **full evaluator access** — browse, RSVP, join hubs, chat, post opportunities, edit profile (including uploading a photo), and use every screen. It starts with an **empty profile photo** like new sign-ups. New sign-ups default to **Student** unless an authorized account type is selected.

### Authorized posting roles

Only these account types can use the **+** button to publish opportunities and activities:

| Account type       | Can publish                                              |
|--------------------|----------------------------------------------------------|
| Club Leader        | Club events and announcements                            |
| Event Organizer    | Events, workshops, hackathons                            |
| Entrepreneur       | Startup initiatives and pitch opportunities              |
| Community Leader   | Community announcements and group activities             |
| Academic Team      | Internships, leadership programs, academic opportunities |
| Student            | Browse, RSVP, join communities, and chat only            |

Supported activity types: **Events**, **Hackathons**, **Workshops**, **Startups**, **Leadership**, **Internships**, and **Announcements**.

### Chat between accounts

Chats are empty on first launch. To try messaging:

1. Sign up with a second account (e.g. in another emulator session or after logging out).
2. Open **Chats → New chat** to start a direct message with another registered student.
3. Use **Create Group** to start a group chat and add members.

Only registered users who are members of a conversation can read or send messages. There are no pre-seeded groups or auto-replies.

## Color Palette

| Token      | Hex       |
|------------|-----------|
| Primary    | `#C031B5` |
| Secondary  | `#E879DE` |
| Accent     | `#D54BC4` |
| Background | `#F8FAFC` |

## Leadership Score Algorithm

| Activity              | Points |
|-----------------------|--------|
| Event attendance      | +15    |
| Community join        | +10    |
| Hackathon             | +25    |
| Workshop              | +12    |
| Leadership program    | +20    |

Max score: 500 points
# Alu_intercampus_connect
