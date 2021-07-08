pragma solidity 0.7.5;

contract Destroy {
    
    function destroy() public {
        
        address payable receiver = msg.sender;
        selfdestruct(receiver);
        
    }

}