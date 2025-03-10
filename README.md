# VirtuAid

Mobile client for Virtual Aid services.

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version recommended)
- Android Studio / Xcode (depending on target platform)
- Git

### Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/sahil-shefeek/virtuaid-app.git
   cd virtuaid-app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

## Environment Configuration

This project uses environment files to manage configuration for different
environments. Only `example.env.json` is provided in the repository.

### Setting Up Environment Files

1. Rename the `example.env.json` file based on your environment needs:
   ```bash
   # Choose one or more of the following based on your needs
   cp example.env.json env.json               # Default environment
   cp example.env.json .env.development.json  # Development environment
   cp example.env.json .env.production.json   # Production environment
   cp example.env.json .env.staging.json      # Staging environment
   cp example.env.json .env.testing.json      # Testing environment
   cp example.env.json .env.local.json        # Local development
   ```
2. Modify each file with the appropriate values for that environment.

### Environment File Structure

The environment files use the following structure:

```json
{
  "API_BASE_URL": "http://localhost:8000/api/"
}
```

Configuration parameters:

| Parameter      | Description                |
| -------------- | -------------------------- |
| `API_BASE_URL` | Base URL for API endpoints |

## Running the Application

To run the app with different environment configurations:

```bash
# Using the default environment
flutter run --dart-define-from-file=env.json

# Using the development environment
flutter run --dart-define-from-file=.env.development.json

# Using the production environment
flutter run --dart-define-from-file=.env.production.json

# Using other environments
flutter run --dart-define-from-file=.env.staging.json
flutter run --dart-define-from-file=.env.testing.json
flutter run --dart-define-from-file=.env.local.json
```

## Building for Release

To build release versions with specific environment configurations:

```bash
# Build Android APK with production environment
flutter build apk --dart-define-from-file=.env.production.json

# Build iOS with production environment
flutter build ios --dart-define-from-file=.env.production.json
```

## Automated Builds with GitHub Actions

This project is configured for automated builds using GitHub Actions. When code
is pushed to the main branch, a new APK is built and published as a GitHub
release.

### Setting up GitHub Secrets for Automated Builds

To properly build the app with environment variables, you need to set up the
following GitHub Secrets:

1. Go to your GitHub repository → Settings → Secrets and variables → Actions
2. Add the following secret:
   - `API_BASE_URL`: Your API base URL (e.g., "http://api.example.com/")
   - Add any other environment variables your app needs

The GitHub Action workflow will automatically create an `.env.json` file using
these secrets before building the app.

## Troubleshooting

- If you encounter build issues, try running `flutter clean` followed by
  `flutter pub get`
- Ensure your environment files are correctly formatted and contain the required
  parameters
- Verify that you have the latest Flutter SDK installed (`flutter upgrade`)
