pragma solidity ^0.5.5;

import "../proxy/AdminUpgradeabilityProxy.sol";

contract PlayerBookProxy is AdminUpgradeabilityProxy {
    constructor(address _implementation)
        public
        AdminUpgradeabilityProxy(_implementation)
    {}

    // Allow anyone to view the implementation address
    function proxyImplementation() external view returns (address) {
        return _implementation();
    }

    function proxyAdmin() external view returns (address) {
        return _admin();
    }
}