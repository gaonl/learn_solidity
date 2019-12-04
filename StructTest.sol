pragma solidity ^0.5.11;
pragma experimental ABIEncoderV2;

contract StructTest {
    struct Person {
        uint8 age;
        string name;
    }
    
    Person p1 = Person(12,"abc");
    Person p2;
    
    function test() public {
        Person memory tmp = Person(13,"def");
        
        p2 = tmp;
        
    }
    
    function getPersonInfo() public view returns(Person memory){
        return p2;
    }
    
    
}