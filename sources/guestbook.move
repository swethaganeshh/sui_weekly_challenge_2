module 0x0::guestbook {
    use std::vector;
    use std::signer;

    struct Message has copy, drop, store {
        poster: address,
        name: vector<u8>,
        content: vector<u8>,
        timestamp: u64,
    }

    struct Guestbook has key {
        messages: vector<Message>,
    }

    public fun init_guestbook(account: &signer) acquires Guestbook {
        let addr = signer::address_of(account);
        assert!(!exists<Guestbook>(addr), 1);
        move_to(account, Guestbook { messages: vector::empty<Message>() });
    }

    public fun post_message(caller: &signer, name: vector<u8>, content: vector<u8>, timestamp: u64) acquires Guestbook {
        let pkg_addr = @0x0;
        assert!(exists<Guestbook>(pkg_addr), 2);
        let gb_ref = borrow_global_mut<Guestbook>(pkg_addr);
        let msg = Message { poster: signer::address_of(caller), name, content, timestamp };
        vector::push_back(&mut gb_ref.messages, msg);
    }

    public fun read_messages(): vector<Message> acquires Guestbook {
        let pkg_addr = @0x0;
        assert!(exists<Guestbook>(pkg_addr), 3);
        let gb_ref = borrow_global<Guestbook>(pkg_addr);
        vector::clone(&gb_ref.messages)
    }
}
