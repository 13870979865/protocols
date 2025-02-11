/*

  Copyright 2017 Loopring Project Ltd (Loopring Foundation).

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
pragma solidity ^0.5.11;

import "../lib/AddressSet.sol";

import "../iface/BankRegistry.sol";


/// @title BaseBankRegistry
/// @dev Basic implementation of a BankRegistry.
///
/// @author Daniel Wang - <daniel@loopring.org>
contract BaseBankRegistry is BankRegistry, AddressSet
{
    bytes32 internal constant MODULE = keccak256("__MODULE__");
    bytes32 internal constant WALLET = keccak256("__WALLET__");

    address internal factory;

    event WalletRegistered      (address indexed wallet);
    event ModuleRegistered      (address indexed module);
    event ModuleDeregistered    (address indexed module);
    event WalletFactoryUpdated  (address factory);

    modifier onlyFactory()
    {
        require(msg.sender == factory, "UNAUTHORIZED");
        _;
    }

    constructor() public Claimable() {}

    function setWalletFacgtory(address _factory)
        external
        onlyOwner
    {
        require(_factory != address(0), "ZERO_ADDRESS");
        factory = _factory;
        emit WalletFactoryUpdated(factory);
    }

    function registerWallet(address wallet)
        external
        onlyFactory
    {
        addAddressToSet(WALLET, wallet, false);
        emit WalletRegistered(wallet);
    }

    function isWallet(address addr)
        public
        view
        returns (bool)
    {
        return isAddressInSet(WALLET, addr);
    }

    function numOfWallets()
        public
        view
        returns (uint)
    {
        return numAddressesInSet(WALLET);
    }

    function registerModule(address module)
        external
        onlyOwner
    {
        addAddressToSet(MODULE, module, true);
        emit ModuleRegistered(module);
    }

    function deregisterModule(address module)
        external
        onlyOwner
    {
        removeAddressFromSet(MODULE, module);
        emit ModuleDeregistered(module);
    }

    function isModuleRegistered(address module)
        public
        view
        returns (bool)
    {
        return isAddressInSet(MODULE, module);
    }

    function numOfModules()
        public
        view
        returns (uint)
    {
        return numAddressesInSet(MODULE);
    }
}