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

contract Bank {
    struct User {
        address _addr;
        uint balance;
        uint paid; // 시간이어서 uint
    }

    receive() external payable {} //이 bank컨트랙트는 돈을 받는 경우도 있잖아 ? 그래서 돈받을 준비를 해야되 receive함수로

    constructor(address _addr) {
        IRS(_addr).pushList(address(this));
        (bool success,) = address(_addr).call(abi.encodeWithSignature("pushList(address)", address(this)));
        require(success);
    } // bank가 만들자마자 bank주소를 IRS에 pushList에 넣어서 바로 은행명당에 이름을 등록함

    mapping(address => User) public users; //public붙이니까 IRS 컨트랙트에서 .users 이렇게 바로 쓸 수 있네?! 오 !

    function getUser(address _addr) public view returns(User memory) {
        return users[_addr];
    }

    function signUp() public {
        users[msg.sender] = User(msg.sender, 0, 0);
    }

    function deposit() public payable {
        users[msg.sender].balance += msg.value;
    }

    function _deposit(address _addr, uint _n) public {
        users[_addr].balance += _n;
    }

    function withDraw(uint _n) public {
        require(users[msg.sender].balance >= _n);
        users[msg.sender].balance -= _n;
        payable(msg.sender).transfer(_n);
    }

    //모든 bank는 돈을 받을 준비를 해야하고 기본적으로 receive가 있어야 한다

    function transfer1(address payable _to, uint _n) public {
        //상대 은행도 이 함수들을 다 가지고 있어야되
        //받는 애의 balance도 변경을 시켜줘야되 컨트랙트간 함수들을 건드려야되네
        require(Bank(_to).getUser(msg.sender)._addr != address(0));
        //조건
        users[msg.sender].balance -= _n;
        payable(_to).transfer(_n);
        //잔액 변화 2가지
        Bank(_to)._deposit(msg.sender, _n);//에? 이렇게 컨트랙트 지갑에 .찍고 함수 바로 사용가능 하다고 ? 아니 안되 // 컨트랙트이름 Bank로 감싸주고 _to에 payable을 붙여주니까 에러 사라짐 ㄷㄷ
        // _to.users[msg.sender].balance += _n; 이거를 하는 함수를 deposit함수로 만들었음
    }

    //이렇게 하니까 Bank 컨트랙트 2개 간에는 서로 돈을 보내고 받는게 가능하네

    function transfer2(address payable _bank, address _user, uint _n) public {
        require(Bank(_bank).getUser(_user)._addr != address(0));
        users[msg.sender].balance -= _n;
        _bank.transfer(_n);
        Bank(_bank)._deposit(_user, _n);
    }
}

contract IRS {
    //국세청은 새로운 컨트랙트
    //만들자 마자 알려주는게 좋은거 같은데?

    address[] BankList; // bank컨트랙트 들의 주소가 들어간다

    function pushList(address _addr) public {
        BankList.push(_addr);
    }

    function getList() public view returns(address[] memory) {
        return BankList;
    }

    function predict() public view returns(uint) {
        //은행별 잔고 은행돌면서 물어바 그리고 1%가 예상 세금
        uint sum;

        for(uint i = 0; i < BankList.length;i++) {
            sum += Bank(payable(BankList[i])).getUser(msg.sender).balance;
        }
        return sum / 100;
    }

    function payTaxes() public payable{
        require(msg.value == predict(), "nope");

        for(uint i=0; i<BankList.length; i++) {
            Bank(payable(BankList[i])).users(msg.sender).paid;//여기서 users상태변수고 함수처럼 사용되고 있어서input인 msg.sender
        }
    }

    //얼만큼 갖고 있는지, 냇는지 안냈는지, 냈다 얼마있다 정보들을 IRS가 갖고 있을까 BANK가 갖고 있을까
    //ABC은행 3개에 걸쳐 세금이 걷힐수도 있어
    //자발적으로 세금을 내는거 1개 , 추가로 강제적으로 세금을 걷는거 1개

}