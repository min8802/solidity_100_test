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

contract Answer {
    //돈을 넣고 빼고 하는 과정을 담당하는 아이가 필요하고 그래서 Owner가 필요함
    //Owner는 안변해야 해서 배포할 때만 써야되 constructor 써야함
    struct USER {
        uint number;
        string name;
        address wallet;
        uint balance;
        uint score;
    }

    address payable owner;
    //컨트랙트를 배포하는 지갑 주소가 Owner가 되야되
    //USER[] users;
    //검색도 해야하니까 어레이는 내리고 매핑으로 가겠다
    address[4] room;
    mapping(address =>USER) users;
    uint public userCount=1; // 사용자 수를 저장하는 변수 나중에는 Event Emit으로 Event발생하면 프론트에서 바로 숫자를 올려줘서 상태변수 안써볼 수 도 있겠다
    //address를 선택한 이유는 고유하고 유일해서 번호는 탈퇴하고 다시오면 변경 될수도 있으니 가장 고유한 것이 주소이다

    constructor() {
        owner = payable(msg.sender);//payable을 꼭 붙여줘야 한다
    }
    
    modifier onlyOwner {
        require(msg.sender == owner, "nope");
        _;
    }

    modifier morethanTwoEther {
        _;//돈 빼간 후에 남는게 2이더 이상이어야해 아니면 돌아가
        //이기때문에 위에 _; 써줘야함 
        require(address(this).balance >= 2 ether, "nope");
    }

    //* 관리자 인출 기능 - 관리자는 0번지갑으로 배포와 동시에 설정해주세요, 
    //관리자는 원할 때 전액 혹은 일부 금액을 인출할 수 있음 (따로 구현)
    function withDrawOwner(uint _n) public onlyOwner {
        // require(msg.sender == owner, "nope");
        owner.transfer(_n * 0.01 ether);
    }

    function withDrawAll() public onlyOwner{
        // require(msg.sender == owner, "nope");
        owner.transfer(address(this).balance);
    }

    //* 유저 등록 기능 - 유저는 이름만 등록, 번호는 자동적으로 순차 증가, 주소도 자동으로 설정, 점수도 0으로 시작
    function signIn(string memory _name) public {
        require(bytes(users[msg.sender].name).length==0, "nope"); // 바이트 길이가 0인건 값이 없다는 얘기, 그럼 미등록한 사람이니까 등록가능
        users[msg.sender] = USER(userCount, _name, msg.sender, 0, 0);
        userCount++; 
    }

    // 유저 조회 기능 - 유저의 전체정보 번호, 이름, 주소, 점수를 반환.
    function search(address _addr) public view returns(USER memory)  {
        return users[_addr];
    }

    //* 게임 참가시 참가비 제출 기능 - 참가시 0.01eth 지불 (돈은 smart contract가 보관)
    function join() public payable {
        require(bytes(users[msg.sender].name).length !=0 &&  msg.value == 0.01 ether, "NOPE");
        // if(getLength()==4) {
        //     delete room;
        //     room[0] = users[msg.sender];
        // }
        // //길이가 2일때 나는 2번자리에 들어가야 되니까 0,1,2 그래서 아래처럼
        // room[getLength()] = users[msg.sender];

        if(getLength()==3) {
            users[room[3]] = users[msg.sender];
            getScore();
            delete room;
        } else {
            room[getLength()] = msg.sender;
        }
    }

    function getLength() public view returns(uint) {
        for(uint i=0; i < 4; i++) {
            if(users[room[i]].number == 0) {
                return i;
            }
        }
        return 4;
    }

    function getScore() public {
        for(uint i=0; i<4; i++) {
            users[room[i]].score += 4-i;
        }
    }
    //* 점수를 돈으로 바꾸는 기능 - 10점마다 0.1eth로 환전
    //이런거 할 때 돈주는걸 가장 마지막에 해야되
    function withDrawTen() public {
        require(users[msg.sender].score >= 10, "nope");
        users[msg.sender].score -= 10;
        payable(msg.sender).transfer(0.1 ether); // 이게 함수 실행하는 사람한테 0.1 ether를 전송해 의미
    }

    function withDraw(uint _n) public {
        require(users[msg.sender].score >= _n, "nope");
        users[msg.sender].score -= _n;
        payable(msg.sender).transfer((_n/10) * 0.1 ether);
    }

    function withDrawMax() public {
        require(users[msg.sender].score>=10,"nope");
        uint amount = users[msg.sender].score / 10;
        users[msg.sender].score = users[msg.sender].score % 10;
        payable(msg.sender).transfer(amount * 0.1 ether);
    }
    //최대로 인출할 수 있는 ether 계산

    //* 예치 기능 - 게임할 때마다 참가비를 내지 말고 유저가 일정금액을 미리 예치하고 
    //게임할 때마다 자동으로 차감시키는 기능.
    function deposit() public payable {
        users[msg.sender].balance += msg.value;
    } //유저 잔고에 유저가 원하는 만큼 먼저 예치

    function joinDeposit() public payable {
        require(bytes(users[msg.sender].name).length !=0 && msg.value == 0.01 ether || users[msg.sender].balance >= 0.01 ether, "NOPE");
        // balance가 0.01 보다 커도 입장가능
        // 그때는 value에 값 안넣었을거 아니야 ? 그럴땐 아래처럼 balance에서 직접 까주기
        if(msg.value==0) {
            users[msg.sender].balance -= 0.01 ether;
        }

        if(getLength()==3) {
            users[room[3]] = users[msg.sender];
            getScore();
            delete room;
        } else {
            users[room[getLength()]] = users[msg.sender];
        }
    }
}



