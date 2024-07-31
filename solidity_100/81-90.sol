// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

contract Q81 {
    /*
    Contract에 예치, 인출할 수 있는 기능을 구현하세요. 
    지갑 주소를 입력했을 때 현재 예치액을 반환받는 기능도 구현하세요. 
    */

    mapping(address => uint) userBalance;

    function deposit() public payable returns(uint){
        userBalance[msg.sender] += msg.value;
        return msg.value;
    }

    function withDraw(uint _n) public {
        userBalance[msg.sender] -= _n;
        payable(msg.sender).transfer(_n);
    }

    function checkBal() public view returns(uint) {
        return userBalance[msg.sender];
    }
}

contract Q82 {
    /*
    특정 숫자를 입력했을 때 그 숫자까지의 
    3,5,8의 배수의 개수를 알려주는 함수를 구현하세요.
    */

    function getMultipleNum(uint _n) public pure returns(uint, uint, uint) {
        return (_n % 3 == 0 ? _n / 3: 0, _n % 5 == 0 ? _n / 5 : 0, _n % 8 == 0? _n / 8 : 0);
    }
}

contract Q83 {
    /*
    이름, 번호, 지갑주소 그리고 숫자와 문자를 연결하는 
    mapping을 가진 구조체 사람을 구현하세요. 
    사람이 들어가는 array를 구현하고 array안에 
    push 하는 함수를 구현하세요.
    */

    struct person {
        string name;
        uint number;
        address wallet;
        mapping(uint => string) myName;
    }

    person[] people;

    function setPerson(string memory _name) public {
        person storage p1 = people.push();
        p1.name = _name;
        p1.number = people.length+1;
        p1.wallet = msg.sender;
        p1.myName[people.length] = _name;
        //스트럭트안의 맵핑이 있는데 초기값 어떻게 설정할지
    }

    function getPerson() public view returns(string memory, uint, address) {
        return (people[0].name,people[0].number,people[0].wallet);
    }
    //0번 요소 확인    

    function getPersonMyname() public view returns(string memory) {
        return people[0].myName[people.length];
    }
    //0번 요소 확인
}

contract Q84 {
    /*
    2개의 숫자를 더하고, 빼고, 곱하는 함수들을 구현하세요. 
    단, 이 모든 함수들은 blacklist에 든 지갑은 실행할 수 없게 제한을 걸어주세요.
    */

    address blacklist;

    constructor (address _blacklist) {
        blacklist = _blacklist;
    }

    function sum(uint _a, uint _b) public view returns(uint){
        require(msg.sender != blacklist, "nope");
        return (_a + _b);
    }    
    
    function sub(uint _a, uint _b) public view returns(uint){
        require(msg.sender != blacklist, "nope");
        return (_a > _b ? _a - _b : _b - _a);
    }    
    
    function mul(uint _a, uint _b) public view returns(uint){
        require(msg.sender != blacklist, "nope");
        return (_a * _b);
    }    
}

contract Q85 {
    /*
    숫자 변수 2개를 구현하세요. 한개는 찬성표 나머지 하나는 반대표의 숫자를 나타내는 변수입니다.
    찬성, 반대 투표는 배포된 후 20개 블록동안만 진행할 수 있게 해주세요.
    */
    //배포 될 때 블록
    uint public upvote;
    uint public downvote;
    uint blockNumber;
    constructor () {
        blockNumber = block.number;
    }

    function upvoting() public {
        require(block.number < blockNumber + 21, "done");
        upvote++;
    }
    
    function downvoting() public {
        require(block.number < blockNumber + 21, "done");
        downvote++;
    }
}

contract Q86 {
    /*
    숫자 변수 2개를 구현하세요. 한개는 찬성표 나머지 하나는 반대표의 숫자를 나타내는 변수입니다. 
    찬성,반대 투표는 1이더 이상 deposit한 사람만 할 수 있게 제한을 걸어주세요.
    */

    uint public upvote;
    uint public downvote;

    function upvoting() public payable{
        require(msg.value >= 1 ether, "pay more than 1 etehr");
        upvote++;
    }
    
    function downvoting() public payable{
        require(msg.value >= 1 ether, "pay more than 1 etehr");
        downvote++;
    } 
}

contract Q87 {
    /*
    1. visibility에 신경써서 구현하세요. 
    숫자 변수 a를 선언하세요. 해당 변수는 컨트랙트 외부에서는 볼 수 없게 구현하세요. 
    변화시키는 것도 오직 내부에서만 할 수 있게 해주세요.
    */

    uint private a;

    function setA(uint _a) private {
        a = _a;
    }

}

contract OWNER {
	address private owner;

	constructor() {
		owner = msg.sender;
	}

    function setInternal(address _a) internal {
        owner = _a;
    }

    function getOwner() public view returns(address) {
        return owner;
    }
}

contract Q88 is OWNER{
    function setAddr(address _addr) public {
        return setInternal(_addr);
    }
}

contract Q89 {
    /*
    이름과 자기 소개를 담은 고객이라는 구조체를 만드세요. 
    이름은 5자에서 10자이내 자기 소개는 20자에서 50자 이내로 설정하세요. 
    (띄어쓰기 포함 여부는 신경쓰지 않아도 됩니다. 더 쉬운 쪽으로 구현하세요.)
    */

    struct Customer {
        string name;
        string selfIntro;
    }

    Customer c1;

    function setC1 (string memory _name, string memory _selfIntro) public {
        require(bytes(_name).length > 4 && bytes(_name).length <11, "put letter betwwen 5 to 10");
        require(bytes(_selfIntro).length > 19 && bytes(_selfIntro).length <51, "put letter betwwen 20 to 50");
        c1 = Customer(_name, _selfIntro);
    }

    function getC1() public view returns(Customer memory) {
        return c1;
    }
}

contract Q90 {
    /*
    당신 지갑의 이름을 알려주세요. 아스키 코드를 이용하여 byte를 string으로 바꿔주세요.
    */
    
    
    function getWalletName() public view returns(bytes memory){
        bytes memory walletBytes = abi.encodePacked(msg.sender);
        return bytes(walletBytes);
        //메모리에 저장해야 가변적으로 바꿀 수 있음
    }

    function bytesWallet() public view returns(string memory){
        bytes memory walletBytes = getWalletName();
        // return walletBytes; // walletBytes 바이트코드가 잘 출력되는데 아래에서 string으로 왜 변환안되는지 잘 모르겠습니다
        return string(walletBytes);
    }
}

