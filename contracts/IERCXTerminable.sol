// SPDX-License-Identifier: CC0-1.0

pragma solidity ^0.8.0;

/**
 * @title IERCXTerminable - extention for ERCX which adds the option to terminate borrowing if both parties agree.
 * @dev See ---proposal_link---
 * @notice the ERC-165 identifier for this interface is 0x6a26417e.
 */
interface IERCXTerminable /* is IERCX */ {
    /**
     * @dev Emitted when one party from borrowing contract approves termination of agreement.
     * @param _isLender true for lender, false for borrower
     */
    event AgreeToTerminateBorrow(uint256 indexed _tokenId, address indexed _party, bool indexed _isLender);

    /**
     * @dev Emitted when borrow of token ID is terminated.
     */
    event TerminateBorrow(uint256 _tokenId, address indexed caller);

    /**
     * @notice Agree to terminate a borrowing.
     * @dev Lender must be ownerOf token ID. Borrower must be userOf token ID.
     * @param _tokenId uint256 ID of the token to set termination info for
     */
    function setBorrowTermination(uint256 _tokenId) external;

    /**
     * @notice Get if it is possible to terminate a borrow agreement.
     * @param _tokenId uint256 ID of the token to get termination info for
     * @return bool, bool first indicates lender agrees, second indicates borrower agrees
     */
    function getBorrowTermination(uint256 _tokenId) external view returns (bool, bool);

    /**
     * @notice Terminate a borrow if both parties agreed.
     * @dev Both parties must have agreed, otherwise revert.
     * @param _tokenId uint256 ID of the token to terminate borrow of
     */
    function terminateBorrow(uint256 _tokenId) external;
}
