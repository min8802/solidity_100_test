// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

contract Q51 {
    /*
    숫자들이 들어가는 배열을 선언하고 그 중에서 3번째로 큰 수를 반환하세요.
    */

    //
    uint[] array;

    function setArray(uint _n) public returns(uint[] memory) {
        array.push(_n);
        return array;
    }

    function thirdBigNum() public returns(uint){
        for(uint i=0; i < array.length; i++) {
            for(uint j=i+1; j< array.length; j++) {
                if(array[i] < array[j]) {
                    (array[i], array[j]) = (array[j], array[i]);
                }
            }
        }
        return array[2];
    }
}

contract Q52 {
    /*
    자동으로 아이디를 만들어주는 함수를 구현하세요. 
    이름, 생일, 지갑주소를 기반으로 만든 해시값의 첫 10바이트를 추출하여 아이디로 만드시오.
    */
    //Q. 질문 : 추출한 첫 10바이트를 스트링화 하는것이 좀 어렵습니다

    function setId(string memory _name, string memory _birth) public view returns(bytes10) {
        bytes32 hashId;
        hashId = keccak256(abi.encodePacked(_name,_birth,msg.sender));
        bytes10 Id = bytes10(hashId);
        return Id;
    }
}


contract Q53 {
    /*
    1. 시중에는 A,B,C,D,E 5개의 은행이 있습니다. 
    각 은행에 고객들은 마음대로 입금하고 인출할 수 있습니다. 
    각 은행에 예치된 금액 확인, 입금과 인출할 수 있는 기능을 구현하세요.
    힌트 : 이중 mapping을 꼭 이용하세요.
    */

    mapping(address => mapping(string => uint)) bankBalance;

    function deposit(string memory _bankName) public payable {
        bankBalance[msg.sender][_bankName] = msg.value;
    }

    function getBalance(string memory _bankName) public view returns(uint) {
        return bankBalance[msg.sender][_bankName];
    }

    function withDraw(string memory _bankName, uint _n) public payable {
        require(bankBalance[msg.sender][_bankName] > _n, "not enough balance");
        payable(msg.sender).transfer(_n);
    }
}

contract Q54 {
    /*
    1. 기부받는 플랫폼을 만드세요. 
    가장 많이 기부하는 사람을 나타내는 변수와 그 변수를 지속적으로 바꿔주는 함수를 만드세요.
    힌트 : 굳이 mapping을 만들 필요는 없습니다.
    */
    address donatePerson;
    uint donateAmount;

    function donate() public payable {
        require(msg.value > 0, "put more than 0");
        if(donateAmount < msg.value) {
            donatePerson = msg.sender;
            donateAmount = msg.value;
        }
    }
    function getBiggestDonate() public view returns(address, uint) {
        return (donatePerson, donateAmount);
    }
}

contract Q55 {
    /*
    배포와 함께 owner를 설정하고 owner를 다른 주소로 바꾸는 것은 오직 owner 스스로만 할 수 있게 하십시오.
    */

    address owner;

    constructor () {
        owner = msg.sender;
    }

    function changeOwner(address _addr) public returns(address){
        require(owner == msg.sender, "you are not an owder");
        owner = _addr;
        return owner;
    }
}

contract Q56 {
    /*
    위 문제의 확장버전입니다. owner와 sub_owner를 설정하고 owner를 바꾸기 위해서는 둘의 동의가 모두 필요하게 구현하세요.
    */
    address owner;
    address sub_owner;

    constructor (address _sub_owner) {
        owner = msg.sender;
        sub_owner = _sub_owner;
    }
    
    bool subApproval;
    
    function subApprove() public {
        require(sub_owner == msg.sender, "you are not an sub_owner");
        subApproval = true;
    }

    function changeOwner(address _addr) public returns(address) {
        require(owner == msg.sender && subApproval, "you are not an owner or subApproval is not approved");
        owner = _addr;
        subApproval = false;
        return owner;
    }
}

