// SPDX-License-Identifier: CC0-1.0

pragma solidity ^0.8.0;

/**
 * @title IERCXEnumerable - extention for ERCX which adds the option to query user tokens.
 * @dev See ---proposal_link---
 * @notice the ERC-165 identifier for this interface is 0x1d350ef8.
 */
interface IERCXEnumerable /* is IERCXBalance, IERCX */{
    /**
     * @notice Enumerate NFTs assigned to a user.
     * @dev Reverts is user is zero address or _index >= userBalanceOf(_owner).
     * @param _user an address to query tokens for
     * @return uint256 the token ID for given index assigned to _user
     */
    function tokenOfUserByIndex(address _user, uint256 _index) external view returns (uint256);
}
