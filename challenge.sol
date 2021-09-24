pragma solidity ^0.5.16;

contract challenge2{
    
    uint8 public players;
    uint public stake;
    address owner;
    mapping(address => uint) public ppstake;
    uint8 i = 0;
    address[] public playerAddr = new address[](players);
    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;
    
    constructor(uint8 _players, uint _stake) public{ 
        require(_players >= 3);
        players = _players;
        stake = _stake;
        owner = msg.sender;
        
    }
    
    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }
    
    event winnerDeclared(
        uint winnerID
    );
    
    function staking() public payable{
        require(msg.sender != owner);
        playerAddr.push(msg.sender);
        if(msg.value > stake){
            ppstake[msg.sender] = stake;
        }else{
            ppstake[msg.sender] = msg.value;
        }
        
       
    }
    
   
    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }
    
    function pickWinner() public{
        require(playerAddr.length == players);
        uint index=random()%players;
        emit winnerDeclared(index);
        compensate(index, payable(playerAddr[index]));
    }
    
    function compensate(uint _winner, address payable _winnerAddress) private{
        uint256 winnerCompensation = address(this).balance * 99 / 100;
        _winnerAddress.transfer(winnerCompensation);
    }
    
    function viewBalance() public view onlyOwner returns(uint){
        return address(this).balance;
    }
}