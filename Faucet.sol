pragma solidity ^0.5.11;
contract Faucet {
    function withdraw(uint _amount) external {
        msg.sender.transfer(_amount * (1 ether));
    }
    
    function getBalance() external view returns(uint){
        return address(this).balance;
    }
    
    function () external payable {
        
    }
}