// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract EmadTkn {
    string public name = "EmadTkn";
    string public symbol = "EMAD";
    uint8 public  immutable decimals = 18;
    bool public tradingEnabled = false;
    uint256 private  _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private  _allowances;
    address public _owner;
    

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor( uint256 initialSupply) {
        uint256 supply = initialSupply * 10 ** uint256(decimals);

        _totalSupply = supply ;
        _balances[msg.sender] = supply;
        _owner = msg.sender;
        emit Transfer(address(0), msg.sender, supply);
    }
    modifier onlyOwner() {
        require(msg.sender == _owner, "Caller is not the owner");
        _;
    }

    modifier tradingOpen(){
        require(tradingEnabled || msg.sender == _owner, "Trading is not enabled");
        _;
    }

    modifier validAddress(address account){
        require(account != address(0), "Invalid address");
        _;
    }

    function balanceOf(address owner) public view returns (uint256) {
       return _balances[owner];
    }

    function allowance(address owner, address spender) public view returns (uint256){
        return _allowances[owner][spender];
    }

    function totalSupply() public view returns (uint256) {
       return _totalSupply;
    }
    function renounceOwnership() public onlyOwner()  {
        require(tradingEnabled, "Enable trading before renouncing");
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function enableTrading() external onlyOwner {
        tradingEnabled = true;
    }


    function _transfer(address from, address to, uint256 value) internal validAddress(to)  {
        uint256 fromBal = _balances[from];
        require(fromBal >= value, "Insufficient balance");

        unchecked {
            _balances[from] = fromBal - value;
        }

        _balances[to] += value;

        emit Transfer(from, to, value);
    }

    function transfer(address to, uint256 value) public  tradingOpen returns (bool){
        _transfer(msg.sender, to, value);
        return true;
    }
    function approve(address spender, uint256 value) public validAddress(spender) returns (bool) {
        require(value == 0 || _allowances[msg.sender][spender] == 0, "Set to zero first");
        _allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }   

    function transferFrom(address from, address to, uint256 value) public  tradingOpen returns (bool) {
        uint256 allowed = _allowances[from][msg.sender];
        require(allowed >= value, "Allowance exceeded");

        unchecked {
            _allowances[from][msg.sender] = allowed - value;
        }

        _transfer(from, to, value);
        return true;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function mint(uint256 value) external onlyOwner returns (bool) {
         uint256 amount = value * 10 ** decimals;
        _totalSupply += amount;
        _balances[_owner] += amount;
        emit Transfer(address(0), _owner, amount);
        return true;
    }
    
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _allowances[msg.sender][spender] += addedValue;
        emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        uint256 current = _allowances[msg.sender][spender];
        require(current >= subtractedValue, "Decreased below zero");
        unchecked {
            _allowances[msg.sender][spender] = current - subtractedValue;
        }
        emit Approval(msg.sender, spender, current - subtractedValue);
        return true;
    }

    function burn(uint256 value) external onlyOwner returns (bool) {
        uint256 amount = value * (10 ** uint256(decimals));

        uint256 ownerBal = _balances[_owner];
        require(ownerBal >= amount, "Insufficient balance");

        unchecked {
            _balances[_owner] = ownerBal - amount;
            _totalSupply -= amount;
        }

        emit Transfer(_owner, address(0), amount);
        return true;
    }    
}