// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

contract A {
//     가능한 모든 것을 inline assembly로 진행하시면 됩니다.
// 1. 숫자들이 들어가는 동적 array number를 만들고 1~n까지 들어가는 함수를 만드세요.
// 2. 숫자들이 들어가는 길이 4의 array number2를 만들고 여기에 4개의 숫자를 넣어주는 함수를 만드세요.
// 3. number의 모든 요소들의 합을 반환하는 함수를 구현하세요. 
// 4. number2의 모든 요소들의 합을 반환하는 함수를 구현하세요. 
// 5. number의 k번째 요소를 반환하는 함수를 구현하세요.
// 6. number2의 k번째 요소를 반환하는 함수를 구현하세요.

    

    function setNum(uint _n) public pure returns(uint[] memory) {
        uint[] memory Array = new uint[](_n);

        assembly {
            let start := add(Array, 0x20)
            for{let i:=0} lt(i,_n) {i:=add(i,1)} {
                mstore(add(start,mul(i,0x20)),add(i,1))
            }
        }
        return Array;
    }
    
    function setNum2(uint _n) public pure returns(uint[4] memory) {
        uint[4] memory Array2;

        assembly {
            for{let i:=0} lt(i,_n) {i:=add(i,1)} {
                mstore(add(Array2,mul(i,0x20)),add(i,1))
            }
        }
        return Array2;
    }
    
    function setNumSum(uint _n) public pure returns(uint) {
        uint[] memory Array = new uint[](_n);
        uint tot;
        assembly {
            let start := add(Array, 0x20)
            for{let i:=0} lt(i,_n) {i:=add(i,1)} {
                mstore(add(start,mul(i,0x20)),add(i,1))
                tot := add(tot,add(i,1))
            }

        }
        return tot;
    }

    function setNum2Sum(uint _n) public pure returns(uint[4] memory) {
        uint[4] memory Array2;
        uint tot;
        uint limit = _n > 3 ? 4 : _n;
        assembly {
            for{let i:=0} lt(i,limit) {i:=add(i,1)} {
                mstore(add(Array2,mul(i,0x20)),add(i,1))
                tot := add(tot,add(i,1))
            }
        }
        return Array2;
    }
}