export default function ContactList({ users }) {
  return (
    <div className="contact-list">
      <h3>Online Users</h3>
      <ul>
        {users.map((user, i) => (
          <li key={i}>{user}</li>
        ))}
      </ul>
    </div>
  );
}
