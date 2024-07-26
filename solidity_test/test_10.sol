// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

contract a {
    /*
    은행에 관련된 어플리케이션을 만드세요.
    은행은 여러가지가 있고, 유저는 원하는 은행에 넣을 수 있다. 
    국세청은 은행들을 관리하고 있고, 세금을 징수할 수 있다. 
    세금은 간단하게 전체 보유자산의 1%를 징수한다. 세금을 자발적으로 납부하지 않으면 강제징수한다. 

    * 회원 가입 기능 - 사용자가 은행에서 회원가입하는 기능
    * 입금 기능 - 사용자가 자신이 원하는 은행에 가서 입금하는 기능
    * 출금 기능 - 사용자가 자신이 원하는 은행에 가서 출금하는 기능
    * 은행간 송금 기능 1 - 사용자의 A 은행에서 B 은행으로 자금 이동 (자금의 주인만 가능하게)
    * 은행간 송금 기능 2 - 사용자 1의 A 은행에서 사용자 2의 B 은행으로 자금 이동
    * 세금 징수 - 국세청은 주기적으로 사용자들의 자금을 파악하고 전체 보유량의 1%를 징수함. 세금 납부는 유저가 자율적으로 실행. (납부 후에는 납부 해야할 잔여 금액 0으로)
-------------------------------------------------------------------------------------------------
    * 은행간 송금 기능 수수료 - 사용자 1의 A 은행에서 사용자 2의 B 은행으로 자금 이동할 때 A 은행은 그 대가로 사용자 1로부터 1 finney 만큼 수수료 징수.
    * 세금 강제 징수 - 국세청에게 사용자가 자발적으로 세금을 납부하지 않으면 강제 징수. 은행에 있는 사용자의 자금이 국세청으로 강제 이동
    */

    //국세청은 2번 contract 1번 contract의 유저에게 balance * 1%씩 자발납부 or 강제 징수

    //은행 1번 contract

    //user 정보 : 지갑주소, 사용 은행, 은행별 전체 보유자산(맵핑)
    //입금 : 은행이름, 넣을 금액 -> 은행 정보 : 유저EOA지갑주소, 유저별 잔고
    //세금 징수는 time stamp에서 30일 기준으로 자르고 30일 안에 납부 ok -> 납부 금액 삭제, 납부 안되면 외부컨트랙트가 1번 컨트랙트 건드려서 강제 징수
    
    mapping(address => mapping(string => uint)) userBalance;
    mapping(string => mapping(bytes32 => uint)) userCheck;
    //회원 가입 x : userCheck 1 = 0, 은행 회원가입 o : userCheck = 1
    function PW (string memory _id, string memory _phoneNum) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(_id, _phoneNum));
    }

    function getUserCheck(string memory _bankName, string memory _id, string memory _phoneNum) public view returns(uint) {
        return userCheck[_bankName][PW(_id, _phoneNum)];
    }

    //회원 가입 기능 - 사용자가 은행에서 회원가입하는 기능
    function setUser(string memory _bankName, string memory _id, string memory _phoneNum) public {
        userBalance[msg.sender][_bankName] = 1; // balance 1 wei 추가로 user가 존재 하는지 하지 않는지 판단
        userCheck[_bankName][PW(_id,_phoneNum)] = 1;
    }
    //입금 기능 - 사용자가 자신이 원하는 은행에 가서 입금하는 기능
    function deposiBank(string memory _bankName, string memory _id, string memory _phoneNum) public payable {
        require(userCheck[_bankName][PW(_id, _phoneNum)] == 1, "need signUp for this bank first");
        userBalance[msg.sender][_bankName] = msg.value;
    }
    //출금 기능 - 사용자가 자신이 원하는 은행에 가서 출금하는 기능
    function withdrawBank(string memory _bankName, uint _n, string memory _id, string memory _phoneNum) public payable {
        require(userBalance[msg.sender][_bankName] > _n, "not enough balance");
        require(userCheck[_bankName][PW(_id, _phoneNum)] == 1, "need signUp for this bank first");
        payable(msg.sender).transfer(_n);
    }
    //은행간 송금 기능 1 - 사용자의 A 은행에서 B 은행으로 자금 이동 (자금의 주인만 가능하게)
    function sendMoneyBtoB(string memory _bankNameA, string memory _bankNameB, uint _n, string memory _id, string memory _phoneNum) public {
        require(userBalance[msg.sender][_bankNameA] > _n, "you don't have enough moeny in bank A");
        require(userCheck[_bankNameA][PW(_id, _phoneNum)] == 1, "need signUp for this bank first");
        userBalance[msg.sender][_bankNameB] += _n; 
        userBalance[msg.sender][_bankNameA] -= _n; 
    }
    //은행간 송금 기능 2 - 사용자 1의 A 은행에서 사용자 2의 B 은행으로 자금 이동
    function sendMoneyUtoU(string memory _bankNameA, string memory _bankNameB, uint _n, string memory _id, string memory _phoneNum, address _receiver) public {
        require(userBalance[msg.sender][_bankNameA] > _n, "you don't have enough moeny in bank A");
        require(userCheck[_bankNameA][PW(_id, _phoneNum)] == 1, "need signUp for this bank first");
        require(userBalance[_receiver][_bankNameB] != 0, "this user don't exist in bank B");
        userBalance[_receiver][_bankNameB] += _n;
        userBalance[msg.sender][_bankNameA] -= _n;
    }
    //세금 징수 - 국세청은 주기적으로 사용자들의 자금을 파악하고 전체 보유량의 1%를 징수함. 
    //세금 납부는 유저가 자율적으로 실행. (납부 후에는 납부 해야할 잔여 금액 0으로)
    
}