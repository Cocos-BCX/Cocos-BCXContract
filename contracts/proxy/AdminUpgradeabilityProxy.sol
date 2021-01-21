pragma solidity ^0.5.0;

import "./UpgradeabilityProxy.sol";

contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
    event AdminChanged(address previousAdmin, address newAdmin);
    event AdminUpdated(address newAdmin);

    bytes32
        private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
    bytes32
        private constant PENDING_ADMIN_SLOT = 0x54ac2bd5363dfe95a011c5b5a153968d77d153d212e900afce8624fdad74525c;

    modifier ifAdmin() {
        if (msg.sender == _admin()) {
            _;
        } else {
            _fallback();
        }
    }

    constructor(address _implementation)
        public
        UpgradeabilityProxy(_implementation)
    {
        assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));

        _setAdmin(msg.sender);
    }

    function admin() external  ifAdmin returns (address) {
        return _admin();
    }

    function pendingAdmin() external ifAdmin returns (address) {
        return _pendingAdmin();
    }

    function implementation() external ifAdmin returns (address) {
        return _implementation();
    }

    function changeAdmin(address _newAdmin) external ifAdmin {
        require(
            _newAdmin != address(0),
            "Cannot change the admin of a proxy to the zero address"
        );
        require(
            _newAdmin != _admin(),
            "The current and new admin cannot be the same ."
        );
        require(
            _newAdmin != _pendingAdmin(),
            "Cannot set the newAdmin of a proxy to the same address ."
        );
        _setPendingAdmin(_newAdmin);
        emit AdminChanged(_admin(), _newAdmin);
    }

    function updateAdmin() external {
        address _newAdmin = _pendingAdmin();
        require(
            _newAdmin != address(0),
            "Cannot change the admin of a proxy to the zero address"
        );
        require(
            msg.sender == _newAdmin,
            "msg.sender and newAdmin must be the same ."
        );
        _setAdmin(_newAdmin);
        _setPendingAdmin(address(0));
        emit AdminUpdated(_newAdmin);
    }

    function upgradeTo(address newImplementation) external ifAdmin {
        _upgradeTo(newImplementation);
    }

    function upgradeToAndCall(address newImplementation, bytes calldata data)
        external
        payable
        ifAdmin
    {
        _upgradeTo(newImplementation);
        (bool success, ) = address(this).call.value(msg.value)(data);
        require(success, "upgradeToAndCall-error");
    }

    function _admin() internal view returns (address adm) {
        bytes32 slot = ADMIN_SLOT;
        assembly {
            adm := sload(slot)
        }
    }

    function _pendingAdmin() internal view returns (address pendingAdm) {
        bytes32 slot = PENDING_ADMIN_SLOT;
        assembly {
            pendingAdm := sload(slot)
        }
    }

    function _setAdmin(address newAdmin) internal {
        bytes32 slot = ADMIN_SLOT;

        assembly {
            sstore(slot, newAdmin)
        }
    }

    function _setPendingAdmin(address pendingAdm) internal {
        bytes32 slot = PENDING_ADMIN_SLOT;

        assembly {
            sstore(slot, pendingAdm)
        }
    }

    function _willFallback() internal {
        require(
            msg.sender != _admin(),
            "Cannot call fallback function from the proxy admin"
        );
        super._willFallback();
    }
}
