// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.15;

contract a {
    /*
    * 악셀 기능 - 속도를 10 올리는 기능, 악셀 기능을 이용할 때마다 연료가 20씩 줄어듬, 연료가 30이하면 더 이상 악셀을 이용할 수 없음, 속도가 70이상이면 악셀 기능은 더이상 못씀
    * 주유 기능 - 주유하는 기능, 주유를 하면 1eth를 지불해야하고 연료는 100이 됨
    * 브레이크 기능 - 속도를 10 줄이는 기능, 브레이크 기능을 이용할 때마다 연료가 10씩 줄어듬, 속도가 0이면 브레이크는 더이상 못씀
    * 시동 끄기 기능 - 시동을 끄는 기능, 속도가 0이 아니면 시동은 꺼질 수 없음
    * 시동 켜기 기능 - 시동을 켜는 기능, 시동을 키면 정지 상태로 설정됨
--------------------------------------------------------
    * 충전식 기능 - 지불을 미리 해놓고 추후에 주유시 충전금액 차감 
    */


    struct car {
        uint speed;
        uint fuel;
        bool start;
    }

    car Car;
    address payable wallet;

    constructor () {
        Car = car(0,100,false);
    }

    modifier isStart {
        require(Car.start,"start Car");
        _;
    }
    
    modifier isStop {
        require(Car.start == false,"start Car");
        _;
    }

    //시동 켜기 기능 - 시동을 켜는 기능, 시동을 키면 정지 상태로 설정됨
    function startCar() public isStop returns(car memory) {
        Car = car(Car.speed,Car.fuel,true);
        return Car;
    }

    //시동 끄기 기능 - 시동을 끄는 기능, 속도가 0이 아니면 시동은 꺼질 수 없음
    function stopCar() public isStart returns(car memory) {
        require(Car.speed == 0, "speed should be 0");
        Car = car(0,Car.fuel,false);
        return Car;
    }

    function getCar() public view returns(car memory) {
        return Car;
    }

    //악셀 기능 - 속도를 10 올리는 기능, 악셀 기능을 이용할 때마다 연료가 20씩 줄어듬, 
    //연료가 30이하면 더 이상 악셀을 이용할 수 없음, 속도가 70이상이면 악셀 기능은 더이상 못씀
    function accelCar() public isStart{
        require((Car.fuel > 30 ) && (Car.speed < 70), "check fuel or speed");
        Car.speed += 10;
        Car.fuel -= 20;
    }

    //* 브레이크 기능 - 속도를 10 줄이는 기능, 브레이크 기능을 이용할 때마다 연료가 10씩 줄어듬, 속도가 0이면 브레이크는 더이상 못씀
    function brackCar() public isStart {
        require(Car.speed > 0, "check speed");
        Car.speed -= 10;
    }

    //주유 기능 - 주유하는 기능, 주유를 하면 1eth를 지불해야하고 연료는 100이 됨
    function getFuel() public payable isStop{
        require(msg.value == 1 ether, "pay 1 ether");
        Car.fuel += 100;
    }

    //충전식 기능 - 지불을 미리 해놓고 추후에 주유시 충전금액 차감
}