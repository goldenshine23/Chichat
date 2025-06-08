export default function ChatWindow({ messages, currentUser }) {
  return (
    <div className="chat-window">
      {messages.map((msg, i) => (
        <div
          key={i}
          className={`message ${msg.username === currentUser ? 'own' : ''}`}
        >
          <strong>{msg.username}</strong> [{msg.time}]: {msg.text}
        </div>
      ))}
    </div>
  );
}
