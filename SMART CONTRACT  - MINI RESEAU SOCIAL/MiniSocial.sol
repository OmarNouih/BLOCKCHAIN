// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MiniSocial {

    event NewPostEvent(uint indexed postId, string message, address indexed author, uint timestamp);
    
    struct Comment {
        address author;
        string content;
        uint numLikes;
    }

    struct Post {
        uint id;
        string message;
        address author;
        uint numLikes;
        Comment[] comments;
    }

    Post[] private posts;

    mapping(uint => mapping(address => bool)) private hasLiked;

    function publishPost(string memory _message) public {
        require(bytes(_message).length > 0, "Post cannot be empty.");
        require(bytes(_message).length <= 140, "Post is too long.");

        uint postId = posts.length;
        Post storage newPost = posts.push();
        newPost.id = postId;
        newPost.message = _message;
        newPost.author = msg.sender;
        newPost.numLikes = 0;

        emit NewPostEvent(postId, _message, msg.sender, block.timestamp);
    }

    function getPostAuthor(uint _postId) public view returns (address) {
        require(_postId < posts.length, "Invalid post ID.");
        return posts[_postId].author;
    }

    function getPostLikes(uint _postId) public view returns (uint) {
        require(_postId < posts.length, "Invalid post ID.");
        return posts[_postId].numLikes;
    }

    function getTotalPosts() public view returns (uint) {
        return posts.length;
    }

    function getPost(uint _postId) public view returns (string memory, address) {
        require(_postId < posts.length, "Invalid post ID.");
        Post storage post = posts[_postId];
        return (post.message, post.author);
    }

    function getAllPosts() public view returns (Post[] memory) {
        return posts;
    }

    function addLike(uint _postId) public {
        require(_postId < posts.length, "Invalid post ID.");
        require(!hasLiked[_postId][msg.sender], "You have already liked this post.");
        
        posts[_postId].numLikes++;
        hasLiked[_postId][msg.sender] = true;
    }

    function addComment(uint _postId, string memory _content) public {
        require(_postId < posts.length, "Invalid post ID.");
        require(bytes(_content).length > 0, "Comment cannot be empty.");
        
        Post storage post = posts[_postId];
        post.comments.push(Comment({
            author: msg.sender,
            content: _content,
            numLikes: 0
        }));
    }

    function getPostComments(uint _postId) public view returns (Comment[] memory) {
        require(_postId < posts.length, "Invalid post ID.");
        return posts[_postId].comments;
    }

    function likeComment(uint _postId, uint _commentId) public {
        require(_postId < posts.length, "Invalid post ID.");
        Post storage post = posts[_postId];
        require(_commentId < post.comments.length, "Invalid comment ID.");
        
        post.comments[_commentId].numLikes++;
    }
}
