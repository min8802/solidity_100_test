// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.15;

contract a {
    /*
    흔히들 비밀번호 만들 때 대소문자 숫자가 각각 1개씩은 포함되어 있어야 한다 
    등의 조건이 붙는 경우가 있습니다. 그러한 조건을 구현하세요.

    입력값을 받으면 그 입력값 안에 대문자, 
    소문자 그리고 숫자가 최소한 1개씩은 포함되어 있는지 여부를 
    알려주는 함수를 구현하세요.
    */

    //아스키 코드로 바꾸고 for문 돌려
    //if문으로 아스키코드 번호 대문자 : 41~5A까지 있는지?
    //소문자 : 61~7A 있는지?
    //숫자 : 31~39 있는지?

    function splitBytes(bytes memory _b) public pure returns(bytes1) {
        return _b[0];
    }

    function generatePW(string memory _pw) public pure returns(bool,bool,bool){
        bool smallLetter;
        bool capitalLetter;
        bool number;
        bytes memory pw = bytes(_pw);
        
        for (uint i = 0; i < pw.length; i++) {
            if(pw[i] > 0x40 && pw[i] < 0x5B) {
                capitalLetter = true;
            }
            if(pw[i] > 0x60 && pw[i] < 0x7B) {
                smallLetter = true;
            }
            if (pw[i] > 0x30 && pw[i] < 0x40) {
                number = true;
            }
        }
        require(smallLetter, "put at least 1 small letter");
        require(capitalLetter, "put at least 1 capital letter");
        require(number, "put at least 1 number");
        return (capitalLetter, smallLetter, number);
    }
}