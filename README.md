# Voting System Smart Contract  

This project implements a **decentralized voting system** on the **Supra blockchain**. The contract enables users to initialize voting, cast votes, and retrieve results via API endpoints.

## Features  

✅ **Initialize a voting session** (with a start and end time)  
✅ **Cast a vote** for a selected party  
✅ **Check voting period** (start and end time)  
✅ **Count votes** for each party  
✅ **Verify if an address has voted**  
✅ **Retrieve all votes** (voter address & party)  

## Smart Contract  

The contract is written in **Move** and includes the following key components:  

### Structs  

- **`VotingSystem`**: Manages votes, voters, and event logging.  
- **`Vote`**: Represents a single vote (voter address, party, and timestamp).  
- **`VoteEvent`**: Emits an event when a vote is cast.  

### Error Codes  

| Code | Description |  
|------|-------------|  
| `1` | Voting has not started. |  
| `2` | Voting has ended. |  
| `3` | Voter has already cast a vote. |  
| `4` | Unauthorized action. |  

## API Endpoints  

### 🟢 Initialize Voting  

**POST** `http://localhost:3000/initialize`  

#### Parameters  
```json
{
  "userAccount": {
    "address": "public address",
    "privateKeyHex": "your private key"
  },
  "startTime": "1682572800",
  "endTime": "2082572800"
}
```  

### 🟢 Cast a Vote  

**POST** `http://localhost:3000/cast-vote`  

### Parameters  
For voting from anywhere using your wallet  
Applied on the frontend only, which means the endpoint isn't necessary.  
```json
[
  "voterAddress",
  "party"
]
```

#### Parameters  
For voting stations with no need of paying to cast a vote from the voter.  
The station will pay using the private key  
```json
{
  "userAccount": {
    "privateKeyHex": "probably government id"
  },
  "voterAddress": "voter address",
  "party": "red"
}
```  

### 🟢 Get Voting Period  

**GET** `http://localhost:3000/voting-period`  

🔹 Returns the **start and end time** of the voting session.  

### 🟢 Get Vote Count  

**GET** `http://localhost:3000/vote-count`  

🔹 Returns the number of votes cast for each party.  

### 🟢 Check If a User Has Voted  

**GET**  
```plaintext
https://chainballotbackend.onrender.com/has-voted?address=some_public_address
```  
🔹 Returns `true` or `false` based on whether the user has voted.  

### 🟢 Get All Votes  

**GET** `http://localhost:3000/get-votes`  

🔹 Returns a list of all votes cast, including voter addresses and their chosen party.  

---

## References  

📖 Move Language Documentation: [Move Language](https://move-language.github.io/move/)  
🧠 DeepSeek LLM: [DeepSeek AI](https://www.deepseek.com/)  

---

## Usage  

1️⃣ **Deploy the smart contract**  
2️⃣ **Use `initialize` to start the voting session**  
3️⃣ **Users cast votes using `cast-vote`**  
4️⃣ **Retrieve results via `vote-count` and `get-votes`**  

---

## License  

This project is licensed under the **MIT License**.  

🚀 Happy Voting!

