// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

contract TEST2 {
    /*
    학생 점수관리 프로그램입니다.
    여러분은 한 학급을 맡았습니다.
    학생은 번호, 이름, 점수로 구성되어 있고(구조체)
    가장 점수가 낮은 사람을 집중관리하려고 합니다.

    * 가장 점수가 낮은 사람의 정보를 보여주는 기능,
    * 총 점수 합계, 총 점수 평균을 보여주는 기능,
    * 특정 학생을 반환하는 기능, -> 학생 정보
    ---------------------------------------------------
    * 가능하다면 학생 전체를 반환하는 기능을 구현하세요. ([] <- array)
    */

    struct Student {
        uint number;
        string name;
        uint score;
    }

    Student s1;
    Student[] students;

    function setStudent(string memory _name, uint _score) public {
        s1 = Student(students.length + 1, _name, _score);
        students.push(s1);
    }

    //가장 점수가 낮은 사람의 정보를 보여주는 기능 1,2비교 3비교, 4비교, ...
    function getLowestScoreStudent () public view returns(Student memory) {
        uint LowestScore = students[0].score;
        uint index = 0;
        for (uint i =0; students.length > i; i++) {
            if(LowestScore > students[i].score) {
                LowestScore = students[i].score;
                index = i;
            }
        }
        return students[index];
    }

    //총 점수 합계, 총 점수 평균을 보여주는 기능
    function getTotalScoreAndAvg() public view returns(uint, uint) {
        uint sum;
        for(uint i=0; students.length > i; i++) {
            sum += students[i].score;
        }
        return (sum, sum / students.length);
    }

    //특정 학생을 반환하는 기능, -> 학생 정보
    function getStudent(uint _n) public view returns(Student memory) {
        return students[_n-1];
    }

    // 학생 전체 반환
    function getStudents() public view returns(Student[] memory) {
        return students;
    }

}