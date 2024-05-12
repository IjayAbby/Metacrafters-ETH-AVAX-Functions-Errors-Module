// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract BasicDapp {

    address public owner;
    mapping(address => bool) public hasMinted;
    mapping(address => bool) public registeredUsers;
    address[] public allRegisteredUsers;
    mapping(address => string) public usersName;
    mapping(address => uint256) public userBalances;
    
    bool public isRegistrationOpen;

    constructor() {
        owner = msg.sender;
        isRegistrationOpen = true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the Owner");
        _;
    }

    modifier registrationOpen() {
        require(isRegistrationOpen == true, "New users currently not accepted");
        _;
    }

    event newRegistration(address indexed userAddress, string indexed nickname);
    event tokenMinted(address indexed userAddress, uint256 amount);
    event tokenTransfered(address indexed from, address indexed to, uint256 indexed amount);

    function changeRegistrationStatus(bool status) public onlyOwner() {
        if (isRegistrationOpen == status) {
            revert("Current status is same as new request");
        } 
        isRegistrationOpen = status;
    }

    function Register(string memory nickname) external {
        assert(!registeredUsers[msg.sender]);
        registeredUsers[msg.sender] = true;
        usersName[msg.sender] = nickname;
        allRegisteredUsers.push(msg.sender);
        emit newRegistration(msg.sender, nickname);
    }

    function Transfer(address to, uint256 amount) external {
        require(registeredUsers[msg.sender], "Sender is not registered");
        require(registeredUsers[to], "Receiver is not registered");
        require(userBalances[msg.sender] >= amount, "Insufficient balance");
        userBalances[msg.sender] -= amount;
        userBalances[to] += amount;
        emit tokenTransfered(msg.sender, to, amount);
    }

    function Mint() external {
        require(registeredUsers[msg.sender], "User is not registered");
        require(hasMinted[msg.sender] == false, "User has already minted tokens");
        hasMinted[msg.sender] = true;
        userBalances[msg.sender] += 100;
        emit tokenMinted(msg.sender, 100);
    }

}
