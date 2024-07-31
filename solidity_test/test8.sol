// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.15;

contract a {
    /*
    안건을 올리고 이에 대한 찬성과 반대를 할 수 있는 기능을 구현하세요. 
    안건은 번호, 제목, 내용, 제안자(address) 그리고 찬성자 수와 반대자 수로 이루어져 있습니다.(구조체)
    안건들을 모아놓은 자료구조도 구현하세요. 

    사용자는 자신의 이름과 주소, 자신이 만든 안건 그리고 자신이 투표한 안건과 어떻게 투표했는지(찬/반)에 대한 정보[string => bool]로 이루어져 있습니다.(구조체)

    * 사용자 등록 기능 - 사용자를 등록하는 기능
    * 투표하는 기능 - 특정 안건에 대하여 투표하는 기능, 안건은 제목으로 검색, 이미 투표한 건에 대해서는 재투표 불가능
    * 안건 제안 기능 - 자신이 원하는 안건을 제안하는 기능
    * 제안한 안건 확인 기능 - 자신이 제안한 안건에 대한 현재 진행 상황 확인기능 - (번호, 제목, 내용, 찬반 반환 // 밑의 심화 문제 풀었다면 상태도 반환)
    * 전체 안건 확인 기능 - 제목으로 안건을 검색하면 번호, 제목, 내용, 제안자, 찬반 수 모두를 반환하는 기능
-------------------------------------------------------------------------------------------------
    * 안건 진행 과정 - 투표 진행중, 통과, 기각 상태를 구별하여 알려주고 15개 블록 후에 전체의 70%가 투표에 참여하고 투표자의 66% 이상이 찬성해야 통과로 변경, 둘 중 하나라도 만족못하면 기각
    */


    //user struct 안에 맵핑이 들어가야 할 것 같은데 struct안에 맵핑이 있을 때
    //유저를 형성 한다고 하면 어떤식으로 해줘야 할지 잘 모르겠어서 맵핑을 따로 밖으로 뺐습니다
    //질문 사항 : struct안에 배열과 맵핑이 있을 때 function setUser() 함수를 어떻게 구현해야 하는지 궁금합니다

    struct topic {
        uint number;
        string subject;
        string content;
        address proposer;
        uint upvote;
        uint downvote;
    }

    mapping(uint => topic) topics;

    struct user {
        string name;
        address wallet;
    }
    
    mapping(address => mapping(string => bool)) vote;
    mapping(string => user) users;
    uint topicNum=1;

    //* 사용자 등록 기능 - 사용자를 등록하는 기능
    function setUser(string memory _name) public {
        users[_name] = user(_name, msg.sender);
    }

    function getUser(string memory _name) public view returns(user memory) {
        return users[_name];
    }
    
    //* 안건 제안 기능 - 자신이 원하는 안건을 제안하는 기능
    function setTopic(string memory _subject, string memory _content) public {
        topics[topicNum] = topic(topicNum, _subject, _content, msg.sender,0,0);
        topicNum++;
    }
    //제안한 안건 확인 기능 - 자신이 제안한 안건에 대한 현재 진행 상황 확인기능 - (번호, 제목, 내용, 찬반 반환 // 밑의 심화 문제 풀었다면 상태도 반환)
    function getTopic(uint _topicNum) public view returns(topic memory) {
        return topics[_topicNum];
    }
    //전체 안건 확인 기능 - 제목으로 안건을 검색하면 번호, 제목, 내용, 제안자, 찬반 수 모두를 반환하는 기능
    function getTopics() public view returns(topic[] memory) {
        topic[] memory topicArray = new topic[](topicNum);
        for (uint i = 0; i < topicNum; i++){
            topicArray[i] = topics[i];
        }
        return topicArray;
    }


    //* 투표하는 기능 - 특정 안건에 대하여 투표하는 기능, 안건은 제목으로 검색, 이미 투표한 건에 대해서는 재투표 불가능
    function voting(uint _topicNum, string memory _subject, bool _vote) public {
        require(vote[msg.sender][_subject] == false, "already voted");
        if(_vote == true) {
            topics[_topicNum].upvote += 1;
            vote[msg.sender][_subject] = true;
        } else {
            topics[_topicNum].downvote += 1;
            vote[msg.sender][_subject] = true;
        }
    }

    
   //문제점 투표할 때 topic 번호와 제목 둘다 넣어야 되는 점
   //유저를 검색했을 때 어떤 topic제안했는지 찬반은 어떤지 -> 
   
}

