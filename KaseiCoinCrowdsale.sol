pragma solidity ^0.5.5;

import "./KaseiCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";


// Have the KaseiCoinCrowdsale contract inherit the following OpenZeppelin:
contract KaseiCoinCrowdsale is Crowdsale, MintedCrowdsale {
    
    // Provide parameters for all of the features of your crowdsale, such as the `rate`, `wallet` for fundraising, and `token`.
    constructor(
        uint rate, // rate in TKNbits
        address payable wallet, // sale beneficiary
        KaseiCoin token // the token that the KaseiCoinCrowdsale will work with
    )
        Crowdsale(rate, wallet, token)
        public
    {
        
    }
}

contract KaseiCoinCrowdsaleDeployer {

    address public kasei_token_address;
    address public kasei_crowdsale_address;

    constructor(
       string memory name,
       string memory symbol,
       address payable wallet //this address will receive all of the ETH from the crowdsale
    )
        public
    {
        // Create the KaseiCoin token
        KaseiCoin token = new KaseiCoin(name, symbol, 0);
        kasei_token_address = address(token);

        // Create the KaseiCoinCrowdsale and tell it about KaseiCoin
        KaseiCoinCrowdsale kasei_crowdsale = new KaseiCoinCrowdsale(1, wallet, token);
        kasei_crowdsale_address = address(kasei_crowdsale);

        // Set the `KaseiCoinCrowdsale` contract as a minter and have KaseiCoinCrowdsaleDeployer renounce its minter role.
        token.addMinter(kasei_crowdsale_address);
        token.renounceMinter();
    }
}