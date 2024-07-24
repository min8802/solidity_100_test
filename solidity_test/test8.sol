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