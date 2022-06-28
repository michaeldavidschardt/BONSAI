import WalletBalance from './WalletBalance';
import { useEffect, useState, useRef } from 'react';
import { Parallax, ParallaxLayer } from '@react-spring/parallax';
import skyBG from '/img/fujibglong2.png';
import mountainFG from '/img/MountainFG1.png';

import { ethers } from 'ethers';
import Bonsai from '../artifacts/contracts/bonsai.sol/CryptoBonsai.json';

const contractAddress = '0x0e73CB33F088E5fB8533eF51C6B94E4E64953126';

const provider = new ethers.providers.Web3Provider(window.ethereum);

// get the end user
const signer = provider.getSigner();

// get the smart contract
const contract = new ethers.Contract(contractAddress, Bonsai.abi, signer);

function App() {
  const ref = useRef();

  return (
    <div>
      <Parallax pages={1.5} ref={ref}>
        <ParallaxLayer
          speed={1}
          factor={1}
          style={{
            backgroundColor: '#051934',
          }}
          onClick={() => ref.current.scrollTo(1)}
        >
          <h2>WOOOOO PARALAXX</h2>
        </ParallaxLayer>

        <ParallaxLayer
          offset={0.8}
          speed={2}
          factor={1.5}
          style={{
            backgroundImage: `url(${skyBG})`,
            backgroundSize: 'cover',
          }}
        />

        <ParallaxLayer sticky={0.75} style={{ textAlign: 'left' }}>
          <img src={mountainFG} width="100%" style={{ position: 'sticky' }} />
        </ParallaxLayer>
      </Parallax>
    </div>
  );
}

export default App;
