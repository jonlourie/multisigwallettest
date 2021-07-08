pragma solidity 0.7.5;
pragma abicoder v2;

import "./destroy.sol";

//make the contract destroyable
//create a modifiier that inherits

contract MultiSigWallet is Destroy{
    

    address [] public owners;
    uint limit;
    
    struct Transfer {
        
        uint amount;
        address payable reciever;
        uint approvals;
        bool hasBeenSent;
        uint id;
    }
    
    event TransferRequestCreated(uint _id, uint _amount, address _initiator, address _receiver);
    event ApprovalReceived(uint _id, uint _approvals, address _approver );
    event TransferApproved(uint _id);
    
    Transfer[] transferRequests;
        
    mapping(address => mapping(uint => bool)) approvals; 
    
    modifier onlyOwners {
        
        bool owner = false;
        
        for(uint i = 0; i <owners.length; i++){
            
            if(owners[i] == msg.sender){ //we use the i variable to get the index number in the array for loops are how we seasrch arrays and indexes because they are numbered
                owner = true;
            }
        }
        require(owner = true);
        _; //forgot this underscore

    } 
    
    constructor(address[] memory _owners, uint _limit){
        
        owners = _owners;
        limit = _limit;
        
            
    }
    
    function deposit() public payable {
        
    }
    
    function createTransfer(uint _amount, address payable _receiver) public onlyOwners {
        
        emit TransferRequestCreated(transferRequests.length, _amount, msg.sender, _receiver);
        transferRequests.push(Transfer(_amount, _receiver, 0, false, transferRequests.length)); //we create a new Transfer object and push it inot the array
        
        
        
    }
    
    function approve(uint _id) public onlyOwners {
        require(approvals[msg.sender][_id] == false); //we require thye double mapping has been mapped to false
        require(transferRequests[_id].hasBeenSent == false); //we require the transferrequst for this ID has not been sent
        
        approvals[msg.sender][_id] == true; //we set the double mapping to true 
        transferRequests[_id].approvals++; //here we had to the approavals in this transfer request
        
        emit ApprovalReceived(_id, transferRequests[_id].approvals, msg.sender);
        
        //after we get the approvals for this transfer id we then make a transfer call to the receiver address 
        if(transferRequests[_id].approvals >= limit){
            transferRequests[_id].hasBeenSent == true;
            transferRequests[_id].reciever.transfer(transferRequests[_id].amount); 
            
            TransferApproved( _id);
        }
        
    }
    
    function getTransferRequests() public view returns (Transfer[] memory) {
        
        return transferRequests; //this is only possible because of abicoderV2
    }
    
}
    