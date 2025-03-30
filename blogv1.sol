// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyToken {
    // Biến lưu trữ CID của từng token
    mapping(uint256 => string) private _cidOfToken;
    mapping(uint256 => string) private _titleOfToken;
    mapping(uint256 => string) private _bannerOfToken;
    mapping(uint256 => uint256) private _timestampOfToken;

    struct Comment {
        address commenter;
        string content;
        uint256 timestamp;
    }

    mapping(uint256 => Comment[]) private _commentsOfToken;

    // Biến lưu trữ tổng số lượng token
    uint256 public totalSupply;
    address public owner;

    event minted(
        uint256 indexed tokenID,
        string title,
        string banner,
        string cid,
        uint256 timestamp
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor() {
        totalSupply = 0;
        owner = msg.sender;
    }

    // Hàm cập nhật CID của một token
    function updateCID(uint256 tokenID, string memory newCID) external onlyOwner {
        require(tokenID < totalSupply, "Token ID does not exist");
        _cidOfToken[tokenID] = newCID;
    }

    // Hàm xóa comment của một token
    function deleteComment(uint256 tokenID, uint256 commentIndex) external onlyOwner {
        require(tokenID < totalSupply, "Token ID does not exist");
        require(commentIndex < _commentsOfToken[tokenID].length, "Comment index out of bounds");
        delete _commentsOfToken[tokenID][commentIndex];
    }

    // Hàm tạo token mới với CID
    function mintToken(
        string memory cid,
        string memory title,
        string memory banner
    ) external onlyOwner {
        uint256 tokenID = totalSupply;
        _cidOfToken[tokenID] = cid;
        _titleOfToken[tokenID] = title;
        _bannerOfToken[tokenID] = banner;
        _timestampOfToken[tokenID] = block.timestamp;
        totalSupply += 1;
        emit minted(tokenID, title, banner, cid, block.timestamp);
    }

    function addComment(uint256 tokenID, string memory content) public {
        require(tokenID < totalSupply, "Token ID does not exist");

        Comment memory newComment = Comment({
            commenter: msg.sender,
            content: content,
            timestamp: block.timestamp
        });

        _commentsOfToken[tokenID].push(newComment);
    }

    function getComments(uint256 tokenID) public view returns (Comment[] memory) {
        require(tokenID < totalSupply, "Token ID does not exist");
        return _commentsOfToken[tokenID];
    }

    // New functions to get token information directly
    function getTokenCID(uint256 tokenID) public view returns (string memory) {
        require(tokenID < totalSupply, "Token ID does not exist");
        return _cidOfToken[tokenID];
    }

    function getTokenTitle(uint256 tokenID) public view returns (string memory) {
        require(tokenID < totalSupply, "Token ID does not exist");
        return _titleOfToken[tokenID];
    }

    function getTokenBanner(uint256 tokenID) public view returns (string memory) {
        require(tokenID < totalSupply, "Token ID does not exist");
        return _bannerOfToken[tokenID];
    }

    function getTokenTimestamp(uint256 tokenID) public view returns (uint256) {
        require(tokenID < totalSupply, "Token ID does not exist");
        return _timestampOfToken[tokenID];
    }

    // Function to get all token information at once
    function getTokenInfo(uint256 tokenID) public view returns (
        string memory cid,
        string memory title,
        string memory banner,
        uint256 timestamp
    ) {
        require(tokenID < totalSupply, "Token ID does not exist");
        return (
            _cidOfToken[tokenID],
            _titleOfToken[tokenID],
            _bannerOfToken[tokenID],
            _timestampOfToken[tokenID]
        );
    }
}