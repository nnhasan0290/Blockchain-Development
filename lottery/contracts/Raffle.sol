//Raffle 
//Enter the lottery
//Pick a random winner
//Winner to be selected in every x minutes -> completely automated
//Chainlink oracle -> Randomness automated execution(Chainlink keepers)

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
error Raffle__NotEnoughEthEntered();
error Raffle__TransferFailed();

contract Raffle is VRFConsumerBaseV2{
    /*state variables*/
    uint256 private immutable i_entranceFee;
    address payable[] private s_players;
    VRFCoordinatorV2Interface private immutable i_VrfCoordinator;
    bytes32 private immutable i_gasLane;
    uint64 private immutable i_subscriptionId;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private immutable i_callbackGasLimit;
    uint 32 private immutable NUM_WORDS = 1;

    //Lottery variable
    adderss private s_recentWinner;

    /* Events */
    event RaffleEnter(address indexed player);
    event RequestRaffleWinner(uint256 indexed requestId);
    event winnerPicked (address indexed winner);

    constructor(
        address VrfCoordinatorV2,
        uint256 entranceFee,
        bytes32 gasLane,
        uint64 subscriptionId,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2(VrfCoordinatorV2){
       i_entranceFee = entranceFee;
       i_VrfCoordinator = VRFCoordinatorV2Interface(VrfCoordinatorV2);
       i_gasLane = gasLane;
       i_subscriptionId = subscriptionId;
       i_callbackGasLimit = callbackGasLimit;
    }

    function enterRaffle() public payable {
        if(msg.value < i_entranceFee){
            revert Raffle__NotEnoughEthEntered();
        }
        s_players.push(payable(msg.sender));
        emit RaffleEnter(msg.sender);
    } 

    function requestRandomWinner() external{
        requestId = COORDINATOR.requestRandomWords(
            i_gasLane,
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
          );
          emit RequestRaffleWinner(requestId);

    }

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory randomWords
        ) internal override {
           uint256 indexOfwinner = randomWords % s_players.length;
           address payable recentWinner = s_players[indexOfwinner];
           s_recentWinner = recentWinner;
           (bool success,) = recentWinner.call{value: address(this).balance("")};
           if(!success){
            revert Raffle__TransferFailed();
        }
        emit winnerPicked(recentWinner);
    }




    function getEntranceFee() public view returns(uint256){
        return i_entranceFee;
    }

    function getPlayer(uint256 index ) public view returns (address) {
         return s_players[index];
    }

    function getRecentWinner() public view reurns(address){
        return s_recentWinner;
    }
}