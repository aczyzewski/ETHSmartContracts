pragma solidity ^0.4.19;

// According to:
// https://medium.com/coinmonks/write-a-simple-contract-on-top-of-ethereum-92b543594e84

contract Auction {
    
    // -- Notes: --
    //  > uint/int are aliases for uint256/int256
    // -- End --
    
    address public manager;         // Represents the auction house
    address public seller;          // Seller wants to auction items
    
    uint public latestBid;         // Amount
    address public latestBidder;    // Bidder
  
  
    // When a contract is created, its constructor (a function declared with 
    // the constructor keyword) is executed once. A constructor is optional. 
    // Only one constructor is allowed.
    constructor() public {
        
        // When you call the function externally (in this case it is called 
        // implicitly when you create a smart contract), the msg variable 
        // represents the address that run that function. 
        manager = msg.sender;
    }
    
    function auction(uint bid) public {
        // 1 ether is 1000000000000000000 wei.
        latestBid = bid * 1 ether;
        seller = msg.sender;
    }
    
    function bid() public payable {
        
        // Check whether the amount of money that they send along with this 
        // invocation of function is greater than the latestBid
        require(msg.value > latestBid);
        
        if(latestBidder != 0x0){
            latestBidder.transfer(latestBid);        
        }
        
        latestBidder = msg.sender;
        latestBid = msg.value;

    }
    
    // This function can only be executed with manager address.
    function finishAuction() restricted public {
        seller.transfer(address(this).balance);
    }
    
    modifier restricted() {
        require(msg.sender == manager);
        
        // The code for the function being modified is inserted 
        // where the _ is placed in the modifier.
        _;
    }
    
    // More about "_;":
    //      - The code for the function being modified is inserted where 
    //        the _ is placed in the modifier.
    //      - You can add more than one _s in the modifier code. And the code 
    //        of the function being modified is inserted in each place 
    //        where _ is located in the modifier (depends on solc compiler)
    //      - The modifiers gets called in the sequence they were defined 
    //        (checkOne checkTwo checkThree) and at the end of the function, 
    //        they are called in reverse. The modifiers seem to be applied 
    //        like a stack.
    
    
    
}