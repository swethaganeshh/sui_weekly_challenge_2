module 0x0::todo {
    use std::vector;
    use std::signer;

    struct Task has copy, drop, store {
        id: u64,
        title: vector<u8>,
        description: vector<u8>,
        completed: bool,
    }

    struct TodoList has key {
        owner: address,
        tasks: vector<Task>,
        next_id: u64,
    }

    public fun create_list(account: &signer) acquires TodoList {
        let addr = signer::address_of(account);
        assert!(!exists<TodoList>(addr), 1);
        move_to(account, TodoList {
            owner: addr,
            tasks: vector::empty<Task>(),
            next_id: 1u64,
        });
    }

    public fun add_task(account: &signer, title: vector<u8>, description: vector<u8>) acquires TodoList {
        let addr = signer::address_of(account);
        assert!(exists<TodoList>(addr), 2);
        let list_ref = borrow_global_mut<TodoList>(addr);
        let id = list_ref.next_id;
        list_ref.next_id = id + 1u64;
        let task = Task { id, title, description, completed: false };
        vector::push_back(&mut list_ref.tasks, task);
    }

    public fun mark_complete(account: &signer, task_id: u64, completed: bool) acquires TodoList {
        let addr = signer::address_of(account);
        assert!(exists<TodoList>(addr), 3);
        let list_ref = borrow_global_mut<TodoList>(addr);
        let len = vector::length(&list_ref.tasks);
        let mut i = 0;
        while (i < len) {
            let ref_task = vector::borrow_mut(&mut list_ref.tasks, i);
            if (ref_task.id == task_id) {
                ref_task.completed = completed;
                return;
            }
            i = i + 1;
        }
        assert!(false, 4);
    }

    public fun delete_task(account: &signer, task_id: u64) acquires TodoList {
        let addr = signer::address_of(account);
        assert!(exists<TodoList>(addr), 5);
        let list_ref = borrow_global_mut<TodoList>(addr);
        let len = vector::length(&list_ref.tasks);
        let mut i = 0;
        while (i < len) {
            let ref_task = vector::borrow(&list_ref.tasks, i);
            if (ref_task.id == task_id) {
                let last_idx = (vector::length(&list_ref.tasks) - 1);
                if (i != last_idx) {
                    let last_task = *vector::borrow(&list_ref.tasks, last_idx);
                    *vector::borrow_mut(&mut list_ref.tasks, i) = last_task;
                }
                vector::pop_back(&mut list_ref.tasks);
                return;
            }
            i = i + 1;
        }
        assert!(false, 6);
    }

    public fun get_tasks(account: &signer): vector<Task> acquires TodoList {
        let addr = signer::address_of(account);
        assert!(exists<TodoList>(addr), 7);
        let list_ref = borrow_global<TodoList>(addr);
        vector::clone(&list_ref.tasks)
    }
}
