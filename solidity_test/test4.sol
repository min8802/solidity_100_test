// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

contract A {
    /*
    간단한 게임이 있습니다. 유저는 번호, 이름, 주소, 잔고, 점수를 포함한 구조체입니다. 참가할 때 참가비용 0.01ETH를 내야합니다. (payable 함수)
    4명까지만 들어올 수 있는 방이 있습니다. (array) 선착순 4명에게는 각각 4,3,2,1점의 점수를 부여하고 4명이 되는 순간 방이 비워져야 합니다.

    예) 
    방 안 : "empty" 
    -- A 입장 --
    방 안 : A 
    -- B, D 입장 --
    방 안 : A , B , D 
    -- F 입장 --
    방 안 : A , B , D , F 
    A : 4점, B : 3점 , D : 2점 , F : 1점 부여 후 
    방 안 : "empty" 

    유저는 10점 단위로 점수를 0.1ETH만큼 변환시킬 수 있습니다.
    예) A : 12점 => A : 2점, 0.1ETH 수령 // B : 9점 => 1점 더 필요 // C : 25점 => 5점, 0.2ETH 수령

    
    
    
    * 점수를 돈으로 바꾸는 기능 - 10점마다 0.1eth로 환전
    * 관리자 인출 기능 - 관리자는 0번지갑으로 배포와 동시에 설정해주세요, 관리자는 원할 때 전액 혹은 일부 금액을 인출할 수 있음 (따로 구현)
    ---------------------------------------------------------------------------------------------------
    * 예치 기능 - 게임할 때마다 참가비를 내지 말고 유저가 일정금액을 미리 예치하고 게임할 때마다 자동으로 차감시키는 기능.
    */

    struct User {
        uint number;
        string name;
        address wallet;
        uint balance;
        uint score;
    }

    uint[4] room;
    User[] users;
    User user;
    mapping(address => uint) userNumber;
    mapping(address => uint) userScore;
    

    //* 유저 등록 기능 - 유저는 이름만 등록, 번호는 자동적으로 순차 증가, 주소도 자동으로 설정, 점수도 0으로 시작
    function setUser(string memory _name) public {
        user = User(users.length, _name, msg.sender, msg.sender.balance, 0);
        users.push(user);
        userNumber[msg.sender] = users.length;
        userScore[msg.sender] = 0;
    }

    //* 유저 조회 기능 - 유저의 전체정보 번호, 이름, 주소, 점수를 반환. 
    function getUser() public view returns(User[] memory) {
        return users;
    }

    //* 게임 참가시 참가비 제출 기능 - 참가시 0.01eth 지불 (돈은 smart contract가 보관)
    function deposit() public payable returns(string memory){
        if(msg.value == 0.01 ether) {
            for(uint i=0;i < room.length; i++) {
                if(room[room.length-2] != 0){
                    userScore[msg.sender] += 1;
                    delete room;
                    return "room reset";
                } else if(room[i] == 0 && i == 0) {
                    room[i] = userNumber[msg.sender];
                    userScore[msg.sender] += 4;
                    return "room 1 set";
                } else if(room[i] == 0 && i == 1) {
                    room[i] = userNumber[msg.sender];
                    userScore[msg.sender] += 3;
                    return "room 2 set";
                } else if(room[i] == 0 && i == 2) {
                    room[i] = userNumber[msg.sender];
                    userScore[msg.sender] += 2;
                    return "room 3 set";
                }
            }
            return "joined the room";
        } else {
            revert("need to pay 0.01 eth to join the room (10 Finney)");
        }
    }

    function getRoom() public view returns(uint[4] memory) {
        return room;
    }

    function getScore(address _addr) public view returns(uint) {
        return userScore[_addr];
    }
}