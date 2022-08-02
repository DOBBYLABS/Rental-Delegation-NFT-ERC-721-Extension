// SPDX-License-Identifier: CC0-1.0

pragma solidity ^0.8.0;

interface IERC4907 {
    // Logged when the user of a token assigns a new user or updates expires
    /// @notice Emitted when the `user` of an NFT or the `expires` of the `user` is changed
    /// The zero address for user indicates that there is no user address
    event UpdateUser(uint256 indexed tokenId, address indexed user, uint64 expires, bool borrowed);

    /**
     * @dev Emitted when `owner` enables `authorize` to manage setUser of the `tokenId` token.
     */
    event Authorized(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`authorized`) `operator` to setUser on all of its assets.
     */
    event AuthorizeForAll(address indexed owner, address indexed operator, bool approved);

    /// @notice set the user and expires of a NFT
    /// @dev The zero address indicates there is no user 
    /// Throws if `tokenId` is not valid NFT
    /// @param user  The new user of the NFT
    /// @param expires  UNIX timestamp, The new user could use the NFT before expires
    function setUser(uint256 tokenId, address user, uint64 expires, bool borrowed) external ;

    /// @notice Get the user address of an NFT
    /// @dev The zero address indicates that there is no user or the user is expired
    /// @param tokenId The NFT to get the user address for
    /// @return The user address for this NFT
    function userOf(uint256 tokenId) external view returns(address);

    /// @notice Get the user expires of an NFT
    /// @dev The zero value indicates that there is no user 
    /// @param tokenId The NFT to get the user expires for
    /// @return The user expires for this NFT
    function userExpires(uint256 tokenId) external view returns(uint256);


    /**
     * @dev Gives permission to `to` to setUser `tokenId` token to another account.
     * The authorized is cleared when the token change setUser.
     *
     * Only a single account can be authorized at a time, so authorizing the zero address clears previous authorizations.
     *
     * Requirements:
     *
     * - The caller must own the token or be an authorized operator.
     * - `tokenId` must exist.
     *
     * Emits an {Authroize} event.
     */
    function authorize(address to, uint256 tokenId) external;

    /**
     * @dev Authorize or remove `operator` as an operator for the caller.
     * Operators can call {setUser} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {AuthorizeForAll} event.
     */
    function setAuthorizedForAll(address operator, bool _approved) external;

    /**
     * @dev Returns the account authorized for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getAuthorized(uint256 tokenId) external view returns (address operator);


    /**
     * @dev Returns if the `operator` is allowed to setUser on all of the assets of `owner`.
     *
     * See {setAuthorizedForAll}
     */
    function isAuthorizedForAll(address owner, address operator) external view returns (bool);
}