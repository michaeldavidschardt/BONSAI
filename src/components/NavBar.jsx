import React from 'react';
import { Box, Button, Flex, Image, Link, Spacer } from '@chakra-ui/react';
import discordIcon from '../../img/discordPixel1.png';
import twitterIcon from '../../img/twitterPixel1.png';
import openseaIcon from '../../img/openseaPixel1.png';

const NavBar = ({ accounts, setAccounts }) => {
  const isConnected = Boolean(accounts[0]);

  async function connectAccount() {
    if (window.ethereum) {
      const accounts = await window.ethereum.request({
        method: 'eth_requestAccounts',
      });
      setAccounts(accounts);
    }
  }

  return (
    <Flex justify="space-between" align="center" padding="15px">
      {/* Left side - social media icons*/}
      <Flex justify="space-around" width="20%" padding="0 100px">
        <Link
          href="https://testnets.opensea.io/collection/bonsaiverse-test-garden-gzhjuay2cz"
          target="_blank"
        >
          <Image src={openseaIcon} boxSize="42px" margin="0 15px" />
        </Link>
        <Link href="https://twitter.com/NFTCryptoBonsai" target="_blank">
          <Image src={twitterIcon} boxSize="42px" margin="0 15px" />
        </Link>
        <Link href="https://discord.gg/8fQhNTgm" target="_blank">
          <Image src={discordIcon} boxSize="42px" margin="0 15px" />
        </Link>
      </Flex>

      {/* right side - sections and connect*/}

      <Flex justify="space-around" align="center" padding="30px">
        {/* Connect */}
        {isConnected ? (
          <Box margin="0 15px">Connected</Box>
        ) : (
          <Button
            backgroundColor="#6ea9fb"
            borderRadius="5px"
            boxShadow="0px 2px 2px 1px #0f0f0f"
            color="white"
            cursor="pointer"
            fontFamily="inherit"
            padding="5px"
            margin="0 15px"
            onClick={connectAccount}
          >
            Connect
          </Button>
        )}
      </Flex>
    </Flex>
  );
};

export default NavBar;
