// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

contract Q21 {
    /*
    3의 배수만 들어갈 수 있는 array를 구현하세요.
    */
    
    function localArray3(uint _n) public pure returns(uint[1] memory) {
        uint[1] memory local;
        if(_n % 3 == 0) {
            local[0] = _n;
        }
        return local;
    }

    uint[] state;
    function stateArray3(uint _n) public returns(uint[] memory){
        if(_n % 3 == 0) {
            state.push(_n);
        }
        return state;
    }
}

contract Q22 {
    /*
    뺄셈 함수를 구현하세요. 
    임의의 두 숫자를 넣으면 자동으로 둘 중 큰수로부터 작은 수를 빼는 함수를 구현하세요.
    */
    
    function sub(uint _a, uint _b) public pure returns(uint) {
        if(_a > _b) {
            return _a - _b;
        } else if(_a < _b) {
            return _b - _a;
        } else {
            return 0;
        }
    }
}

contract Q23 {
    /*
    3의 배수라면 “A”를, 나머지가 1이 있다면 “B”를, 
    나머지가 2가 있다면 “C”를 반환하는 함수를 구현하세요.
    */
    
    function returnABC(uint _n) public pure returns(string memory) {
        if(_n % 3 == 0) {
            return "A";
        } else if(_n % 3 == 1) {
            return "B";
        } else {
            return "C";
        }
    }
}

contract Q24 {
    /*
    string을 input으로 받는 함수를 구현하세요. “Alice”가 들어왔을 때에만 true를 반환하세요.
    */
    
    function returnBool(string memory _a) public pure returns(bool) {
        if(keccak256(abi.encodePacked(_a)) == keccak256(abi.encodePacked("Alice"))) {
            return true;
        } else {
            return false;
        }
    }
}

contract Q25 {
    /*
    배열 A를 선언하고 해당 배열에 n부터 0까지 자동으로 넣는 함수를 구현하세요.
    */
    
    uint[] A;
    function autoPushNumber(uint _n) public returns(uint[] memory) {
        for(uint i = 0; i < _n+1; i++) {
            A.push(_n-i);
        }
        return A;
    }
}

contract Q26 {
    /*
    홀수만 들어가는 array, 짝수만 들어가는 array를 구현하고 숫자를 넣었을 때 
    자동으로 홀,짝을 나누어 입력시키는 함수를 구현하세요.
    */
    uint[] Odd;
    uint[] Even;

    function pushNumber(uint _n) public returns(uint[] memory) {
        if(_n % 2 == 0) {
            Even.push(_n);
            return Even;
        } else {
            Odd.push(_n);
            return Odd;
        }
    }
}

contract Q27 {
    /*
    string 과 bytes32를 key-value 쌍으로 묶어주는 mapping을 구현하세요. 
    해당 mapping에 정보를 넣고, 지우고 불러오는 함수도 같이 구현하세요.
    */
    mapping(string => bytes32) m1;
    address a;
    function setM1(string memory _a, bytes32 _b) public {
        m1[_a] = _b;
    }

    function deleteM1(string memory _a) public {
        delete m1[_a];
    }

    function getM1(string memory _a) public view returns(bytes32) {
        return m1[_a];
    }
}

contract Q28 {
    /*
    ID와 PW를 넣으면 해시함수(keccak256)에 둘을 같이 해시값을 반환해주는 함수를 구현하세요.
    */

    function hashIdPw(string memory _a, uint _b) public pure returns(bytes32, bytes32) {
        return (keccak256(abi.encodePacked(_a)), keccak256(abi.encodePacked(_b)));
    }
}

contract Q29 {
    /*
    숫자형 변수 a와 문자형 변수 b를 각각 10 그리고 “A”의 값으로 배포 직후 설정하는 contract를 구현하세요.
    */
    uint public a;
    string public b;
    constructor() {
        a = 10;
        b = "A";
    }
}

contract Q30 {
    /*
    임의대로 숫자를 넣으면 알아서 내림차순으로 정렬해주는 함수를 구현하세요
    // (sorting 코드 응용 → 약간 까다로움)
    //     예 : [2,6,7,4,5,1,9] → [9,7,6,5,4,2,1]
    // (sorting 코드 응용 → 약간 까다로움)
    */
    //9, 7, 6, 3, 1   4넣으려면
    //처음에 4를 끝에 붙이고 전체 a를 내림차순 정렬하기
    

    function descending(uint[] memory _arr, uint _n) public pure returns(uint[] memory){
        
        uint[] memory a = new uint[](_arr.length +1);
        for(uint i = 0; i < _arr.length; i++) {
            a[i] = _arr[i];
        }
        
        a[_arr.length] = _n;
        
        
        for (uint i = 0; i < a.length; i++) {
            for (uint j = i+1; j < a.length; j++) {
                if(a[i] < a[j]) {
                    (a[i], a[j]) = (a[j], a[i]);
                }
            }
        }
        return a;
    }
            
}
