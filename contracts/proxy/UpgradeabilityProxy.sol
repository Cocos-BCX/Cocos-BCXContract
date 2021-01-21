pragma solidity ^0.5.0;


import "./Proxy.sol";

library AddressUtils {
    function isContract(address addr) internal view returns (bool) {
        uint256 size;

        assembly {
            size := extcodesize(addr)
        }
        return size > 0;
    }
}

contract UpgradeabilityProxy is Proxy {
    event Upgraded(address implementation);

    bytes32
        private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;

    constructor(address _implementation) public {
        assert(
            IMPLEMENTATION_SLOT ==
                keccak256("org.zeppelinos.proxy.implementation")
        );

        _setImplementation(_implementation);
    }

    function _implementation() internal view returns (address impl) {
        bytes32 slot = IMPLEMENTATION_SLOT;
        assembly {
            impl := sload(slot)
        }
    }

    function _upgradeTo(address newImplementation) internal {
        _setImplementation(newImplementation);
        emit Upgraded(newImplementation);
    }

    function _setImplementation(address newImplementation) private {
        require(
            AddressUtils.isContract(newImplementation),
            "Cannot set a proxy implementation to a non-contract address"
        );

        bytes32 slot = IMPLEMENTATION_SLOT;

        assembly {
            sstore(slot, newImplementation)
        }
    }
}