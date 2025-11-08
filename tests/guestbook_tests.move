test module 0x0::guestbook_tests {
    use 0x0::guestbook;
    use std::vector;
    use std::signer;

    #[test]
    public fun test_guestbook_post_and_read() {
        let publisher = @0x0;
        guestbook::init_guestbook(&signer::borrow_address(&publisher));
        let bob = @0x2;
        let name = vector::utf8(\"Bob\");
        let content = vector::utf8(\"Hello from Bob\");
        guestbook::post_message(&signer::borrow_address(&bob), name, content, 123456u64);
        let msgs = guestbook::read_messages();
        assert!(vector::length(&msgs) == 1, 200);
        let m = *vector::borrow(&msgs, 0);
        assert!(m.timestamp == 123456u64, 201);
    }
}
