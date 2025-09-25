import { createConsumer } from "@rails/actioncable";

class ChatRoom {
  constructor(roomId) {
    this.roomId = roomId;
    this.consumer = null;
    this.subscription = null;
    this.initialize();
  }

  initialize() {

    try {
      this.consumer = createConsumer();

      this.subscription = this.consumer.subscriptions.create(
        { channel: "ChatChannel", room_id: this.roomId },
        {
          connected: () => {
            this.updateConnectionStatus(true);
          },

          disconnected: () => {
            this.updateConnectionStatus(false);
          },

          received: (data) => {
            this.addMessageToChat(data);
          }
        }
      );
    } catch (error) {
      this.updateConnectionStatus(false);
    }
  }

  updateConnectionStatus(connected) {
    const indicator = document.getElementById('connection-status');
    if (indicator) {
      if (connected) {
        indicator.className = 'badge bg-success ms-2';
        indicator.title = 'WebSocket verbunden';
        indicator.textContent = '●';
      } else {
        indicator.className = 'badge bg-warning ms-2';
        indicator.title = 'WebSocket getrennt';
        indicator.textContent = '●';
      }
    }
  }

  addMessageToChat(data) {
    const container = document.getElementById('messages-container');
    const noMessages = document.getElementById('no-messages');

    if (noMessages) {
      noMessages.style.display = 'none';
    }

    if (container) {
      container.insertAdjacentHTML('beforeend', data.message);

      // Auto-scroll to bottom
      setTimeout(() => {
        container.scrollTop = container.scrollHeight;
      }, 50);
    }
  }

  sendMessage(content) {
    if (this.subscription && typeof this.subscription.perform === 'function') {
      this.subscription.perform('send_message', { content: content });
      return true;
    } else {
      return false;
    }
  }
}

// Export for global use
window.ChatRoom = ChatRoom;
