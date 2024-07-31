// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.15;

contract A {
    /*
    주차정산 프로그램을 만드세요. 주차시간 첫 2시간은 무료, 
    그 이후는 1분마다 200원(wei)씩 부과합니다. 
    주차료는 차량번호인식을 기반으로 실행됩니다.
    주차료는 주차장 이용을 종료할 때 부과됩니다.
    ----------------------------------------------------------------------
    차량번호가 숫자로만 이루어진 차량은 20% 할인해주세요.
    차량번호가 문자로만 이루어진 차량은 50% 할인해주세요.
    */

    //time + 2hours no pay
    //이후는 1분마다 200wei -> time관련 상태변수 하나

    uint public time;

    constructor() {
        time = block.timestamp;
    }

   
    function recordTime() public view returns(uint) {
        uint parkedTime;
        parkedTime = block.timestamp - time;
        return parkedTime;
    }

    function payPark() public payable returns(uint) {
        uint parkedTime = recordTime();
        uint parkedOverTime = (parkedTime - 7200) / 60;
        uint parkedFee = 0;

        if(parkedTime > 7200) {
            parkedFee = parkedOverTime * 200;       
        } else {
            parkedFee = 0;
        }

        
        if(parkedFee == 0) {
            return 0;
        }

        require(msg.value == parkedFee,"pay park");

        return parkedFee;
    }
    //여기서는 fee만 계산하고 돈내는 함수는 따로 작성했어야 해보자
}