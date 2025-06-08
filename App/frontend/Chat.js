import React, { useState, useEffect } from 'react';
import { io } from 'socket.io-client';

// Connect using backend URL from env variable
const socket = io(process.env.REACT_APP_BACKEND_URL || 'http://localhost:5000');

function Chat() {
  const [message, setMessage] = useState('');
  const [messages, setMessages] = useState([]);

  useEffect(() => {
    socket.on('chat message', (msg) => {
      setMessages((prev) => [...prev, msg]);
    });

    return () => {
      socket.off('chat message');
    };
  }, []);

  const sendMessage = () => {
    if (message.trim() !== '') {
      socket.emit('chat message', message);
      setMessage('');
    }
  };

  return (
    <div>
      <h2>Chichat</h2>
      <div style={{ border: '1px solid #ccc', padding: 10, height: 200, overflowY: 'auto' }}>
        {messages.map((msg, i) => (
          <div key={i}>{msg}</div>
        ))}
      </div>
      <input
        value={message}
        onChange={(e) => setMessage(e.target.value)}
        placeholder="Type your message"
      />
      <button onClick={sendMessage}>Send</button>
    </div>
  );
}

export default Chat;
