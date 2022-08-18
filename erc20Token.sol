// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

interface ERC20Interface {
    function totalSupply() external view returns (uint); // mandatory function
    function balanceOf(address tokenOwner) external view returns (uint balance); // mandatory function
    function transfer(address to, uint tokens) external returns (bool success); // mandatory function
    
    function allowance(address tokenOwner, address spender) external view returns (uint remaining); // optional function
    function approve(address spender, uint tokens) external returns (bool success); // optional function
    function transferFrom(address from, address to, uint tokens) external returns (bool success); // optional function
    
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract Cryptos is ERC20Interface {
    string public name = 'Cryptos';
    string public symbol = 'CRPT';
    uint public decimals = 0; //18
    uint public override totalSupply;

    address public founder;
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowed;

    constructor() {
        totalSupply = 1000000;
        founder = msg.sender;
        balances[founder] = totalSupply;
    }

    function balanceOf(address tokenOwner) public view override returns(uint balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public override returns (bool success) {
        require(balances[msg.sender] >= tokens, 'You dont have enough tokens in your account.');

        balances[msg.sender] -= tokens;
        balances[to] += tokens;
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function allowance(address tokenOwner, address spender) public view override returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function approve(address spender, uint tokens) public override returns (bool success) {
        require(balances[msg.sender] >= tokens);
        require(tokens > 0);
        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        return true;
    }

     function transferFrom(address from, address to, uint tokens) public override returns (bool success) {
         require(allowed[from][msg.sender] >= tokens);
         require(balances[from] >= tokens);
         balances[from] -= tokens;
         balances[to] += tokens;
         allowed[from][msg.sender] -= tokens;

         emit Transfer(from, to, tokens);

         return true;
     }

    

}