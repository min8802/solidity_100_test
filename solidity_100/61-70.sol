// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";

contract Q61 {
    /*
    a의 b승을 반환하는 함수를 구현하세요.
    */

    function squareB(uint a, uint b) public pure returns(uint){
        return a ** b;
    }
}

contract Q62 {
    /*
    2개의 숫자를 더하는 함수, 곱하는 함수 a의 b승을 반환하는 함수를 구현하는데
    3개의 함수 모두 2개의 input값이 10을 넘지 않아야 하는 조건을 최대한 효율적으로 구현하세요.
    */
    //

    modifier checkOverTen(uint a, uint b) {
        require(a+b < 10, "nope");
        _;
    }

    function add(uint a, uint b) public pure checkOverTen(a, b) returns(uint) {
        return (a+b);
    }
    
    function multiple(uint a, uint b) public pure checkOverTen(a, b) returns(uint) {
        return (a*b);
    }
    
    function square(uint a, uint b) public pure checkOverTen(a, b) returns(uint) {
        return (a**b);
    }
}

contract Q63 {
    /*
    2개 숫자의 차를 나타내는 함수를 구현하세요.
    */

    function sub(uint a, uint b) public pure returns(uint) {
        return (a > b ? a - b: b -a); 
    }
}

contract Q64 {
    /*
    지갑 주소를 넣으면 5개의 4bytes로 분할하여 반환해주는 함수를 구현하세
    */
    function addressToBytes(address _addr) public pure returns(bytes[] memory) {
        bytes memory result =  abi.encodePacked(_addr);
        bytes[] memory answerBytes = new bytes[](5);
        for (uint i=0; i < answerBytes.length; i++) {
            bytes memory fourBytes = new bytes(4);
            for(uint j=0; j < fourBytes.length; j++) {
            fourBytes[j] = result[j+(i*4)];
            }
            answerBytes[i] = fourBytes;
        }
        return answerBytes;
    }
}

contract Q65 {
    /*
    숫자 3개를 입력하면 그 제곱을 반환하는 함수를 구현하세요.
    그 3개 중에서 가운데 출력값만 반환하는 함수를 구현하세요.
    */
    function square(uint a, uint b, uint c) public pure returns(uint) {
        uint result = a > b ? (b > c ? b : (a > c ? c : a) ) : (a > c ? a : (b > c ? c : b));
        return result ** 2;
    }
}

contract Q66 {
    /*
    특정 숫자를 입력했을 때 자릿수를 알려주는 함수를 구현하세요. 
    추가로 그 숫자를 5진수로 표현했을 때는 몇자리 숫자가 될 지 알려주는 함수도 구현하세요.
    */
    function digit(uint _n) public pure returns(uint) {
        uint digitNum;
        
        while(_n > 0) {
            _n /= 10;
            digitNum++;
        }

        return digitNum;
    }

    function fifthDigit(uint _n) public pure returns(uint) {
        uint fifthDigitNum;

        while(_n > 0) {
            _n /= 5;
            fifthDigitNum++;
        }

        return fifthDigitNum;
    }
}

contract Q67 {
    /*
    1. 자신의 현재 잔고를 반환하는 함수를 보유한 Contract A와 다른 주소로 돈을 보낼 수 있는 Contract B를 구현하세요.
    
    B의 함수를 이용하여 A에게 전송하고 A의 잔고 변화를 확인하세요.
    */
}

contract A {
    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    receive() external payable {}
}

contract B {
    function sendMoney(address _addr, uint _n) public payable returns(uint) {
        payable(_addr).transfer(_n);
        return msg.value;
    }

    function deposit() public payable {

    }
}

contract Q68 {
    /*
    1. 계승(팩토리얼)을 구하는 함수를 구현하세요. 계승은 그 숫자와 같거나 작은 모든 수들을 곱한 값이다. 
    */

    function factorial(uint _n) public pure returns(uint) {
        uint result = 1;
        while(_n > 0) {
            result *= _n;
            _n--;
        }
        return result;
    }
}

contract Q69 {
    /*
    숫자 1,2,3을 넣으면 1 and 2 or 3 라고 반환해주는 함수를 구현하세요.
    */

    function returnString(uint _a, uint _b, uint _c) public pure returns(string memory) {
        return string(abi.encodePacked(Strings.toString(_a)," and ",Strings.toString(_b)," or ",Strings.toString(_c)));
    }
}

contract Q70 {
    /*
    번호와 이름 그리고 bytes로 구성된 고객이라는 구조체를 만드세요. 
    bytes는 번호와 이름을 keccak 함수의 input 값으로 넣어 나온 output값입니다. 
    고객의 정보를 넣고 변화시키는 함수를 구현하세요. 
    */

    struct customer {
        uint number;
        string name;
        bytes32 auth;
    }

    customer c1;

    function setAuth(uint _number, string memory _name) public {
        c1 = customer(_number, _name, keccak256(abi.encodePacked(_number, _name)));   
    }

    function getC1() public view returns(customer memory) {
        return c1;
    }
}