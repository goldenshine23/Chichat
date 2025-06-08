import React, { useState, useEffect } from 'react';
import io from 'socket.io-client';
import ChatWindow from './components/ChatWindow';
import ContactList from './components/ContactList';
import MessageInput from './components/MessageInput';

import app from './firebaseConfig';
import { getAuth, signInAnonymously, onAuthStateChanged } from 'firebase/auth';

const socket = io('http://localhost:5000');

function App() {
  const [user, setUser] = useState(null);
  const [connectedUsers, setConnectedUsers] = useState([]);
  const [messages, setMessages] = useState([]);

  const auth = getAuth(app);

  useEffect(() => {
    // Firebase auth listener
    onAuthStateChanged(auth, (currentUser) => {
      if (currentUser) {
        setUser(currentUser);
        socket.emit('join', currentUser.uid);
      } else {
        // Sign in anonymously on app load
        signInAnonymously(auth).catch(console.error);
      }
    });

    socket.on('users', (users) => setConnectedUsers(users));
    socket.on('message', (message) => setMessages((prev) => [...prev, message]));
  }, [auth]);

  const sendMessage = (text) => {
    if (text.trim() && user) {
      socket.emit('message', {
        username: user.uid,
        text,
        time: new Date().toLocaleTimeString(),
      });
    }
  };

  if (!user) {
    return <div>Loading...</div>;
  }

  return (
    <div className="app-container">
      <ContactList users={connectedUsers} />
      <ChatWindow messages={messages} currentUser={user.uid} />
      <MessageInput onSend={sendMessage} />
    </div>
  );
}

export default App;
