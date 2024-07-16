// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

contract A {
    /*
    숫자를 시분초로 변환하세요.
    예) 100 -> 1 min 40 sec
    600 -> 10 min 
    1000 -> 1 6min 40 sec
    5250 -> 1 hour 27 min 30 sec
    */

    function convertTime(uint _n) public pure returns(string memory) {
        uint hour = _n / 3600;
        uint minute = (_n % 3600) / 60;
        uint second = _n % 60;
        
        return "0";
    }
}