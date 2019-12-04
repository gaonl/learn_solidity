pragma solidity ^0.5.11;

/**
 * 规则：
 * 
 */
contract Bet {
    
    struct Better {
        //标志是否已经下注了
        bool bet;
        
        //标志是否已经执行提款操作了
        bool withdraw;
        
        //赌徒是否已经证明了他之前出的数
        bool prof;
        
        //赌徒下注的hash值
        //hash = sha3_256_keccack(256bit random + 8bit uint number)
        bytes32 guessHash;
    }
    
	//合约账户拥有者
    address owner;
	//此轮下注的资金池
    uint256 totalEther;
    
	//本轮下注的最少被赌徒选择的数字（比如：50这个数字只被一个人下注）
    uint8 maxCountNumber;
    
	//1-100之间下注的数的赌徒数量（比如：98这个数字下注的1000人）
    mapping(uint8 => uint32) numCount;
    
	//地址与赌徒的映射
    mapping(address => Better) beterMap;
    
    constructor() public {
        owner = msg.sender;
    }
    
    
    //下注
    function bet(bytes32 _guessHash) payable external returns(bool){
		//未下注
        require(beterMap[msg.sender].bet == false);
		//必须发送2个以太币，一个用于赌注，一个用于押金，prof过后押金退还
        require(msg.value == 2 ether);
        
		//已下注
        beterMap[msg.sender].bet = true;
        beterMap[msg.sender].prof = false;
        beterMap[msg.sender].withdraw = false;
        beterMap[msg.sender].guessHash = _guessHash;
        
		//资金池+2
        totalEther += 2;
        
        return true;
    }
    
    function prof(bytes32 _random, uint8 _number) external{
		//已下注并且还未prof
        require(beterMap[msg.sender].bet == true);
        require(beterMap[msg.sender].prof == false);
        
		//验证之前下注的散列
        assert(_profHash(_random,_number,beterMap[msg.sender].guessHash));
        
		//验证通过
        beterMap[msg.sender].prof = true;
		//下注的数字+1
        numCount[_number] += 1;
        if(numCount[_number] > numCount[maxCountNumber]){
            maxCountNumber = _number;
        }
		
		//本轮资金池必须 >=1
        require(totalEther >=1 );
        totalEther -=1;
		
		//退回押金
        msg.sender.transfer(1 ether);
    }
    
    function withdraw(bytes32 _random, uint8 _number) external returns(bool){
		//已经下注、已经证明通过、但是还未领取
        require(beterMap[msg.sender].withdraw ==  false);
        require(beterMap[msg.sender].prof ==  true);
        require(beterMap[msg.sender].bet ==  true);
		
		//验证之前下注的散列再验证一遍
        require(_profHash(_random,_number,beterMap[msg.sender].guessHash));
		//已经领取
        beterMap[msg.sender].withdraw ==  true;
        
		
		//如果选择正确，转账   资金池/此数字选中的人数  即评分资金池的资金
        if(maxCountNumber == _number){
            msg.sender.transfer(totalEther / numCount[maxCountNumber]);
        }
        
        return true;
        
    }
    
    function _profHash(bytes32 _random, uint8 _number, bytes32 hashed) private pure returns(bool){
        bytes memory data = new bytes(33);
        for(uint8 i = 0; i<32; i++){
            data[i] = _random[i];
        }
        data[32] = byte(_number);
        bytes32 _hashed = keccak256(data);
        assert(hashed == _hashed);
    }
    
    function nextRound() external{
        
    }
    
}
    