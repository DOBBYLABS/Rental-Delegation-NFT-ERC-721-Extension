// SPDX-License-Identifier: CC0-1.0

pragma solidity ^0.8.0;

/**
 * @title IERCX - rental standard extension for ERC721 tokens.
 * @dev See ---proposal_link---
 * @notice the ERC-165 identifier for this interface is 0xf808ec37.
 */
interface IERCX /* is IERC721 */{
    /**
     * @dev Emitted when the user of an NFT or the expires of the user is changed.
     */
    event UpdateUser(uint256 indexed _tokenId, address indexed _user, uint64 _expires, bool _isBorrowed);

    /**
     * @notice Set the user info of an NFT.
     * @dev User address cannot be zero address.
     * Only approved operator or NFT owner can set user.
     * If NFT is borrowed, the user info cannot be changed until user status expires.
     * @param _tokenId uint256 ID of the token to set user info of
     * @param _user address of the new user
     * @param _expires Unix timestamp of the user info expiry
     * @param _isBorrowed flag whether or not NFT is borrowed
     */
    function setUser(uint256 _tokenId, address _user, uint64 _expires, bool _isBorrowed) external;

    /**
     * @notice Get the user address of an NFT.
     * @dev Reverts is user is not set.
     * @param _tokenId uint256 ID of the token to get the user address for
     * @return address user address for this NFT
     */
    function userOf(uint256 _tokenId) external view returns (address);

    /**
     * @notice Get the user expires of an NFT.
     * @param _tokenId uint256 ID of the token to get the user expires for
     * @return uint64 user expires for this NFT
     */
    function userExpires(uint256 _tokenId) external view returns (uint64);

    /**
     * @notice Get the user isBorrowed of an NFT.
     * @param _tokenId uint256 ID of the token to get the user isBorrowed for
     * @return uint64 user isBorrowed for this NFT
     */
    function userIsBorrowed(uint256 _tokenId) external view returns (bool);
}
