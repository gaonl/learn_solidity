pragma solidity ^0.5.11;

contract ArrayTest {
    bytes32 public  b32;
    bytes public bs = new bytes(0);
    byte[] public bsArray = new byte[](0);
    byte[5] public bsArray5;
    
    function test() public {
        bytes1 b1 = 0x00;
        b32 = hex"0101010101010101010101010101010101010101010101010101010101010101";
        bs.push(0xFF);
        bsArray.push(0xFF);
        bsArray5[3] = 0xBB;
        
        byte[] memory bmemory = new byte[](10);
    }
    
    
}