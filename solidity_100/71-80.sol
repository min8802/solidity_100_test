// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";

contract Q71 {
    /*
    숫자형 변수 a를 선언하고 a를 바꿀 수 있는 함수를 구현하세요.
    한번 바꾸면 그로부터 10분동안은 못 바꾸게 하는 함수도 같이 구현하세요.
    */

    uint a;
    uint setTime;

    function setA(uint _a) public returns(uint){
        require(block.timestamp-setTime > 600, "wait for 10 minutes.");
        a = _a;
        setTime = block.timestamp;
        return setTime;
    }
}

contract Q72 {
    /*
    1.  contract에 돈을 넣을 수 있는 deposit 함수를 구현하세요. 
    해당 contract의 돈을 인출하는 함수도 구현하되 오직 owner만 할 수 있게 구현하세요. 
    owner는 배포와 동시에 배포자로 설정하십시오. 한번에 가장 많은 금액을 예치하면 owner는 바뀝니다.
    
    예) A (배포 직후 owner), B가 20 deposit(B가 owner), C가 10 deposit(B가 여전히 owner), 
    D가 50 deposit(D가 owner), E가 20 deposit(D), E가 45 depoist(D), E가 65 deposit(E가 owner)
    */

    address owner;
    uint bgDeposit;

    constructor () {
        owner = msg.sender;
    }

    function deposit() public payable returns(uint){
        if(msg.value > bgDeposit) {
            bgDeposit = msg.value;
            owner = msg.sender;
        }
        return msg.value;
    }

    function withdraw(uint _n) public payable returns(uint) {
        require(owner == msg.sender, "you are not an owner");
        payable(msg.sender).transfer(_n);
        return _n;
    }
}

contract Q73 {
    /*
    1. 위의 문제의 다른 버전입니다. 누적으로 가장 많이 예치하면 owner가 바뀌게 구현하세요.
    
    예) A (배포 직후 owner), B가 20 deposit(B가 owner), C가 10 deposit(B가 여전히 owner),
    D가 50 deposit(D가 owner), E가 20 deposit(D), E가 45 depoist(E가 owner, E 누적 65), E가 65 deposit(E)
    */

    struct depoCustomer {
        address wallet;
        uint depositAmount;
    }

    depoCustomer[] customers;
    
    address owner;

    constructor () {
        owner = msg.sender;
    }

    //예치 -> 2중 맵핑 번호, 지갑 주소, 금액 = 번호(for문 돌림) or 2중 for문
    

    function deposit() public payable returns(uint){
        bool userCheck;

        for(uint i = 0; i < customers.length; i++) {
            if(customers[i].wallet == msg.sender) {
                customers[i].depositAmount += msg.value;
                userCheck = true;
            }
        } // 기존 고객이면 value가 업데이트 된 상태

        // 기존 고객 아니면 배열에 push
        if(userCheck != true) {
            customers.push(depoCustomer(msg.sender,msg.value));
        }
    
        // 내림차순으로 배열 0번째가 depositAmount가장 크게 변경
        for(uint i=0; i< customers.length; i++) {
            for(uint j=i+1; j< customers.length; j++) {
                if(customers[i].depositAmount < customers[j].depositAmount) {
                    //상태변수 customers[i] 랑 [j] 직접 바꾸면 copy? 에러나서 지역 변수 선언
                    depoCustomer memory temp1 = customers[i];
                    depoCustomer memory temp2 = customers[j];
                    customers[i] = temp2;
                    customers[j] = temp1;
                }
            }
        }

        // 배열 첫번째가 depositAmount 가장 큰 유저고 Owner
        owner = customers[0].wallet;
     
        return msg.value;
    }

    function withdraw(uint _n) public payable returns(uint) {
        require(owner == msg.sender, "you are not an owner");
        payable(msg.sender).transfer(_n);
        return _n;
    }

    function getCustomer() public view returns(depoCustomer[] memory) {
        return customers;
    }

    function getOwner() public view returns(address) {
        return owner;
    }
}

contract Q74 {
    /*
    1. 어느 숫자를 넣으면 항상 10%를 추가로 더한 값을 반환하는 함수를 구현하세요.
    
    예) 
       20 -> 22(20 + 2, 2는 20의 10%), 0 
    // 50 -> 55(50+5, 5는 50의 10%), 0 
    // 42 -> 46(42+4), 2 (42의 10%는 4.2 -> 46.2, 46과 2를 분리해서 반환) 
    // 27 => 29(27+2), 7 (27의 10%는 2.7 -> 29.7, 29와 7을 분리해서 반환)
    */

    // 20 -> 22 0
    // 21 -> 23.1 -> 23 1
    // 22 -> 24.2 -> 24 2 
    function operate(uint a) public pure returns(uint, uint) {
        uint answer = a + (a / 10);
        uint res = a % 10;
        if(res != 0) {
            return (answer, res);
        } else {
            return (answer, res);
        }
        
    }
}

