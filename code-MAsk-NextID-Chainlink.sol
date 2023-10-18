// SPDX-License-Identifier:MIT 
pragma solidity ^0.8.18;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorInterface.sol";
contract DecenTalk {

    struct User {
        string maskNetworkHandle;
        string nextIDHandle;
        string timezone;
        uint256 availableTimeOffset;
        bool isRegistered;
        uint256 worldClockTime; // store the world clock time for each user
    }

    mapping(address => User) public users;

    event UserRegistered(address indexed userAddress, string maskNetworkHandle);
    event NextIDLinked(address indexed userAddress, string nextIDHandle);
    event TimezoneUpdated(address indexed userAddress, string timezone);
    event AvailableTimeOffsetUpdated(address indexed userAddress, uint256 availableTimeOffset);
    event WorldClockTimeUpdated(address indexed userAddress, uint256 worldClockTime);

    modifier isNotRegistered(){
        require(!users[msg.sender].isRegistered, "User already registered.");
        _;
    }
    modifier isRegistered(){
        require(users[msg.sender].isRegistered, "User not registered");
        _;
    }

    // User onboarding functions
    function registerUser(string memory _maskNetworkHandle) public isNotRegistered {
        User memory newUser;
        newUser.maskNetworkHandle = _maskNetworkHandle;
        newUser.isRegistered = true;
        users[msg.sender] = newUser;

        emit UserRegistered(msg.sender, _maskNetworkHandle);
    }

    function linkNextID(string memory _nextIDHandle) public isRegistered {
        require(bytes(_nextIDHandle).length > 0, "Invalid NextID handle.");

        users[msg.sender].nextIDHandle = _nextIDHandle;

        emit NextIDLinked(msg.sender, _nextIDHandle);
    }

    // Timezone functions
    function updateUserProfileWithTimezone(string memory _timezone) public isRegistered {
        users[msg.sender].timezone = _timezone;

        emit TimezoneUpdated(msg.sender, _timezone);
    }

    function getUserTimezone(address _userAddress) public view returns (string memory) {
        return users[_userAddress].timezone;
    }

    // World Clock time functions
    function updateUserWorldClockTime(uint256 _worldClockTime) public isRegistered {
        users[msg.sender].worldClockTime = _worldClockTime;

        emit WorldClockTimeUpdated(msg.sender, _worldClockTime);
    }

    function getUserWorldClockTime(address _userAddress) public view returns (uint256) {
        return users[_userAddress].worldClockTime;
    }

    // Available time functions
    function updateUserProfileWithAvailableTimeOffset(uint256 _availableTimeOffset) public isRegistered {
        users[msg.sender].availableTimeOffset = _availableTimeOffset;

        emit AvailableTimeOffsetUpdated(msg.sender, _availableTimeOffset);
    }

    function getUserAvailableTimeInTimezone(address _userAddress) public view returns (uint256) {
    
        //mock that returns the user's world clock time added to their available time offset
        return users[_userAddress].worldClockTime + users[_userAddress].availableTimeOffset;
        
    }

}
