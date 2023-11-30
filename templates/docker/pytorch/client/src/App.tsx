import React from "react";
import reactLogo from "./assets/react.svg";
import viteLogo from "/vite.svg";
import "./App.css";

const API_URL = (import.meta.env.VITE_API_URL ? import.meta.env.VITE_API_URL : "http://localhost:5000/api") as string;

function App() {
  const [count, setCount] = React.useState(0);
  const [apiResponse, setApiResponse] = React.useState("yerp");
  React.useEffect(() => {
    fetch(API_URL)
      .then((res) => res.json())
      .then((data) => setApiResponse(data.message));
  }, []);

  return (
    <div className="App">
      <div>
        <a href="https://vitejs.dev" target="_blank">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://reactjs.org" target="_blank">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <h1>Vite + React</h1>
      <div className="card">
        <h2>API Response</h2>
        <p>{apiResponse}</p>
        <button onClick={() => setCount((count) => count + 1)}>count is {count}</button>
        <p>
          Edit <code>src/App.tsx</code> and save to test HMR
        </p>
      </div>
      <p className="read-the-docs">Click on the Vite and React logos to learn more</p>
    </div>
  );
}

export default App;