contract TrAnswer {

    struct Prop {
        uint number;
        string title;
        string content;
        address proposer;
        uint pros;
        uint cons;
        status result;
        uint blockNumber;
    }

    enum status {
        ongoing,
        passed,
        failed
    }

    mapping(string => Prop) public proposals;
    uint propCount =1;

    struct User {
        string name;
        address addr;
        string[] proposalsA; // 이거도 피해
        mapping(string => bool) votes; // 이거 initialize하는거 피해 어려우니까
        mapping(string => bool) voted; // 이거는 재투표를 막기 위해 넣은거고 위에 votes는 뭘로 투표했는지 보려고 둔거
    }
    //User에 proposals랑 vote는 signUp에서는 못 넣어

    mapping(address => User) users;
    uint userCount;

    function signUp(string calldata _name) public {
        require(users[msg.sender].addr == address(0)); //유저가 0주소 여야만 한다
        users[msg.sender].name = _name;
        users[msg.sender].addr = msg.sender;
        userCount++;
        //proposal랑 votes는 처음에 init해서 값 넣어주기가 매우 복잡해서 그냥 비워놓고 위처럼만 signUp해도되
    }

    function propose(string calldata _title, string calldata _content) public {
        proposals[_title] = Prop(propCount++, _title, _content, msg.sender,0,0,status.ongoing,block.number);
        users[msg.sender].proposalsA.push(_title);
    }

    function vote(string calldata _title, bool _isPro) public {
        require(users[msg.sender].addr != address(0));
        require(users[msg.sender].voted[_title]==false);
        require(block.number <= proposals[_title].blockNumber+15&&proposals[_title].result ==status.ongoing);
        
        _isPro ? proposals[_title].pros++ : proposals[_title].cons++;

        users[msg.sender].votes[_title] = _isPro;
        users[msg.sender].voted[_title] = true;
    }

    //setResult는 솔리디티 내부에서는 안되고 web3로 밖에서 이 함수를 실행해 줘야한다
    //propose함수에 있는 block.number + 16이 현재 block.number가 되면은 아래 setResult가 실행되야 할거같다 
    function setResult(string calldata _title) public {
        require(proposals[_title].blockNumber + 15 < block.number);
        uint part = proposals[_title].pros + proposals[_title].cons;
        if(part >= userCount * 70 /100 && proposals[_title].pros >= part * 66 /100) {
            proposals[_title].result = status.passed;
        } else {
            proposals[_title].result = status.failed;
        }

        //나누기를 하지말고 양변에 그냥 100을 곱해
        //나누기하면 몫이랑 나머지 이런것 때문에 정확한 계산 어려울 수 있어
        //part >= userCount * 70 /100 를 part * 100 >= userCount * 70 이런식으로
    }

    function getMyProposals() public view returns(Prop[] memory) {
        string[] memory _proposals = users[msg.sender].proposalsA; //유저가 제안한 제안배열
        Prop[] memory res = new Prop[](_proposals.length); 

        for(uint i=0; i<_proposals.length;i++) {
            res[i] = proposals[_proposals[i]]; //유저가 제안한 배열들을 res 지연 변수 배열에 넣어서 아래 반환
        }
        return res;
    }
    function getProposal(string memory _title) public view returns(Prop memory) {
        return proposals[_title];
    }
}

//유저수는 계속 느는데 참여율이 떨어져서 최소 몇프로는 참여해야한다 이걸 충족 못하면
//고민이 될듯 참여를 꽤 했어야 하는데

//트랜잭션 자기가 포함된 블록의 번호를 뱉어낸다
//트랜잭션 블록번호는 이미 채굴이 된것을 의미하니까
