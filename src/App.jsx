// import Install from './components/Install';
// import Home from './components/Home';
// import fujiBG from '/img/FUJIBACKGROUND.png';
import { useState } from 'react';
import './App.css';
import MainMint from './components/MainMint';
import NavBar from './components/NavBar';

// import { ethers } from 'hardhat';
// import url from '../secret.json';
// import web3 from 'web3';

// function App() {
//   if (window.ethereum) {
//     return (
//       <div
//         style={{
//           height: 1000,
//           backgroundImage: `url(${fujiBG})`,
//           backgroundSize: 'cover',
//           backgroundPosition: 'center',
//         }}
//       >
//         <Home />
//       </div>
//     );
//   } else {
//     // const provider = new new ethers.providers.HttpProvider(url)();
//     return <Install />;
//   }
// }

function App() {
  const [accounts, setAccounts] = useState([]);

  return (
    <div className="overlay">
      <div className="App">
        <NavBar accounts={accounts} setAccounts={setAccounts} />
        <MainMint accounts={accounts} setAccounts={setAccounts} />
      </div>
      <div className="moving-background"></div>
    </div>
  );
}

export default App;
