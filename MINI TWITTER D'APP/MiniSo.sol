// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MiniSocial {

    event NewPostEvent(uint indexed postId, string message, address indexed author, uint timestamp);
    event PostUpdatedEvent(uint indexed postId, string newMessage, uint lastModified);
    event PostLikedEvent(uint indexed postId, address indexed liker);
    event PostDislikedEvent(uint indexed postId, address indexed disliker);
    event CommentAddedEvent(uint indexed postId, string content, address indexed commenter);

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
        uint numDislikes;
        uint timestamp;
        uint lastModified;
        Comment[] comments;
    }

    Post[] private posts;
    mapping(uint => mapping(address => bool)) private hasLiked;
    mapping(uint => mapping(address => bool)) private hasDisliked;

    // Publish a new post
    function publishPost(string memory _message) public {
        require(bytes(_message).length > 0, "Post cannot be empty.");
        require(bytes(_message).length <= 140, "Post is too long.");

        uint postId = posts.length;
        Post storage newPost = posts.push();
        newPost.id = postId;
        newPost.message = _message;
        newPost.author = msg.sender;
        newPost.timestamp = block.timestamp;

        emit NewPostEvent(postId, _message, msg.sender, block.timestamp);
    }

    // Get post details
    function getPost(uint _postId) public view returns (
        string memory, 
        address, 
        uint, 
        uint, 
        uint, 
        uint
    ) {
        require(_postId < posts.length, "Invalid post ID.");
        Post storage post = posts[_postId];
        return (
            post.message,
            post.author,
            post.numLikes,
            post.numDislikes,
            post.timestamp,
            post.lastModified
        );
    }

    // Get total number of posts
    function getTotalPosts() public view returns (uint) {
        return posts.length;
    }

    // Edit an existing post (only by author)
    function editPost(uint _postId, string memory _newMessage) public {
        require(_postId < posts.length, "Invalid post ID.");
        Post storage post = posts[_postId];
        require(msg.sender == post.author, "Only the author can edit this post.");
        require(bytes(_newMessage).length > 0, "New message cannot be empty.");
        
        post.message = _newMessage;
        post.lastModified = block.timestamp;

        emit PostUpdatedEvent(_postId, _newMessage, post.lastModified);
    }

    // Like a post
    function likePost(uint _postId) public {
        require(_postId < posts.length, "Invalid post ID.");
        require(!hasLiked[_postId][msg.sender], "You have already liked this post.");

        posts[_postId].numLikes++;
        hasLiked[_postId][msg.sender] = true;

        // Remove dislike if the user had previously disliked the post
        if (hasDisliked[_postId][msg.sender]) {
            posts[_postId].numDislikes--;
            hasDisliked[_postId][msg.sender] = false;
        }

        emit PostLikedEvent(_postId, msg.sender);
    }

    // Dislike a post
    function dislikePost(uint _postId) public {
        require(_postId < posts.length, "Invalid post ID.");
        require(!hasDisliked[_postId][msg.sender], "You have already disliked this post.");

        posts[_postId].numDislikes++;
        hasDisliked[_postId][msg.sender] = true;

        // Remove like if the user had previously liked the post
        if (hasLiked[_postId][msg.sender]) {
            posts[_postId].numLikes--;
            hasLiked[_postId][msg.sender] = false;
        }

        emit PostDislikedEvent(_postId, msg.sender);
    }

    // Add a comment to a post
    function addComment(uint _postId, string memory _content) public {
        require(_postId < posts.length, "Invalid post ID.");
        require(bytes(_content).length > 0, "Comment cannot be empty.");

        Post storage post = posts[_postId];
        post.comments.push(Comment({
            author: msg.sender,
            content: _content,
            numLikes: 0
        }));

        emit CommentAddedEvent(_postId, _content, msg.sender);
    }

    // Get all comments for a post
    function getPostComments(uint _postId) public view returns (Comment[] memory) {
        require(_postId < posts.length, "Invalid post ID.");
        return posts[_postId].comments;
    }

    // Like a comment (for demonstration purposes)
    function likeComment(uint _postId, uint _commentId) public {
        require(_postId < posts.length, "Invalid post ID.");
        Post storage post = posts[_postId];
        require(_commentId < post.comments.length, "Invalid comment ID.");
        
        post.comments[_commentId].numLikes++;
    }
}
