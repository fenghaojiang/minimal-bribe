pragma solidity ^0.8.20;


import "forge-std/Test.sol";
import "forge-std/console.sol";
import "forge-std/Vm.sol";
import {HuffConfig} from "foundry-huff/HuffConfig.sol";
import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";


// forge test -vvv --mc MinimalBribeTest
contract MinimalBribeTest is Test {
    address public baddr;

    function setUp() public {
        baddr = HuffDeployer.config().deploy("minimal_bribe");
    }

    function testBribe(uint256 value) public {
        vm.coinbase(0x7a8cf01D2d22F4215DB92633096eeD373B8B3f0d);
        vm.deal(address(this), value);
        
        (bool success,) = address(baddr).call{value: value}("");
        require(success, "bribe failed");

        console.log("coinbase address", block.coinbase);
        assertEq(address(this).balance, 0, "Wrong balance of this address");
        assertEq(address(0x7a8cf01D2d22F4215DB92633096eeD373B8B3f0d).balance, value, "Wrong balance of coinbase address");
    }
}