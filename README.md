# RailsChat

A real-time multi-user chat application built with Ruby on Rails.

## Project Overview

RailsChat is a web-based chat application that enables multiple users to communicate in real-time across different chat rooms. The application was developed as part of the ICT Module 223 course.

## Features

### Functional Requirements (Implemented)
1. ✅ **User Registration** - Sign up with email and password
2. ✅ **User Login/Logout** - Secure authentication and session management
3. ✅ **Send/Receive Messages** - Real-time communication in chat rooms
4. ✅ **Multiple Chat Rooms** - Create and join different rooms
5. ✅ **Message History** - Display all messages per room
6. ✅ **User Profiles** - Complete profile management system
7. ✅ **Real-time WebSocket** - Instant message delivery with Action Cable

### Non-functional Requirements
1. ✅ **User Experience** - Modern, intuitive Bootstrap-based interface
2. ✅ **Performance** - Real-time updates with WebSocket technology
3. ✅ **Security** - Encrypted passwords with Devise authentication
4. ✅ **Maintainability** - Clean, modular Rails architecture

## Technologies

- **Backend**: Ruby on Rails 8.0.2.1
- **Frontend**: HTML/ERB, Bootstrap 5.3.0, Custom CSS with gradients
- **Database**: SQLite3 (development)
- **Authentication**: Devise
- **Real-time**: Action Cable (WebSockets)
- **Styling**: Bootstrap 5 with custom CSS variables and modern design

## Installation & Setup

### Prerequisites
- Ruby 3.4+
- Rails 8.0+
- Node.js and npm

### Steps

1. **Clone Repository**
   ```bash
   git clone https://github.com/hadzicni/railschat.git
   cd projektarbeit_chatapp
   ```

2. **Install Dependencies**
   ```bash
   bundle install
   npm install
   ```

3. **Setup Database**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Start Server**
   ```bash
   rails server
   ```

5. **Open Application**
   - Visit [http://localhost:3000](http://localhost:3000)

## Usage

1. **Registration**: Create a new account with email and password
2. **Login**: Sign in with your credentials
3. **Chat Rooms**: Select an existing room or create a new one
4. **Chatting**: Write messages and communicate with other users in real-time
5. **Profile**: View and edit your profile information

## Project Structure

```
app/
├── controllers/
│   ├── home_controller.rb      # Homepage
│   ├── rooms_controller.rb     # Chat room management
│   ├── messages_controller.rb  # Message handling
│   └── users_controller.rb     # User profile management
├── models/
│   ├── user.rb                 # User model (Devise)
│   ├── room.rb                 # Chat room model
│   └── message.rb              # Message model
├── views/
│   ├── layouts/
│   │   └── application.html.erb # Main layout with modern styling
│   ├── home/
│   ├── rooms/
│   │   ├── index.html.erb       # Room overview
│   │   └── show.html.erb        # Chat interface
│   ├── users/
│   │   ├── show.html.erb        # Profile view
│   │   └── edit.html.erb        # Profile editing
│   ├── messages/
│   │   └── _message.html.erb    # Message partial
│   └── devise/                  # Authentication views
└── channels/
    ├── application_cable/
    │   └── connection.rb        # WebSocket connection
    └── chat_channel.rb          # Real-time chat channel
```

## User Roles

- **User**: Can register, login, create/join chat rooms, send messages, and manage profile
- **Administrator**: (Planned for future version)

## Entity-Relationship Model

```
User ||--o{ Message : sends
Room ||--o{ Message : contains
User }o--o{ Room : participates_in (via messages)
```

### Entities:
- **User**: id, email, password, first_name, last_name, bio, location, created_at, updated_at
- **Room**: id, name, description, created_at, updated_at
- **Message**: id, content, user_id, room_id, created_at, updated_at

## Key Features Implementation

### Real-time Communication
- **WebSocket Integration**: Action Cable for instant message delivery
- **Auto-scroll**: Automatic scrolling to new messages
- **Connection Status**: Real-time connection indicator

### Modern UI/UX
- **Responsive Design**: Works on desktop, tablet, and mobile
- **Custom Styling**: CSS variables with gradient backgrounds
- **Message Bubbles**: Modern chat interface with user avatars
- **Profile System**: Complete user profile management

### Performance & UX
- **Optimized Scrolling**: Smooth chat container with custom scrollbars
- **Real-time Updates**: No page refresh required
- **User Avatars**: Auto-generated initials with modern styling

## Future Enhancements

- [ ] **Admin Panel** for user management
- [ ] **Private Messages** between users
- [ ] **File Upload** for images and documents
- [ ] **Push Notifications** for new messages
- [ ] **Message Search** functionality
- [ ] **Emoji Support** and reactions
- [ ] **Dark Mode** theme option

## Development

**Nikola Hadzic**  
September 19, 2025  
ICT Module 223 – Multi-user Application  
Class: 23-223-E

## License

This project was developed for educational purposes.

## Screenshots

The application features a modern, gradient-based design with:
- Clean navigation with user dropdown
- Real-time chat interface with scrollable message history
- User profile pages with activity statistics
- Responsive design for all screen sizes
- Modern form styling and button design
