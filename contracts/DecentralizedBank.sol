pragma solidity >=0.6.0 <0.8.0;

contract DecentralizedBank {  

  mapping(address => uint) public depositStart;
  mapping(address => uint) public etherBalanceOf;
  mapping(address => uint) public collateralEther;

  mapping(address => bool) public isDeposited;
  mapping(address => bool) public isBorrowed;

  function deposit() payable public {
    require(isDeposited[msg.sender] == false, 'Error, deposit already active');
    require(msg.value>=1e16, 'Error, deposit must be >= 0.01 ETH');

    etherBalanceOf[msg.sender] = etherBalanceOf[msg.sender] + msg.value;
    depositStart[msg.sender] = depositStart[msg.sender] + block.timestamp;

    isDeposited[msg.sender] = true; //activate deposit status  
  }

  function withdraw() public {
    require(isDeposited[msg.sender]==true, 'Error, no previous deposit');
    uint userBalance = etherBalanceOf[msg.sender]; //for event

    
    uint depositTime = block.timestamp - depositStart[msg.sender];

    


    uint interestPerSecond = 31668017 * (etherBalanceOf[msg.sender] / 1e16);
    uint interest = interestPerSecond * depositTime;

    
    msg.sender.transfer(etherBalanceOf[msg.sender]); //eth back to user
   

  
    depositStart[msg.sender] = 0;
    etherBalanceOf[msg.sender] = 0;
    isDeposited[msg.sender] = false;    
  }

  function borrow() payable public {
    require(msg.value>=1e16, 'Error, collateral must be >= 0.01 ETH');
    require(isBorrowed[msg.sender] == false, 'Error, loan already taken');

    
    collateralEther[msg.sender] = collateralEther[msg.sender] + msg.value;

    
    uint tokensToMint = collateralEther[msg.sender] / 2;

    
    isBorrowed[msg.sender] = true;    
  }

  function payOff() public {
    require(isBorrowed[msg.sender] == true, 'Error, loan not active');    

    uint fee = collateralEther[msg.sender]/10; //calc 10% fee

    
    msg.sender.transfer(collateralEther[msg.sender]-fee);

    collateralEther[msg.sender] = 0;
    isBorrowed[msg.sender] = false;    
  }
}

