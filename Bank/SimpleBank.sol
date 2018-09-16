pragma solidity ^0.4.25;

import "./Ownable.sol";
import "./SafeMath.sol";

contract Bank is Ownable {
    
    using SafeMath for uint;

    mapping(address => uint) private balances;
    bool deprecated = false;
    
    modifier nonDeprecatedContract() {
        require(!deprecated);
        _;
    }
    
    modifier nonZeroAmount(uint _amount) {
        require(_amount > 0);
        _;
        
    }
    
    function min(uint _a, uint _b) pure internal returns (uint) {
        if(_a < _b) return _a;
        return _b;
    }
    
    function deposit() external nonDeprecatedContract nonZeroAmount(msg.value) payable {
        balances[msg.sender] = balances[msg.sender].add(msg.value);
    }
    
    function withdraw(uint _amount) external  {
        uint finalAmount = min(balances[msg.sender], _amount);
        balances[msg.sender] = balances[msg.sender].sub(finalAmount);
        msg.sender.transfer(finalAmount);
    }
    
    function checkBalance() external view returns(uint) {
        return balances[msg.sender];
    }
    
    function transfer(uint _amount, address _to) external nonZeroAmount(_amount) nonDeprecatedContract {
        require(_amount <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        balances[_to] = balances[_to].add(_amount);
    }
    
    /* Fail-safe */
    function disableContract() public onlyOwner {
        deprecated = true;
    }
    
}