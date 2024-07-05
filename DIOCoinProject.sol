// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

interface ERC20Interface {
    function totalSupply() external view returns (uint256);
    function balanceOf(address tokenOwner) external view returns (uint256 balance);
    function allowance(address tokenOwner, address spender) external view returns (uint256 remaining);

    function transfer(address to, uint256 tokens) external returns (bool success);
    function approve(address spender, uint256 tokens) external returns (bool success);
    function transferFrom(address from, address to, uint256 tokens) external returns (bool success);

    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
}

contract DIOToken is ERC20Interface {

    string public symbol = "DIO";
    string public name = "DIO Coin";
    uint8 public decimals = 2;
    uint256 private _totalSupply;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    constructor() {
        _totalSupply = 1000000;
        balances[msg.sender] = _totalSupply;

        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function totalSupply() public override view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    function allowance(address tokenOwner, address spender) public override view returns (uint256 remaining) {
        return allowed[tokenOwner][spender];
    }

    function transfer(address to, uint256 tokens) public override returns (bool success) {
        require(to != address(0), "Cannot transfer to the zero address");
        require(tokens <= balances[msg.sender], "Insufficient balance");

        balances[msg.sender] = balances[msg.sender] - tokens;
        balances[to] = balances[to] + tokens;
        emit Transfer(msg.sender, to, tokens);

        return true;
    }

    function approve(address spender, uint256 tokens) public override returns (bool success) {
        require(spender != address(0), "Cannot approve the zero address");

        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);

        return true;
    }

    function transferFrom(address from, address to, uint256 tokens) public override returns (bool success) {
        require(to != address(0), "Cannot transfer to the zero address");
        require(tokens <= balances[from], "Insufficient balance");
        require(tokens <= allowed[from][msg.sender], "Transfer amount exceeds allowance");

        balances[from] = balances[from] - tokens;
        allowed[from][msg.sender] = allowed[from][msg.sender] - tokens;
        balances[to] = balances[to] + tokens;

        emit Transfer(from, to, tokens);

        return true;
    }

    function mint(uint256 amount) public returns (bool success) {
        _totalSupply = _totalSupply + amount;
        balances[msg.sender] = balances[msg.sender] + amount;

        emit Transfer(address(0), msg.sender, amount);

        return true;
    }

    function burn(uint256 amount) public returns (bool success) {
        require(amount <= balances[msg.sender], "Insufficient balance to burn");

        _totalSupply = _totalSupply - amount;
        balances[msg.sender] = balances[msg.sender] - amount;

        emit Transfer(msg.sender, address(0), amount);

        return true;
    }
}