contract Q57 {
    /*
    위 문제의 또다른 버전입니다. 
    owner가 변경할 때는 바로 변경가능하게 sub-owner가 변경하려고 
    한다면 owner의 동의가 필요하게 구현하세요.
    */

    address owner;
    address sub_owner;

    constructor (address _sub_owner) {
        owner = msg.sender;
        sub_owner = _sub_owner;
    }
    
    bool ownerApproval;

    function ownerApprove() public {
        require(owner == msg.sender, "you are not an owner");
        ownerApproval = true;
    }
    
    function changeOwner(address _addr) public returns(address) {
        if(owner == msg.sender) {
            owner = _addr;
            ownerApproval = false;
        } else if(sub_owner == msg.sender && ownerApproval) {
            owner = _addr;
            ownerApproval = false;
        } else {
            revert("nope");
        }
        return owner; 
    }
}

contract ABC{
    /*
    A contract에 a,b,c라는 상태변수가 있습니다. a는 A 외부에서는 변화할 수 없게 하고 싶습니다. 
    b는 상속받은 contract들만 변경시킬 수 있습니다. c는 제한이 없습니다. 각 변수들의 visibility를 설정하세요.
    */

    uint public a;
    uint public b;
    uint public c;

    function setA(uint _n) private {
        a = _n;
    }

    function setB(uint _n) internal {
        b = _n;
    }

    function setC(uint _n) public {
        c = _n;
    }

}

contract Internal is ABC {
    ABC INTERNAL = new ABC();
    
    function setAddress(address _ABC) public {
        INTERNAL = ABC(_ABC);
    }

    function setb(uint _n) public {
        setB(_n);
    }
}
// Q. 질문 : 상속 받은 컨트랙트 Internal이 상속 해주는 컨트랙트 ABC의 상태변수는 어떻게 바꿀 수 있는지 궁금합니다

contract External {
    ABC EXTERNAL = new ABC();
    
    function setAddress(address _ABC) public {
        EXTERNAL = ABC(_ABC);
    }

    // function setA_E(uint _n) public {
    //     a.setA(_n);
    // }

    // function setB_E(uint _n) public {
    //     return a.setB(_n);
    // }

    function setC_E(uint _n) public {
        EXTERNAL.setC(_n);
    }
}

contract Q59 {
    /*
    현재시간을 받고 2일 후의 시간을 설정하는 함수를 같이 구현하세요.
    */

    uint currentTime;
    uint twodaysTime;

    function getTime() public {
        currentTime = block.timestamp;
        twodaysTime = currentTime + 2 days;
    }

    function getCurrentTIme() public view returns(uint) {
        return currentTime;
    }

    function getTwodaysTime() public view returns(uint) {
        return twodaysTime;
    }
}

contract Q60 {
    /*
    1. 방이 2개 밖에 없는 펜션을 여러분이 운영합니다. 
    각 방마다 한번에 3명 이상 투숙객이 있을 수는 없습니다. 
    특정 날짜에 특정 방에 누가 투숙했는지 알려주는 자료구조와 그 자료구조로부터 값을 얻어오는 함수를 구현하세요.
    
    예약시스템은 운영하지 않아도 됩니다. 과거의 일만 기록한다고 생각하세요.
    
    힌트 : 날짜는 그냥 숫자로 기입하세요. 예) 2023년 5월 27일 → 230527
    */

    //방 2개 펜션 
    //1방에 3명이상 못받음
    //특정 날짜 => 특정 방 => 투숙객
    //과거의 일만 기록
    //날짜는 숫자로 기입 
    //a방 어레이, b방 어레이 true면 a방, false면 b방 각방의 길이 3


    //날짜는 230527 식으로 입력, 방 이름은 true방 혹은 false방
    mapping(string => mapping(bool => address[])) customer;

    function booking(string memory _date, bool _bool) public {
        require(customer[_date][_bool].length < 3, "no more than 3 customer in a room");
        //이미 예약한 유저는 투숙객 목록에 추가 등록 차단
        for(uint i=0; i < customer[_date][_bool].length; i++) {
            if(customer[_date][_bool][i] == msg.sender) {
                revert("you already booked");
            }
        }
        customer[_date][_bool].push(msg.sender);    
    }

    function getBooking(string memory _date, bool _bool) public view returns(address[] memory) {
        return customer[_date][_bool];
    }
}