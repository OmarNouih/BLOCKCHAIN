# MiniSocial Smart Contract

This repository contains the source code and documentation for the **MiniSocial** smart contract, developed as part of a project in the Master’s program in Artificial Intelligence and Data Science at Abdelmalek Essaadi University.

## Project Overview
The **MiniSocial** smart contract is written in Solidity and enables a decentralized social platform where users can post messages, like posts, and comment on posts. Each post and comment is associated with an author’s Ethereum address, ensuring transparency and ownership.

## Features
- **Post Messages**: Users can publish short messages (max 140 characters) on the platform.
- **Like System**: Each post and comment can receive likes, with each user allowed one like per post or comment.
- **Commenting**: Users can add comments to any post, and comments can receive likes.
- **Author Identification**: Posts and comments show the author’s Ethereum address.

## Smart Contract Details
- **Events**: The contract emits an event, `NewPostEvent`, every time a new post is created.
- **Data Structures**: 
  - `Post` structure for managing posts.
  - `Comment` structure for managing comments.
- **Functions**: Includes functions for posting, liking, commenting, and retrieving posts and comments.

## Deployment
The contract was deployed on a Virtual Machine (VM) due to Ethereum gas cost limitations. This setup allows for testing without transaction fees.

## Usage
- **publishPost**: Adds a new post to the platform.
- **addLike**: Likes a post or comment.
- **addComment**: Adds a comment to a post.

## Contact
For more details, please refer to the accompanying report.

---

This project was developed by **Omar Nouih**, supervised by **Pr. Ikram BenadbeloUahab**, during the 2024-2025 academic year.
