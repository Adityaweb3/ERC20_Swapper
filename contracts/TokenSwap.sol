pragma solidity ^0.8.0;
// Contrat address :  0x5FbDB2315678afecb367f032d93F642f64180aa3 


contract TokenSwap {

    // In this mapping we are storing the balance of tokens for every users . 
    // It maps user address to another mapping that maps the token address to their corresponding balances

    mapping(address => mapping(address => uint256)) public balances;
    address public owner;

    
    event TokensExchanged(address indexed user, address indexed tokenA, uint256 amountA, address indexed tokenB, uint256 amountB);
    
    constructor() {
        owner = msg.sender;
    }
    
    function exchangeTokens(address tokenA, address tokenB, uint256 amountA, uint256 amountB) external {
        require(amountA > 0 && amountB > 0, "Invalid amount");
        require(tokenA != address(0) && tokenB != address(0), "Invalid token address");
        
        require(balances[tokenA][msg.sender] >= amountA, "Insufficient balance for token A");
        require(balances[tokenB][msg.sender] >= amountB, "Insufficient balance for token B");
        
        balances[tokenA][msg.sender] -= amountA;
        balances[tokenB][msg.sender] -= amountB;
        
        balances[tokenA][msg.sender] += amountB;
        balances[tokenB][msg.sender] += amountA;
        
        emit TokensExchanged(msg.sender, tokenA, amountA, tokenB, amountB);
    }
    
    function depositTokens(address token, uint256 amount) external {
        require(token != address(0), "Invalid token address");
        require(amount > 0, "Invalid amount");
        
        require(balances[token][msg.sender] + amount >= balances[token][msg.sender], "Balance overflow");
        
        bool success = false;
        if (isContract(token)) {
            (success, ) = token.call(abi.encodeWithSignature("transferFrom(address,address,uint256)", msg.sender, address(this), amount));
        } else {
            revert("Token is not a contract");
        }
        
        require(success, "Token transfer failed");
        
        balances[token][msg.sender] += amount;
    }
    
    function withdrawTokens(address token, uint256 amount) external {
        require(token != address(0), "Invalid token address");
        require(amount > 0, "Invalid amount");
        require(balances[token][msg.sender] >= amount, "Insufficient balance");
        
        bool success = false;
        if (isContract(token)) {
            (success, ) = token.call(abi.encodeWithSignature("transfer(address,uint256)", msg.sender, amount));
        } else {
            revert("Token is not a contract");
        }
        
        require(success, "Token transfer failed");
        
        balances[token][msg.sender] -= amount;
    }
    
    function isContract(address token) internal view returns (bool) {
        uint32 size;
        assembly {
            size := extcodesize(token)
        }
        return (size > 0);
    }
    
    function transferOwnership(address newOwner) external {
        require(msg.sender == owner, "Only the contract owner can call this function");
        require(newOwner != address(0), "Invalid address");
        
        owner = newOwner;
    }
}
