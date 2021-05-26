pragma solidity ^0.4.25;

contract StudentScoreBySol {
    // owner为合约的创建者
    address private _owner;
    // _scores用于存储学生成绩 第一个mapping为学生的账户 对应的bytes32为科目 对应的uint8成绩
    mapping(address => mapping(bytes32 => uint8)) private _scores;
    
    //一个事件setScoreEvent，用于跟踪对学生成绩的新增/修改操作
    event setScoreEvent(address studentId, bytes32 courseName, uint8 score);
    
    //修饰器要求必须是合约的Owner才能进行后续操作，其中Owner为考试管理中心
    modifier onlyOwner {
        require(_owner == msg.sender, "Auth: only owner is authorized");
        _;
    }
    
    // 构造方法用于实例化合约，在当前构造方法中，指定Owner为合约的部署者。
    constructor () public {
        _owner = msg.sender;
    }
    
    //setScore函数用于新增/修改/删除（score置为0）学生成绩
    function setScore(address studentId, bytes32 courseName, uint8 score) public onlyOwner returns(bool){
        _scores[studentId][courseName] = score;
        emit setScoreEvent(studentId, courseName, score);
        return true;
    }
    //getScore方法用于成绩查询
    function getScore(bytes32 courseName) public view returns(uint8) {
        return _scores[msg.sender][courseName]; 
    }
}
