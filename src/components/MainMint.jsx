import { useState, useEffect } from 'react';
import { ethers, BigNumber } from 'ethers';
import { Box, Button, Flex, Input, Text, Image } from '@chakra-ui/react';
import BonsaiNFT from '../artifacts/contracts/bonsai.sol/CryptoBonsai.json';

const bonsaiAddress = '0x34907FEaca8aC04DD3b459c79CdfD3EFf7490537';

const MainMint = ({ accounts, setAccounts }) => {
  const [mintAmount, setMintAmount] = useState(1);
  const isConnected = Boolean(accounts[0]);
  const [totalMinted, setTotalMinted] = useState(0);

  function supply() {
    if (window.ethereum) {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const contract = new ethers.Contract(
        bonsaiAddress,
        BonsaiNFT.abi,
        signer
      );
      useEffect(() => {
        getCount();
      }, []);

      const getCount = async () => {
        const count = await contract.totalSupply();
        console.log(parseInt(count));
        setTotalMinted(parseInt(count));
      };
    }
  }
  supply();

  let value = 0.01 * mintAmount;

  async function handleMint() {
    if (window.ethereum) {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const contract = new ethers.Contract(
        bonsaiAddress,
        BonsaiNFT.abi,
        signer
      );

      try {
        const response = await contract.mintBonsai(mintAmount, {
          value: ethers.utils.parseEther(value.toString()),
        });
        console.log('response: ', response);
      } catch (err) {
        console.log('error: ', err);
      }
    }
  }

  const handleDecrement = () => {
    if (mintAmount <= 1) return;
    setMintAmount(mintAmount - 1);
  };

  const handleIncrement = () => {
    if (mintAmount >= 5) return;
    setMintAmount(mintAmount + 1);
  };

  return (
    <Flex justify="center" align="center" height="45vh" paddingTop="100px">
      <Box width="520px">
        <div>
          <Text fontSize="48px" textShadow="0 5px #000000">
            BONSAI
          </Text>
          <p></p>
        </div>
        {isConnected ? (
          <div>
            <Flex align="center" justify="center">
              <Button
                backgroundColor="#6ea9fb"
                borderRadius="5px"
                boxShadow="0px 2px 2px 1px #0f0f0f"
                color="white"
                cursor="pointer"
                fontFamily="inherit"
                padding="7px"
                marginTop="10px"
                onClick={handleDecrement}
              >
                -
              </Button>
              <Input
                readOnly
                fontFamily="inherit"
                width="50px"
                height="40px"
                textAlign="center"
                paddingLeft="12px"
                marginTop="10px"
                type="number"
                value={mintAmount}
              />
              <Button
                backgroundColor="#6ea9fb"
                borderRadius="5px"
                boxShadow="0px 2px 2px 1px #0f0f0f"
                color="white"
                cursor="pointer"
                fontFamily="inherit"
                padding="7px"
                marginTop="10px"
                onClick={handleIncrement}
              >
                +
              </Button>
            </Flex>
            <Button
              backgroundColor="#6ea9fb"
              borderRadius="5px"
              boxShadow="1px 2px 2px 1px #0F0F0F"
              color="white"
              cursor="pointer"
              fontFamily="inherit"
              padding="10px"
              marginTop="10px"
              onClick={handleMint}
            >
              Mint
            </Button>
            <div>
              <Text color="black" margin="10px">
                Supply: {totalMinted}/3333
              </Text>
              <Text color="black" margin="10px">
                Minting window: Testing
              </Text>
              <Text color="black" margin="10px">
                Max: 5 per wallet
              </Text>
              <Text color="black" margin="10px">
                Price: 0.03Ξ
              </Text>
            </div>
          </div>
        ) : (
          <div>
            <Text color="black">
              Bonsais are randomly generated and stored 100% on-chain.
            </Text>
            <Text color="black">Connect with MetaMask to mint :)</Text>
          </div>
        )}
      </Box>
    </Flex>
  );
};

export default MainMint;
