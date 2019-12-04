pragma solidity ^0.5.11;

import "./Faucet.sol";

contract FaucetCall {
    Faucet f = new Faucet();
    
    function donate(uint _amout) external returns(bool){
        address(f).transfer(_amout * (1 ether));
        return true;
    }
    
    function getMoneny(uint _amout) external returns(bool){
        f.withdraw(_amout);
        return true;
    }
    
    function getBalance() external view returns(uint){
        return address(this).balance;
    }
    
    function getFAddress() external view returns(address){
        return address(f);
    }
    function () payable external {}
    
}
    