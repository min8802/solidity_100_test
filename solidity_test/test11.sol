// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";

contract a {
    /*
    로또 프로그램을 만드려고 합니다. 
    숫자와 문자는 각각 4개 2개를 뽑습니다. 6개가 맞으면 1이더, 5개의 맞으면 0.75이더, 
    4개가 맞으면 0.25이더, 3개가 맞으면 0.1이더 2개 이하는 상금이 없습니다. 

    참가 금액은 0.05이더이다.

    예시 1 : 8,2,4,7,D,A
    예시 2 : 9,1,4,2,F,B
    */

    bytes winNumber;

    function setlottery() public {
        winNumber = abi.encodePacked(bytes("5"),bytes("2"),bytes("1"),bytes("4"),"A","B");
    }

    function getlottery() public view returns(bytes memory) {
        return winNumber;
    }

    function lottery(uint _a, uint _b, uint _c, uint _d, string memory _e, string memory _f) public view returns(uint){
        require(bytes(_e).length == 1, "put 1 letter");
        require(bytes(_f).length == 1, "put 1 letter");
        //bytes화 해서 winNumber 0~3에 있는지 검색
        //있으면 맞춘 갯수 업데이트
        
        uint winCount;

        bytes1 A = bytes1(uint8(0x48+_a));
        bytes1 B = bytes1(uint8(0x48+_b));
        bytes1 C = bytes1(uint8(0x48+_c));
        bytes1 D = bytes1(uint8(0x48+_d));

        for(uint i=0; i < 4; i++) {
            if(winNumber[i] == A) {
                winCount++;
            } else if(winNumber[i] == B) {
                winCount++;
            } else if(winNumber[i] == C) {
                winCount++;
            } else if(winNumber[i] == D) {
                winCount++;
            } 
        }

        bytes1 E = bytes(_e)[0];
        bytes1 F = bytes(_f)[0];

        for(uint i=4; i<6; i++) {
            if(winNumber[i] == E) {
                winCount++;
            } else if (winNumber[i] == F) {
                winCount++;
            }
        }
        return winCount;  
    }

}