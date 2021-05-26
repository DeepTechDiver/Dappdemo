pragma solidity ^0.4.25;

import "./Table.sol";

contract StudentScoreByCRUD {
    address private _owner;
    
    modifier onlyOwner {
        require(_owner == msg.sender, "Auth: only owner is authorized");
        _;
    }
    
    constructor () public {
        _owner = msg.sender;
    }

    //事件定义
    event createEvent(address owner, string tableName);
    event insertEvent(address studentId, string courseName, int score);
    event updateEvent(address studentId, string courseName, int score);
    event removeEvent(address studentId, string courseName);
    
    //创建成绩表
    function create() public onlyOwner returns(int){
        TableFactory tf =TableFactory(0x1001);
        int count =tf.createTable("stu_score", "student_id", "course_name, score");
        emit createEvent(msg.sender, "stu_score");
        return count;
    }
    // 新增成绩
    function insert(address studentId, string courseName, int score) public onlyOwner returns(int) {
        TableFactory tf = TableFactory(0x1001);
        Table table = tf.openTable("stu_score");
        
        string memory stuIdStr = addressToString(studentId);
        Entry entry = table.newEntry();
        entry.set("student_id", stuIdStr);
        entry.set("student_name", courseName);
        entry.set("score", score);
        
        int count = table.insert(stuIdStr, entry);
        emit insertEvent(studentId, courseName, score);
        return count;
        
    }
    function addressToString(address addr) private pure returns(string) {
        bytes20 value = bytes20(uint160(addr));
        bytes memory strBytes = new bytes(42);
        
        strBytes[0] = '0';
        strBytes[1] = 'x';
        
        for(uint i=0;i<20;i++){
            uint8 byteValue = uint8(value[i]);
            strBytes[2 + (i<<1)] = encode(byteValue >> 4);
            strBytes[3 + (i<<1)] = encode(byteValue & 0x0f);
        }
        return string(strBytes);
    }
    function encode(uint8 num) private pure returns(byte){
        if(num >= 0 && num <= 9) {
            return byte(num + 48);
        }
        return byte(num + 87);
    }
    
    // 更新成绩
    function update(address studentId,string courseName,int newScore) public onlyOwner returns(int) {
        TableFactory tf = TableFactory(0x1001);
        Table table = tf.openTable("stu_score");
        
        Entry entry = table.newEntry();
        entry.set("score", newScore);
        
        string memory stuIdStr = addressToString(studentId);
        Condition conditioan = table.newCondition();
        conditioan.EQ("student_id", stuIdStr);
        conditioan.EQ("course_name", courseName);
        
        int count = table.update(stuIdStr,entry, conditioan);
        emit updateEvent(studentId, courseName, newScore);
        return count;
    }
    
    // 删除成绩
    function remove(address studentId,string courseName) public onlyOwner returns(int) {
        TableFactory tf = TableFactory(0x1001);
        Table table = tf.openTable("stu_score");
        
        string memory stuIdStr = addressToString(studentId);
        Condition conditioan = table.newCondition();
        conditioan.EQ("student_id", stuIdStr);
        conditioan.EQ("course_name", courseName);
        
        int count = table.remove(stuIdStr, conditioan);
        emit removeEvent(studentId, courseName);
        return count;
    }
    
    
    //查询成绩
    function select(string courseName) public view returns(int) {
        TableFactory tf = TableFactory(0x1001);
        Table table = tf.openTable("stu_score");
        
        string memory stuIdStr = addressToString(msg.sender);
        Condition conditioan = table.newCondition();
        conditioan.EQ("student_id", stuIdStr);
        conditioan.EQ("course_name", courseName);
        
        Entries entries = table.select(stuIdStr,conditioan);
        
        if(entries.size() == 0) return 0;
        return entries.get(0).getInt("score");
        
        
    }
}









