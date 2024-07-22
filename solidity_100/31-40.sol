// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

contract Q31 {
    /*
    1. string을 input으로 받는 함수를 구현하세요. "Alice"나 "Bob"일 때에만 true를 반환하세요.
    */
    
    function checkString(string memory _a) public pure returns(bool){
        if(keccak256(abi.encodePacked(_a)) == keccak256(abi.encodePacked("Alice")) || keccak256(abi.encodePacked(_a)) == keccak256(abi.encodePacked("Bob"))) {
            return true;
        } else {
            return false;
        }
    }
}

contract Q32 {
    /*2. 3의 배수만 들어갈 수 있는 array를 구현하되, 3의 배수이자 동시에 10의 배수이면 들어갈 수 없는 추가 조건도 구현하세요.
    예) 3 → o , 9 → o , 15 → o , 30 → x
    */

    function pushArray(uint _a) public pure returns(uint[] memory) {
        uint[] memory Array = new uint[](1);
        if(_a % 3 == 0 && _a % 10 != 0) {
            Array[0] = _a;
        }
        return Array;
    }
}

contract Q33 {
    /*
    이름, 번호, 지갑주소 그리고 생일을 담은 고객 구조체를 구현하세요. 
    고객의 정보를 넣는 함수와 고객의 이름으로 검색하면 
    해당 고객의 전체 정보를 반환하는 함수를 구현하세요.
    */

    struct customer {
        string name;
        uint number;
        address wallet;
        string birth;
    }

    mapping(string => customer) customers;
    uint customerNumber = 1;

    function setCustomer(string memory _name, string memory _birth) public {
        customers[_name] = customer(_name, customerNumber, msg.sender, _birth);
        customerNumber++;
    }

    function getCustomer(string memory _name) public view returns(customer memory) {
        return customers[_name];
    }
}

contract Q34 {
    /*
    이름, 번호, 점수가 들어간 학생 구조체를 선언하세요. 
    학생들을 관리하는 자료구조도 따로 선언하고 학생들의 전체 평균을 계산하는 함수도 구현하세요.
    */

    struct student {
        string name;
        uint number;
        uint score;
    }

    student[] students;
    uint studentNumber = 1;

    function setStudent(string memory _name, uint _score) public {
        students.push(student(_name, studentNumber,_score));
        studentNumber++;
    }

    function getAvg() public view returns(uint) {
        uint tot;
        for (uint i=0; i<students.length;i++) {
            tot += students[i].score;
        }
        return tot / students.length;
    }
}

contract Q35 {
    /*
    5. 숫자만 들어갈 수 있는 array를 선언하고 해당 array의 짝수번째 요소만 모아서 반환하는 함수를 구현하세요.
    
    예) [1,2,3,4,5,6] -> [2,4,6] // [3,5,7,9,11,13] -> [5,9,13]
    */

    function evenArray(uint[] memory _Array) public pure returns(uint[] memory){
        uint idx;
        uint inputArray = _Array.length;
        uint ArrayNumber;
        for(uint i=0;i<inputArray;i++) {
            if(_Array[i] % 2 == 0) {
                ArrayNumber++;
            }
        }

        uint[] memory Array = new uint[](ArrayNumber);
        
        for(uint i=0;i<inputArray;i++) {
            if(_Array[i] % 2 == 0) {
                Array[idx] = _Array[i];
                idx++;
            }
        }
        return Array;
    }
}

contract Q36 {
    /*
    high, neutral, low 상태를 구현하세요. a라는 변수의 값이 7이상이면 high, 4이상이면 neutral 그 이후면 low로 상태를 변경시켜주는 함수를 구현하세요.
    */

    mapping(uint=>string) a;

    function stateA(uint _a) public returns(string memory){
        if(_a >= 7) {
            a[_a] = "high";
        } else if(_a >= 4) {
            a[_a] = "neutral";
        } else {
            a[_a] = "low";
        }

        return a[_a];
    }
}

