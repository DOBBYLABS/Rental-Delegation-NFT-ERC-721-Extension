// SPDX-License-Identifier: CC0-1.0

pragma solidity ^0.8.0; 

import "./ERCX.sol";
import "./IERCXTerminable.sol";

/**
 * @dev Implementation of ---proposal_link--- with OpenZeppelin ERC721 version.
 */
contract ERCXTerminable is IERCXTerminable, ERCX {
    /**
     * @dev Structure to hold agreements from both parties to terminate a borrow.
     * @notice If both parties agree, it is possible to modify UserInfo even before it expires.
     */
    struct BorrowTerminationInfo {
        bool lenderAgreement;
        bool borrowerAgreement;
    }

    // Mapping from token ID to BorrowTerminationInfo
    mapping (uint256 => BorrowTerminationInfo) internal _borrowTerminations;
    
    /**
     * @dev Initializes the contract by setting a name and a symbol to the token collection.
     */
    constructor(string memory name_, string memory symbol_) ERCX(name_, symbol_) {}

    /**
     * @dev See {IERCX-setUser}.
     */
    function setUser(
        uint256 tokenId, 
        address user, 
        uint64 expires, 
        bool isBorrowed
    ) public virtual override {
        super.setUser(tokenId, user, expires, isBorrowed);
        delete _borrowTerminations[tokenId];
    }

    /**
     * @dev See {IERCXTerminable-setBorrowTermination}.
     */
    function setBorrowTermination(uint256 tokenId) public virtual override {
        UserInfo memory userInfo = _users[tokenId];
        require(
            userInfo.expires >= block.timestamp 
            && userInfo.isBorrowed, 
            "ERCXTerminable: borrow not active"
        );

        BorrowTerminationInfo storage terminationInfo = _borrowTerminations[tokenId];
        address owner = ownerOf(tokenId);
        address user = userOf(tokenId);
        if(owner == msg.sender) {
            terminationInfo.lenderAgreement == true;
            emit AgreeToTerminateBorrow(tokenId, msg.sender, true);
        }
        if(user == msg.sender) {
            terminationInfo.borrowerAgreement == true;
            emit AgreeToTerminateBorrow(tokenId, msg.sender, false);
        }
    }

    /**
     * @dev See {IERCXTerminable-getBorrowTermination}.
     */
    function getBorrowTermination(uint256 tokenId) public view virtual override returns (bool, bool) {
        return (_borrowTerminations[tokenId].lenderAgreement, _borrowTerminations[tokenId].borrowerAgreement);
    }

    /**
     * @dev See {IERCXTerminable-terminateBorrow}.
     */
    function terminateBorrow(uint256 tokenId) public virtual override {
        BorrowTerminationInfo storage info = _borrowTerminations[tokenId];
        require(info.borrowerAgreement && info.lenderAgreement, "ERCXTerminable: not agreed");
        _users[tokenId].isBorrowed = false;
        delete _borrowTerminations[tokenId];
        emit TerminateBorrow(tokenId, msg.sender, ownerOf(tokenId), _users[tokenId].user);
    }

    /**
     * @dev See {EIP-165: Standard Interface Detection}.
     * https://eips.ethereum.org/EIPS/eip-165
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERCXTerminable).interfaceId || super.supportsInterface(interfaceId);
    }
}
