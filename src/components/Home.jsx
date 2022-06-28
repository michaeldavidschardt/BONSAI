import { useEffect, useState } from 'react';
import { ethers } from 'ethers';
import Bonsai from '../artifacts/contracts/bonsai.sol/CryptoBonsai.json';
// import WalletConnectProvider from '@walletconnect/web3-provider';
// // import web3Modal from 'web3modal';
// import { INFURA_ID } from '../../secret.json';

// export const PROVIDER_OPTIONS = {
//   walletconnect: {
//     package: WalletConnectProvider, // required
//     options: {
//       infuraId: INFURA_ID, // required
//     },
//   },
// };

// if (typeof window !== 'undefined') {
//   web3Modal = new Web3Modal({
//     network: 'mainnet',
//     cacheProvider: true,
//     providerOptions: PROVIDER_OPTIONS,
//   });
// }

const contractAddress = '0xDa30305912F22150E842Bf3c6C4ea3E987C98df3';

const provider = new ethers.providers.Web3Provider(window.ethereum);

// get user
const signer = provider.getSigner();

// get contract
const contract = new ethers.Contract(contractAddress, Bonsai.abi, signer);

function Home() {
  const [totalMinted, setTotalMinted] = useState(0);
  useEffect(() => {
    getCount();
  }, []);

  const getCount = async () => {
    const count = await contract.totalSupply();
    console.log(parseInt(count));
    setTotalMinted(parseInt(count));
  };

  return (
    <div>
      <div>
        <div
          style={{
            position: 'center',
            left: '50%',
            color: 'white',
            padding: 10,
            fontSize: 25,
          }}
        >
          <p align="center">{totalMinted}/5000 minted</p>
        </div>
        <div className="container" align="center">
          <MintButton />
        </div>
      </div>
      <div style={{ position: 'absolute', left: '50%', bottom: '10%' }}>
        <a
          href="https://testnets.opensea.io/collection/bonsaiverse-test-garden-v3"
          target="_blank"
        >
          <img height="30" src="/img/openseaIcon.png"></img>
        </a>
      </div>
    </div>
  );
}

// function socials() {
//   return (
//     <div>
//       <a />
//     </div>
//   );
// }

function MintButton({ totalMinted, getCount }) {
  const [counter, setCounter] = useState(1);
  let incrementCounter = () => setCounter(counter + 1);
  let decrementCounter = () => setCounter(counter - 1);

  if (counter <= 0) {
    decrementCounter = () => setCounter(0);
  }

  if (counter >= 20) {
    incrementCounter = () => setCounter(20);
  }

  let value = 0.01 * counter;

  const mint = async () => {
    const connection = contract.connect(signer);
    const addr = connection.address;
    const result = await contract.mintBonsai(counter, {
      value: ethers.utils.parseEther(value.toString()),
    });

    await result.wait();
    getCount();
  };

  return (
    <div
      style={{ position: 'center', flex: 'top', bottom: '50%', left: '47%' }}
    >
      <button className="btn btn-primary" onClick={mint}>
        Mint
      </button>
      <div>
        <div>
          <p style={{ color: 'white', padding: 10, fontSize: 25 }}>{counter}</p>
        </div>
        <div style={{ display: 'inline-flex' }}>
          <button onClick={incrementCounter}>+</button>
          <button onClick={decrementCounter}>-</button>
        </div>
      </div>
    </div>
  );
}

export default Home;
