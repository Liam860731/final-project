// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {ICollateralPool} from "../interfaces/ICollateralPool.sol";
import {ICollateralPoolAddressesProvider} from "../interfaces/ICollateralPoolAddressesProvider.sol";
import {SToken} from "./SToken.sol";

import {CollateralizeLogic} from "../libraries/logic/CollateralizeLogic.sol";
import {DataTypes} from "../libraries/types/DataTypes.sol";
import {CollateralPoolStorage} from "./CollateralPoolStorage.sol";

contract CollateralPool is ICollateralPool, CollateralPoolStorage, IERC721Receiver {
    function initialize(ICollateralPoolAddressesProvider provider,SToken sToken) external {
        require(!_initialized, "Already initialized");
        _addressesProvider = provider;
        _sToken = sToken;
        _initialized = true;

        emit Initialized(address(provider));
    }

    function collateralize(address nftAsset, uint256 nftTokenId) external override {
        CollateralizeLogic.executeCollateralize(
            _addressesProvider,
            _sToken,
            DataTypes.ExecuteCollateralizeParams({
                initiator: msg.sender,
                nftAsset: nftAsset,
                nftTokenId: nftTokenId
            })
        );
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external pure override returns (bytes4) {
        operator;
        from;
        tokenId;
        data;
        return IERC721Receiver.onERC721Received.selector;
    }
}
