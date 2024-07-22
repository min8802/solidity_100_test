// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.15;

import "@openzeppelin/contracts/utils/Strings.sol";

contract a {
    uint[] resultArray;
    function convert(uint _n) public returns(uint) {
        string memory getString;
        uint numCount;
        getString = string(Strings.toString(_n));
        numCount = getNum(getString);

        for (uint i=0; i <= numCount; i++) {
            resultArray.push(_n / 10**(numCount-i)); 
        }
        return numCount;
    }

    function getNum(string memory _a) public pure returns(uint) {
        bytes memory stringNum = bytes(_a);
        return stringNum.length; 
    }

}