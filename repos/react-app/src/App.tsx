import { useEffect, useState } from "react";
import reactLogo from "./assets/react.svg";
import viteLogo from "/vite.svg";
import "./App.css";

function App() {
  const [count, setCount] = useState(0);

  return (
    <>
      <div>
        <a href="https://vite.dev" target="_blank">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://react.dev" target="_blank">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <h1>Vite + React</h1>
      <div className="container">
        <div className="card">
          <p>Profile section</p>
          <ProfileSection />
        </div>
        {import.meta.env.VITE_FEATURE_FLAG_A == "enabled" ? (
          <div className="card">
            <p>Billing</p>
            <BetaButton />
          </div>
        ) : (
          <p>Production</p>
        )}
      </div>
      <div className="card">
        <button onClick={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
        <p>
          Edit <code>src/App.tsx</code> and save to test HMR
        </p>
      </div>
    </>
  );
}

export default App;

function BetaButton() {
  return (
    <article
      style={{
        backgroundColor: "whitesmoke",
        border: "1px solid black",
        borderRadius: "5px",
      }}
    >
      <p>Due amount: 1.000$</p>
      <p>Due date: 10/10/2029</p>
    </article>
  );
}

function ProfileSection() {
  const [profile, setProfile] = useState<Profile | null>(null);

  useEffect(() => {
    // Read: https://maxrozen.com/race-conditions-fetching-data-react-with-useeffect
    let ignore = false;
    setProfile(null);
    fetchProfile().then((result) => {
      if (!ignore) {
        setProfile(result);
      }
    });
    return () => {
      ignore = true;
    };
  }, []);

  return (
    <article
      style={{
        backgroundColor: "whitesmoke",
        border: "1px solid black",
        borderRadius: "5px",
      }}
    >
      <p>Name: {profile?.name}</p>
      <p>Role: {profile?.role}</p>
    </article>
  );
}

async function fetchProfile(): Promise<Profile> {
  const apiUrl = import.meta.env.VITE_APP_API_URL + "/profile";
  const response = await fetch(apiUrl);
  // Check if the response is successful (status code 200-299)
  if (!response.ok) {
    throw new Error(`HTTP error! Status: ${response.status}`);
  }

  const data = await response.json();
  const result: Profile = data as Profile;

  return result;
}

interface Profile {
  name: string;
  role: string;
}
