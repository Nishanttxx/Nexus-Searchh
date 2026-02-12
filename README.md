# Nexus Search

Nexus Search is an AI-powered search application built with Flutter and FastAPI, inspired by Perplexity. It provides intelligent web search capabilities, source sorting, and LLM-generated responses to user queries.

## Features

- **Intelligent Web Search**: Performs web searches to gather relevant information.
- **Source Sorting**: Automatically sorts search results based on relevance to the query.
- **LLM Response Generation**: Uses advanced language models to generate comprehensive answers.
- **Real-time Communication**: WebSocket-based chat interface for seamless interaction.
- **Cross-Platform**: Built with Flutter for iOS, Android, and desktop support.
- **FastAPI Backend**: Robust Python backend for handling search operations and AI processing.

## Tech Stack

- **Frontend**: Flutter, Dart
- **Backend**: Python, FastAPI
- **Communication**: WebSockets
- **AI/ML**: LLM services for response generation
- **Search**: Custom search service integration

## Prerequisites

Before running this project, ensure you have the following installed:

- Flutter SDK (version 3.9.2 or later)
- Python (version 3.8 or later)
- Git

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/Nexus-Search.git
   cd Nexus-Search
   ```

2. **Set up the Flutter app**:
   ```bash
   flutter pub get
   ```

3. **Set up the Python backend**:
   ```bash
   cd server
   pip install -r requirements.txt
   ```

## Running the Application

1. **Start the backend server**:
   ```bash
   cd server
   python main.py
   ```
   The server will start on `http://localhost:8000`.

2. **Run the Flutter app**:
   ```bash
   flutter run
   ```

## Usage

1. Launch the app on your device or emulator.
2. Enter your search query in the search bar.
3. The app will perform a web search, sort relevant sources, and generate an AI-powered response.
4. View the results and sources in the chat interface.

## Project Structure

```
Nexus-Search/
├── lib/                    # Flutter app source code
│   ├── main.dart          # App entry point
│   ├── pages/             # App pages (home, chat)
│   ├── services/          # Services (chat web service)
│   ├── theme/             # App theming
│   └── widgets/           # Reusable UI components
├── server/                # FastAPI backend
│   ├── main.py           # Server entry point
│   ├── services/         # Backend services (LLM, search, sort)
│   └── pydantic_model/   # Data models
├── android/               # Android platform code
├── ios/                   # iOS platform code
└── web/                   # Web platform code
```

## API Endpoints

- `POST /chat`: Handle chat requests with search and LLM response
- `WebSocket /ws/chat`: Real-time chat communication

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by Perplexity AI
- Built with Flutter and FastAPI
