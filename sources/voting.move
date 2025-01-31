module voting::voting_system3 {
    use std::signer;
    use std::vector;
    use supra_framework::account;
    use supra_framework::event;
    use supra_framework::timestamp;

    // Error codes
    const E_VOTING_NOT_STARTED: u64 = 1;
    const E_VOTING_ENDED: u64 = 2;
    const E_ALREADY_VOTED: u64 = 3;
    const E_NOT_AUTHORIZED: u64 = 4;

    struct VotingSystem has key {
        votes: vector<Vote>,
        voters: vector<address>,
        start_time: u64,
        end_time: u64,
        vote_event_handle: event::EventHandle<VoteEvent>,
    }

    struct Vote has store, drop {
        voter: address,
        party: vector<u8>, // "Red" or "Blue"
        timestamp: u64,
    }

    struct VoteEvent has store, drop {
        voter: address,
        party: vector<u8>,
        timestamp: u64,
    }

    public entry fun initialize(account: &signer, start_time: u64, end_time: u64) {
        let addr = signer::address_of(account);
        assert!(account::exists_at(addr), E_NOT_AUTHORIZED);
        
        move_to(account, VotingSystem {
            votes: vector::empty(),
            voters: vector::empty(),
            start_time,
            end_time,
            vote_event_handle: account::new_event_handle<VoteEvent>(account),
        });
    }

    public entry fun cast_vote(account: &signer, voter_address: address, party: vector<u8>) acquires VotingSystem {
        let voting_system = borrow_global_mut<VotingSystem>(@voting);
        
        // Check voting period
        let current_time = timestamp::now_seconds();
        assert!(current_time >= voting_system.start_time, E_VOTING_NOT_STARTED);
        assert!(current_time <= voting_system.end_time, E_VOTING_ENDED);
        
        // Ensure the account signer is authorized
        let account_addr = signer::address_of(account);
        assert!(account::exists_at(account_addr), E_NOT_AUTHORIZED);

        // Check if the voter has already voted
        assert!(!vector::contains(&voting_system.voters, &voter_address), E_ALREADY_VOTED);
        
        // Record vote
        let vote = Vote {
            voter: voter_address,
            party,
            timestamp: current_time,
        };
        
        vector::push_back(&mut voting_system.votes, vote);
        vector::push_back(&mut voting_system.voters, voter_address);
        
        // Emit vote event
        event::emit_event(&mut voting_system.vote_event_handle, VoteEvent {
            voter: voter_address,
            party,
            timestamp: current_time,
        });
    }

    #[view]
    public fun get_voting_period(): (u64, u64) acquires VotingSystem {
        let voting_system = borrow_global<VotingSystem>(@voting);
        (voting_system.start_time, voting_system.end_time)
    }

    #[view]
    public fun get_vote_count(party: vector<u8>): u64 acquires VotingSystem {
        // Borrow the global VotingSystem resource
        let voting_system = borrow_global<VotingSystem>(@voting);

        // Initialize a counter for votes matching the party
        let count = 0u64;

        // Iterate over the votes vector
        let votes = &voting_system.votes;
        let len = vector::length(votes);
        let i = 0;

        while (i < len) {
            // Borrow the vote at index `i`
            let vote = vector::borrow(votes, i);

            // Compare the vote's party with the input party
            if (vote.party == party) {
                count = count + 1;
            };

            // Increment the index
            i = i + 1;
        };

        // Return the count of votes for the party
        count
    }

    #[view]
    public fun has_voted(addr: address): bool acquires VotingSystem {
        let voting_system = borrow_global<VotingSystem>(@voting);
        vector::contains(&voting_system.voters, &addr)
    }

    // New function to get the address and its voted party
    #[view]
    public fun get_votes(): vector<(address, vector<u8>)> acquires VotingSystem {
        let voting_system = borrow_global<VotingSystem>(@voting);
        
        // Create a new vector to store the results
        let mut result = vector::empty();

        // Iterate over the votes vector
        let votes = &voting_system.votes;
        let len = vector::length(votes);
        let i = 0;

        while (i < len) {
            // Borrow the vote at index `i`
            let vote = vector::borrow(votes, i);

            // Push the tuple of address and party to the result vector
            vector::push_back(&mut result, (vote.voter, vote.party));

            // Increment the index
            i = i + 1;
        };

        // Return the result vector
        result
    }
}
d