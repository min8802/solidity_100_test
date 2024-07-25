// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

contract Q51 {
    /*
    숫자들이 들어가는 배열을 선언하고 그 중에서 3번째로 큰 수를 반환하세요.
    */

    //
    uint[] array;

    function setArray(uint _n) public {
        require(_n > 3, "put more than 3");
        for (uint i=0; i<_n; i++) {
            array.push(i);
        }
    } 
}