contract Q37 {
    /*
    7. 1 wei를 기부하는 기능, 1finney를 기부하는 기능 그리고 1 ether를 기부하는 기능을 구현하세요. 
    최초의 배포자만이 해당 smart contract에서 자금을 회수할 수 있고 다른 이들은 못하게 막는 함수도 구현하세요.
    (힌트 : 기부는 EOA가 해당 Smart Contract에게 돈을 보내는 행위, contract가 돈을 받는 상황)
    */

    address payable owner;

    constructor () {
        owner = payable(msg.sender);
    }

    modifier isOwner {
        require(msg.sender == owner, "nope");
        _;
    }

    function withDraw() public payable isOwner {
        payable(msg.sender).transfer(address(this).balance);
    } 

    function donate1wei() public payable{
        require(msg.value==1,"input value is 1wei");
            msg.value;
    }
    
    function donate1finney() public payable{
        require(msg.value==10**15,"input value is 1finney");
            msg.value;
    }
    
    function donate1ether() public payable{
        require(msg.value==10**18,"input value is 1ether");
            msg.value;
    }
}

contract Q38 {
    /*
    8. 상태변수 a를 "A"로 설정하여 선언하세요. 
    이 함수를 "B" 그리고 "C"로 변경시킬 수 있는 함수를 각각 구현하세요. 
    단 해당 함수들은 오직 owner만이 실행할 수 있습니다. owner는 해당 컨트랙트의 최초 배포자입니다.
    (힌트 : 동일한 조건이 서로 다른 두 함수에 적용되니 더욱 효율성 있게 적용시킬 수 있는 방법을 생각해볼 수 있음)
    */

    address owner;
    string public a = "A";

    constructor() {
        owner = msg.sender;
    }

    modifier isOwner {
        require(msg.sender == owner, "nope");
        _;
    }

    function setB() public isOwner{
        a = "B";
    }
    
    function setC() public isOwner{
        a = "C";
    }


}

contract Q39 {
    /*
    9. 특정 숫자의 자릿수까지의 2의 배수, 
    3의 배수, 5의 배수 7의 배수의 개수를 반환해주는 함수를 구현하세요.
    
    예) 15 : 7,5,3,2  (2의 배수 7개, 3의 배수 5개, 5의 배수 3개, 7의 배수 2개) 
    // 100 : 50,33,20,14  (2의 배수 50개, 3의 배수 33개, 5의 배수 20개, 7의 배수 14개)
    */

    function returnDigit(uint _n) public pure returns(uint,uint,uint,uint) {
        uint[] memory Array = new uint[](_n);
        uint idx;
        uint twoTimes;
        uint threeTimes;
        uint fiveTimes;
        uint sevenTimes;
        for(uint i=1; i < _n+1; i++) {
            if(i % 2 == 0) {
                twoTimes++;
            } 
            if(i % 3 == 0) {
                threeTimes++;
            } 
            if(i % 5 == 0) {
                fiveTimes++;
            } 
            if(i % 7 == 0) {
                sevenTimes++;
            }
            Array[idx] = i;
            idx++;
        }
        return (twoTimes,threeTimes,fiveTimes,sevenTimes);
    }
}

contract Q40 {
    /*
    10. 숫자를 임의로 넣었을 때 내림차순으로 정렬하고 가장 가운데 있는 숫자를 반환하는 함수를 구현하세요.
    가장 가운데가 없다면 가운데 2개 숫자를 반환하세요.
    예) [5,2,4,7,1] -> [1,2,4,5,7], 4 // [1,5,4,9,6,3,2,11] -> [1,2,3,4,5,6,9,11], 4,5 // [6,3,1,4,9,7,8] -> [1,3,4,6,7,8,9], 6
    */

    function descending(uint[] memory Array) public pure returns(uint[] memory, uint[] memory) {
        uint ArrayLength = Array.length;
        uint[] memory _Array = new uint[](ArrayLength);
        
        for(uint i=0; i<Array.length; i++) {
            _Array[i] = Array[i];
        }

        for (uint i = 0; i<ArrayLength; i++) {
            for (uint j= i+1; j<ArrayLength; j++) {
                if(_Array[i] > _Array[j]) {
                    (_Array[i], _Array[j]) = (_Array[j], _Array[i]);
                }
            }
        }

        if(ArrayLength % 2 ==0) {
            uint[] memory midnum = new uint[](2);
            midnum[1] = _Array[(ArrayLength/2)];
            midnum[0] = _Array[(ArrayLength/2)-1];
            return (_Array, midnum);
        } else {
            uint[] memory midnum = new uint[](1);
            midnum[0] = _Array[(ArrayLength/2)];
            return (_Array, midnum);
        }
    }
}