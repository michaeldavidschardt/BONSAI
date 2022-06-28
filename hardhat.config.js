/**
 * @type import('hardhat/config').HardhatUserConfig
 */
let secret = require('./secret');

require('@nomiclabs/hardhat-waffle');
require('@nomiclabs/hardhat-etherscan');
require('hardhat-contract-sizer');

module.exports = {
  networks: {
    rinkeby: {
      url: secret.url,
      accounts: [secret.key],
    },
  },
  etherscan: {
    apiKey: secret.eKey,
  },
  solidity: {
    version: '0.8.8',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
        details: {
          yul: true,
          // Tuning options for the Yul optimizer.
          yulDetails: {
            //   // Improve allocation of stack slots for variables, can free up stack slots early.
            //   // Activated by default if the Yul optimizer is activated.
            stackAllocation: true,
            //   // Select optimization steps to be applied.
            //   // Optional, the optimizer will use the default sequence if omitted.
            optimizerSteps: 'dhfoDgvulfnTUtnIf',
          },
        },
      },
    },
  },
};
