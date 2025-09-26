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

The following software packages must be installed:

- **Ruby 3.4.5**
- **Ruby on Rails 8.0**
- **Git**
- **SQLite3**
- **Code editor** (VSCode, NeoVim, Cursor, etc.)

### Windows Setup

If you are using Windows, make sure you have installed all Windows Updates first.

This fixes common issues:
- Limited 800x600 resolution
- WSL not found errors

### Installing Ruby with rbenv

We will use rbenv, a Ruby version manager, to install Ruby.

```bash
# Install WSL Ubuntu (Windows only)
wsl --install -d Ubuntu

# Update package lists and install dependencies
sudo apt update
sudo apt-get install -y build-essential libssl-dev zlib1g-dev libyaml-dev

# Install rbenv
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash

# Reload shell
source ~/.bashrc

# Install Ruby 3.4.5
rbenv install 3.4.5
rbenv global 3.4.5
rbenv rehash
```

Verify Ruby installation:

```bash
ruby -v
# Should output: ruby 3.4.5 (...)
```

### Installing Rails and Dependencies

```bash
# Install Rails and Bundler
gem install bundler rails

# Verify installation
rails -v
# Should output: Rails 8.0.3

# Install Git and SQLite3
sudo apt-get install git sqlite3 libsqlite3-dev
```

### Code Editor Setup

Install your preferred code editor. For VSCode:

```bash
# Open current directory in VSCode
code .

# Open file explorer (Windows)
explorer.exe .
```

### Working Directory

Create and use `~/code` as your working directory:

```bash
cd
mkdir code
cd code
```

### Project Setup

1. **Clone Repository**
   ```bash
   git clone https://github.com/hadzicni/railschat.git
   cd railschat
   ```

2. **Install Dependencies**
   ```bash
   bundle install
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

## 🐛 Troubleshooting

### Common Issues

#### Ruby Version Issues

**Problem**: Ruby version not found with rbenv

**Solution**: Disable system Ruby and restart terminal

```bash
# Check what rbenv points to
which rbenv

# If it points to /usr/bin/ruby-build:
sudo mv /usr/bin/ruby-build /usr/bin/ruby-build.bkp

# If it points to /usr/bin/ruby:
sudo mv /usr/bin/ruby /usr/bin/ruby.bkp

# Add rbenv to PATH
echo 'PATH="$HOME/.rbenv/plugins/bin:$PATH"' >> ~/.profile
echo 'eval "$(rbenv init -)"' >> ~/.profile
source ~/.profile

# Retry Ruby installation
rbenv install 3.4.5
rbenv global 3.4.5
```

#### Bundle Install Failures

**Problem**: `bundle install` fails

**Solution**: Install missing dependencies

```bash
sudo apt-get install build-essential
sudo apt-get install libsqlite3-dev
ruby -v  # Verify Ruby version
```

#### Database Errors

**Problem**: Database connection issues

**Solution**: Reset database

```bash
rails db:drop
rails db:create
rails db:migrate
rails db:seed
```

#### Server Issues

**Problem**: Server won't start

**Solution**: Check port availability

```bash
# Check if port 3000 is in use
lsof -i :3000

# Kill process if needed
kill -9 [PID]

# Restart server
rails server
```

#### Asset Loading Issues

**Problem**: CSS/JavaScript not loading

**Solution**: Clear asset cache

```bash
rails assets:clobber
rails assets:precompile
```

### Getting Help

- 📚 [Rails Guides](https://guides.rubyonrails.org/)
- 📖 [Ruby Documentation](https://ruby-doc.org/)
- 💬 [Rails Community](https://discuss.rubyonrails.org/)

## Development

**Nikola Hadzic**
September 19, 2025
ICT Module 223 – Multi-user Application
Class: 23-223-E

## 📄 License

This project was developed for educational purposes as part of ICT Module 223.