contract teacherAnswer {
     /*
	간단한 게임이 있습니다.
	유저는 번호, 이름, 주소, 잔고, 점수를 포함한 구조체입니다. 
	참가할 때 참가비용 0.01ETH를 내야합니다. (payable 함수)
	4명까지만 들어올 수 있는 방이 있습니다. (array)
	선착순 4명에게는 각각 4,3,2,1점의 점수를 부여하고 4명이 되는 순간 방이 비워져야 합니다.
	
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
	
	* 유저 등록 기능 - 유저는 이름만 등록, 번호는 자동적으로 순차 증가, 주소도 자동으로 설정, 점수도 0으로 시작
	* 유저 조회 기능 - 유저의 전체정보 번호, 이름, 주소, 점수를 반환. 
	* 게임 참가시 참가비 제출 기능 - 참가시 0.01eth 지불 (돈은 smart contract가 보관)
	* 점수를 돈으로 바꾸는 기능 - 10점마다 0.1eth로 환전
	* 관리자 인출 기능 - 관리자는 0번지갑으로 배포와 동시에 설정해주세요, 관리자는 원할 때 전액 혹은 일부 금액을 인출할 수 있음 (따로 구현)
	---------------------------------------------------------------------------------------------------
	* 예치 기능 - 게임할 때마다 참가비를 내지 말고 유저가 일정금액을 미리 예치하고 게임할 때마다 자동으로 차감시키는 기능.
	*/
    struct USER {
        uint number;
        string name;
        address addr;
        uint score;
        uint balance;
    }

    address payable owner;
    
    mapping(address=>USER) users;
    address[4] room;
    uint public idx=1;

    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "nope");
        _;
    }

    modifier morethanTwoEther {
        _;
        require(address(this).balance >= 2 ether, "nope");
    }

    // 	* 관리자 인출 기능 - 관리자는 0번지갑으로 배포와 동시에 설정해주세요, 관리자는 원할 때 전액 혹은 일부 금액을 인출할 수 있음 (따로 구현)
    function withDrawOwner(uint _n) public onlyOwner morethanTwoEther {
        owner.transfer(_n * 0.01 ether);
    }

    function withDrawOwnerMax() public onlyOwner morethanTwoEther {
        owner.transfer(address(this).balance);
    }

    //	* 유저 등록 기능 - 유저는 이름만 등록, 번호는 자동적으로 순차 증가, 주소도 자동으로 설정, 점수도 0으로 시작
    function signIn(string memory _name) public {
        require(bytes(users[msg.sender].name).length==0, "nope");
        users[msg.sender] = USER(idx++, _name, msg.sender, 0,0);
    }

    // * 유저 조회 기능 - 유저의 전체정보 번호, 이름, 주소, 점수를 반환. 
    function search(address _addr) public view returns(USER memory) {
        return users[_addr];
    }

    // * 게임 참가시 참가비 제출 기능 - 참가시 0.01eth 지불 (돈은 smart contract가 보관)
    function join() public payable {
        require(bytes(users[msg.sender].name).length!=0 && (msg.value == 0.01 ether || users[msg.sender].balance >= 0.01 ether), "Nope");

        if(msg.value < 0.01 ether) {
            users[msg.sender].balance -= 0.01 ether;
        }

        if(getLength()==3) {
            room[3] = msg.sender;
            getScore();
            delete room;
        } else {
            room[getLength()] = msg.sender;
        }

    }

    function getLength() public view returns(uint) {
        for(uint i=0; i<4; i++) {
            if(users[room[i]].number ==0) {
                return i;
            }
        }

        return 4;
    }

    function getScore() public {
        for(uint i=0; i<4; i++) {
            users[room[i]].score += 4-i;
        }
    }

    // * 점수를 돈으로 바꾸는 기능 - 10점마다 0.1eth로 환전
    function withDrawTen() public {
        require(users[msg.sender].score >= 10, "nope");
        users[msg.sender].score -= 10;
        payable(msg.sender).transfer(0.1 ether);
    }

    function withDraw(uint _n) public {
        require(users[msg.sender].score >= _n, "nope");
        users[msg.sender].score -= _n;
        payable(msg.sender).transfer((_n/10) * 0.1 ether);
    }

    function withDrawMax() public {
        require(users[msg.sender].score >=10, "nope");
        uint amount = users[msg.sender].score / 10;
        users[msg.sender].score = users[msg.sender].score%10; // %= 10
        payable(msg.sender).transfer(amount * 0.1 ether);
    }

    // * 예치 기능 - 게임할 때마다 참가비를 내지 말고 유저가 일정금액을 미리 예치하고 게임할 때마다 자동으로 차감시키는 기능.
    function deposit() public payable {
        users[msg.sender].balance += msg.value;
    }
}
