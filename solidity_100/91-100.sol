// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

contract Q91 {
    /*
    배열에서 특정 요소를 없애는 함수를 구현하세요. 
    예) [4,3,2,1,8] 3번째를 없애고 싶음 → [4,3,1,8]
    */
    function getArray(uint[] memory _array, uint n) public pure returns(uint[] memory) {
        uint[] memory _updateArray = new uint[](_array.length-1);

        for(uint i = 0; i < n-1; i++) {
            _updateArray[i] = _array[i];
        }
        
        for(uint i = n; i < _array.length; i++) {
            _updateArray[i-1] = _array[i];
        }
        return _updateArray;
    }
}

contract Q92 {
    /*
    특정 주소를 받았을 때, 
    그 주소가 EOA인지 CA인지 감지하는 함수를 구현하세요.
    */

    //await web3.eth.getCode('contract 주소')
}

contract Q93 {
    /*
    다른 컨트랙트의 함수를 사용해보려고 하는데, 
    그 함수의 이름은 모르고 methodId로 추정되는 값은 있다. 
    input 값도 uint256 1개, address 1개로 추정될 때 해당 함수를 활용하는 함수를 구현하세요.
    */

        address a;
        bytes4 methodId;

        function usdCall(uint _a, address _addr) public returns(bool){
            (bool success, ) = address(a).call(abi.encodeWithSelector(methodId, _a, _addr));
            return success;
        }
}

contract Q94 {
    /*
    inline - 더하기, 빼기, 곱하기, 나누기하는 함수를 구현하세요.
    */

    function inlineSum(uint _a, uint _b) public pure returns(uint) {
        uint sumNum;
        assembly {
            sumNum := add(_a, _b)
        }
        return sumNum;
    }
    
    function inlineSub(uint _a, uint _b) public pure returns(uint) {
        uint subNum;
        uint a;
        uint b;
        assembly {
            if gt(_a,_b) {
                a := _a
                b := _b
            }

            if lt(_a,_b) {
                a := _b
                b := _a
            }
            subNum := sub(a, b)
        }
        return subNum;
    }

    function inlineMul(uint _a, uint _b) public pure returns(uint) {
        uint sumNum;
        assembly {
            sumNum := mul(_a, _b)
        }
        return sumNum;
    }
    
    function inlineDiv(uint _a, uint _b) public pure returns(uint) {
        uint sumNum;
        assembly {
            sumNum := div(_a, _b)
        }
        return sumNum;
    }
}

contract Q95 {
    /*
    inline - 3개의 값을 받아서, 더하기,
    곱하기한 결과를 반환하는 함수를 구현하세요.
    */

    function sumMul(uint a, uint b, uint c) public pure returns(uint, uint) {
        uint sumResult;
        uint mulResult;

        assembly {
            sumResult := add(add(a,b),c)
            mulResult := mul(mul(a,b),c)
        }

        return (sumResult,mulResult);
    }
}

//assembly 복습이 잘 안되어 있는 것 같아서 96번부터는 도전해 보았는데
//assembly 복습을 제대로 한 이후에 풀 수 있을 것 같습니다




