// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;



contract haddi {
    uint public num;
    address public sender;
    uint public value;
    address public contractActuallyCalledNotUsed;

    function setVars(uint _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

// NOTE: Deploy this contract first
contract B {
    // NOTE: storage layout must be the same as contract A
    uint public num;
    address public sender;
    uint public value;
    address public contractActuallyCalled;

    constructor(address _contractActuallyCalled) {
        contractActuallyCalled = _contractActuallyCalled;
    }

    function setVars1(uint _num) public payable {
        (bool success, bytes memory data) = contractActuallyCalled.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }

    function setVarsNoDel(uint _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
    
    function setVars(uint _num) public payable {
        value = _num/2;
        sender = msg.sender;
        value = msg.value;
    }
}

contract A {
    uint public num;
    address public sender;
    uint public value;
    address public contractCalled;

    constructor(address _contractCalled) {
        contractCalled = _contractCalled;
    }
    function setVars(uint _num) public payable {
        // A's storage is set, B is not modified.
        (bool success, bytes memory data) = contractCalled.delegatecall(
            abi.encodeWithSignature("setVars1(uint256)", _num)
        );
    }

    function setVarsTested(uint _num) public payable {
        (bool success, bytes memory data) = contractCalled.delegatecall(
            abi.encodeWithSignature("setVarsNoDel(uint256)", _num)
        );
    }
}
