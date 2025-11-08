test module 0x0::todo_tests {
    use 0x0::todo;
    use std::vector;
    use std::signer;

    #[test]
    public fun test_create_add_complete_delete() {
        let alice = @0x1;
        // create list
        todo::create_list(&signer::borrow_address(&alice));
        let title = vector::utf8(\"Buy milk\");
        let desc = vector::utf8(\"2 liters\");
        todo::add_task(&signer::borrow_address(&alice), title, desc);
        let tasks = todo::get_tasks(&signer::borrow_address(&alice));
        assert!(vector::length(&tasks) == 1, 100);
        let t = *vector::borrow(&tasks, 0);
        todo::mark_complete(&signer::borrow_address(&alice), t.id, true);
        let tasks2 = todo::get_tasks(&signer::borrow_address(&alice));
        let t2 = *vector::borrow(&tasks2, 0);
        assert!(t2.completed == true, 101);
        todo::delete_task(&signer::borrow_address(&alice), t2.id);
        let tasks3 = todo::get_tasks(&signer::borrow_address(&alice));
        assert!(vector::length(&tasks3) == 0, 102);
    }
}
