// SPDX-License-Identifier: AGPL-3.0
pragma solidity >=0.8.0 <0.9.0;

interface SVM {
    // Create a new symbolic uint value ranging over [0, 2**bitSize - 1] (inclusive)
    function createUint(uint256 bitSize) external returns (uint256 value);

    // Create a new symbolic byte array with the given byte size
    function createBytes(uint256 byteSize) external returns (bytes memory value);

    // Create a new symbolic uint256 value
    function createUint256() external returns (uint256 value);

    // Create a new symbolic bytes32 value
    function createBytes32() external returns (bytes32 value);

    // Create a new symbolic address value
    function createAddress() external returns (address value);

    // Create a new symbolic boolean value
    function createBool() external returns (bool value);
}

abstract contract SymTest {
    // SVM cheat code address: 0xf3993a62377bcd56ae39d773740a5390411e8bc9
    address internal constant SVM_ADDRESS = address(uint160(uint256(keccak256("svm cheat code"))));

    SVM internal constant svm = SVM(SVM_ADDRESS);
}

contract HalmosCheatCodeTest is SymTest {
    function testSymbolicUint() public {
        uint x = svm.createUint(256);
        uint y = svm.createUint(160);
        uint z = svm.createUint(8);
        assert(0 <= x && x <= type(uint256).max);
        assert(0 <= y && y <= type(uint160).max);
        assert(0 <= z && z <= type(uint8).max);
    }

    function testSymbolicBytes() public {
        bytes memory data = svm.createBytes(2);
        uint x = uint(uint8(data[0]));
        uint y = uint(uint8(data[1]));
        assert(0 <= x && x <= type(uint8).max);
        assert(0 <= y && y <= type(uint8).max);
    }

    function testSymbolicUint256() public {
        uint x = svm.createUint256();
        assert(0 <= x && x <= type(uint256).max);
    }

    function testSymbolicBytes32() public {
        bytes32 x = svm.createBytes32();
        assert(0 <= uint(x) && uint(x) <= type(uint256).max);
        uint y; assembly { y := x }
        assert(0 <= y && y <= type(uint256).max);
    }

    function testSymbolicAddress() public {
        address x = svm.createAddress();
        uint y; assembly { y := x }
        assert(0 <= y && y <= type(uint160).max);
    }

    function testSymbolicBool() public {
        bool x = svm.createBool();
        uint y; assembly { y := x }
        assert(y == 0 || y == 1);
    }
}
