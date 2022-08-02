// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0; 

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./IERC4907.sol";

contract ERC4907 is ERC721, IERC4907 {
    
    struct UserInfo 
    {
        address user;   // address of user role
        uint64 expires; // unix timestamp, user expires)
        bool isborrowed;
    }
    mapping(uint256 => address) private _owners_users;
    mapping(uint256 => address) private _tokenApprovalsUsers;
    mapping(address => mapping(address => bool)) private _operatorAuthorized;

    mapping (uint256  => UserInfo) internal _users;
    constructor(string memory name_, string memory symbol_)
     ERC721(name_,symbol_)
     {         
     }
    
    /// @notice set the user and expires of a NFT
    /// @dev The zero address indicates there is no user 
    /// Throws if `tokenId` is not valid NFT
    /// @param user  The new user of the NFT
    /// @param expires  UNIX timestamp, The new user could use the NFT before expires
    function setUser(uint256 tokenId, address user, uint64 expires, bool borrowed) public virtual{
       /// require(_isApprovedOrOwner(msg.sender, tokenId),"ERC721: transfer caller is not owner nor approved"); ?? not sure if that keep
        require(_isAuthorizedOrOwner(msg.sender, tokenId),"ERC721: transfer caller is not owner nor approved");
        require(!_users[tokenId].borrowed,"Only one active borrow is allowed");
        delete _tokenApprovalsUsers[tokenId];
        UserInfo storage info =  _users[tokenId];
        info.user = user;
        info.expires = expires;
        info.borrowed = borrowed;
        emit UpdateUser(tokenId,user,expires,borrowed);
    }

    /// @notice Get the user address of an NFT
    /// @param tokenId The NFT to get the user address for
    /// @return The user address for this NFT
    function userOf(uint256 tokenId)public view virtual returns(address){
        require (uint256(_users[tokenId].expires) >=  block.timestamp, "ERC4907: user doesnt exist for this token");
        return  _users[tokenId].user; 
    }

    /// @notice Get the user expires of an NFT
    /// @dev The zero value indicates that there is no user 
    /// @param tokenId The NFT to get the user expires for
    /// @return The user expires for this NFT
    function userExpires(uint256 tokenId) public view virtual returns(uint256){
        return _users[tokenId].expires;
    }

    /// @dev See {IERC165-supportsInterface}.
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC4907).interfaceId || super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override{
        super._beforeTokenTransfer(from, to, tokenId);
        if (from != to && _users[tokenId].borrowed == false) {
            delete _users[tokenId];
            emit UpdateUser(tokenId, address(0), 0, false);
        }
    }

    /**
     * @dev See {IERC4907-authorize}.
     */
    function authorize(address to, uint256 tokenId) public virtual override {
        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(
            _msgSender() == owner,
            "ERC721: approve caller is not token owner"
        );

        _auhthorize(to, tokenId);
    }

    /**
     * @dev Authorize `to` to operate on `tokenId`
     *
     * Emits an {Authorize} event.
     */
    function _auhthorize(address to, uint256 tokenId) internal virtual {
        _tokenApprovalsUsers[tokenId] = to;
        emit Authorize(ERC721.ownerOf(tokenId), to, tokenId);
    }

    /**
     * @dev See {IERC4907-getAuthorized}.
     */
    function getAuthorized(uint256 tokenId) public view virtual override returns (address) {
        ERC721._requireMinted(tokenId);

        return _tokenApprovalsUsers[tokenId];
    }

    /**
     * @dev Returns whether `spender` is allowed to setUser of `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _isAuthorizedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner || isAuthorizedForAll(owner, spender) || getAuthorized(tokenId) == spender);
    }


    /**
     * @dev See {IERC4907-isAuthorizedForAll}.
    */
    function isAuthorizedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorAuthorized[owner][operator];
    }

    /**
     * @dev See {IERC4907-setAuthorizedForAll}.
    */
    function setAuthorizedForAll(address operator, bool approved) public virtual override {
        _setAuthorizedForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev Authorize `operator` to operate on all of `owner` tokens to setUser on it 
     *
     * Emits an {AuthorizeForAll} event.
     */

    function _setAuthorizedForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        require(owner != operator, "ERC721: approve to caller");
        _operatorAuthorized[owner][operator] = approved;
        emit AuthorizeForAll(owner, operator, approved);
    }


} 