contract Q75 {
    /*
    1. 문자열을 넣으면 n번 반복하여 쓴 후에 반환하는 함수를 구현하세요.
    
    예) abc,3 -> abcabcabc // ab,5 -> ababababab
    */

    function stringPrint(string memory _string, uint _n) public pure returns(string memory) {
        string memory result;
        for(uint i = 0; i < _n ; i++) {
            result = string(abi.encodePacked(result, _string));
        }
        return result;
    }
}

contract Q76 {

    /*
    숫자 123을 넣으면 문자 123으로 반환하는 함수를 직접 구현하세요. 
    (패키지없이)
    */

    //10이 넘었을 때를 좀 고민해봐야함
    function uintToString(uint a) public pure returns(string memory) {
        uint count;
        uint result = a;
        uint result1 = a;
        
        
        while(result > 0) {
            count++;
            result /= 10;
        }

        bytes memory temp = new bytes(count);
        for(uint i = 0; i<count;i++) {
            temp[count-i-1] = bytes1(uint8(0x30+result1%10));
            result1 /= 10;
        }
        
        bytes memory ans = abi.encodePacked(temp);
        //string() 사용하려면 bytes1이 아닌 bytes 형태로 변경




        return string(ans);
    }
}

contract Q77 {
    /*
    1. 위의 문제와 비슷합니다. 이번에는 openzeppelin의 패키지를 import 하세요.
    
    힌트 : import "@openzeppelin/contracts/utils/Strings.sol";
    */
    function uintToString(uint a) public pure returns(string memory) {
        return Strings.toString(a);
    }
}

contract Q78 {
    /*
    1. 숫자만 들어갈 수 있는 array를 선언하세요. 
    array 안 요소들 중 최소 하나는 10~25 사이에 있는지를 알려주는 함수를 구현하세요.
    
    예) [1,2,6,9,11,19] -> true (19는 10~25 사이) // [1,9,3,6,2,8,9,39] -> false (어느 숫자도 10~25 사이에 없음)
    */

    function checkArray(uint[] memory array) public pure returns(bool) {
        uint[] memory temp = array;
        for(uint i=0; i<temp.length; i++) {
            if(temp[i] > 10 && temp[i] <25) {
                return true;
            }
        }
        return false;
    }
}

contract Q79 {
    /*
    3개의 숫자를 넣으면 그 중에서 가장 큰 수를 찾아내주는 함수를 Contract A에 구현하세요. Contract B에서는 이름, 번호, 점수를 가진 구조체 학생을 구현하세요. 
    학생의 정보를 3명 넣되 그 중에서 가장 높은 점수를 가진 학생을 반환하는 함수를 구현하세요. 구현할 때는 Contract A를 import 하여 구현하세요.
    */
}

contract A {
    function bigNum(uint _a, uint _b, uint _c) public pure returns(uint) {
        uint bgNum = _a > _b ? (_a > _c ? _a : _c) : (_b > _c ? _b : _c);
        return bgNum;
    }
}

contract B {

    A a = new A();

    struct Student {
        string name;
        uint number;
        uint score;
    }

    Student[] students;

    function setS(string memory _name, uint _score) public {
        require(students.length < 3,"nope");
        students.push(Student(_name,students.length,_score));
    }

    function bestS() public view returns(uint) {
        uint num1 = students[0].score;
        uint num2 = students[1].score;
        uint num3 = students[2].score;

        return a.bigNum(num1,num2,num3);
    }

    function deleteS() public {
        delete students;
    }
}

contract Q80 {
    /*
    지금은 동적 array에 값을 넣으면(push) 가장 앞부터 채워집니다. 1,2,3,4 순으로 넣으면 [1,2,3,4] 이렇게 표현됩니다. 
    그리고 값을 빼려고 하면(pop) 끝의 숫자부터 빠집니다. 가장 먼저 들어온 것이 가장 마지막에 나갑니다. 이런 것들을FILO(First In Last Out)이라고도 합니다. 
    가장 먼저 들어온 것을 가장 먼저 나가는 방식을 FIFO(First In First Out)이라고 합니다. push와 pop을 이용하되 FIFO 방식으로 바꾸어 보세요.
    */

    uint[] public numArray;
    //1
    //pop -> push 2 -> push 1
    //2, 1 -> pop, pop -> push 3, push2, push 1
    //3,2,1 // 1,2,3 // 0번 2번 바뀜 1번 2번 바뀜
    //4,3,2,1 // 0번 3번 바뀜 1번 3번 바뀜 2번 3번 바뀜 4 3 2 1

    //2, 1
    function pushNum(uint a) public returns(uint[] memory){
        uint[] memory temp = numArray; //4,3
        uint[] memory temp1 = new uint[](numArray.length+1);
        if(numArray.length == 0) {
            numArray.push(a);
        } else { 
            for(uint i= 0; i < numArray.length; i++) {
                numArray.pop();
            }
            
            numArray.push(a); //2

            for(uint i=0; i < numArray.length; i++) {
                temp1[i] = numArray[i];
            }

            for(uint i=0; i < temp.length; i++) {
                temp1[i+1] = temp[i];
            }
        }
        return temp1;
    }

    function popNum() public {
        numArray.pop();
    }

    function getArray() public view returns(uint[] memory) {
        return numArray;
    }
    //80번 못 풀었습니다
}
