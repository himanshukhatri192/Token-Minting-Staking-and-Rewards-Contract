//This is a basic smart contract for a DeFi App
//The contract allows users to deposit and withdraw ether and tokens
//The contract also has a function to get the balance of the contract

//Contract definition
// SPDX-License-Identifier: MIT
pragma solidity^0.8.0;
contract DeFiApp {
    mapping(address => uint) public balances;
    address public owner;

    //Event emitted when deposit is made
    event Deposit(address indexed account, uint amount);

    //Event emitted when withdrawal is made
    event Withdrawal(address indexed account, uint amount);

    //Constructor function
    constructor() {
        owner = msg.sender;
    }

    //Function to deposit ether
    function depositEther() public payable {
        require(msg.value > 0, "Amount must be greater than 0");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    //Function to deposit tokens
    function depositToken(address token, uint amount) public {
        require(amount > 0, "Amount must be greater than 0");
        require(ERC20(token).transferFrom(msg.sender, address(this), amount), "Transfer failed");
        balances[msg.sender] += amount;
        emit Deposit(msg.sender, amount);
    }

    //Function to withdraw ether
    function withdrawEther(uint amount) public {
        require(amount > 0, "Amount must be greater than 0");
        require(amount <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }

    //Function to withdraw tokens
    function withdrawToken(address token, uint amount) public {
        require(amount > 0, "Amount must be greater than 0");
        require(amount <= balances[msg.sender], "Insufficient balance");
        require(ERC20(token).transfer(msg.sender, amount), "Transfer failed");
        balances[msg.sender] -= amount;
        emit Withdrawal(msg.sender, amount);
    }

    //Function to get the balance of the contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

//ERC20 interface
interface ERC20 {
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
    function transfer(address recipient, uint amount) external returns (bool);
}
