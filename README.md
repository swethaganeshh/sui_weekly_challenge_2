# Sui Weekly Challenges

A Sui Move project implementing two blockchain modules: a per-user TODO list and a shared guestbook.

## Project Overview

### Todo Module (`sources/todo.move`)

A personal TODO list using owned objects. Each user has their own TodoList with per-list unique task IDs.

**Features:**
- Create personal TODO lists
- Add tasks with title and description
- Mark tasks as complete or incomplete
- Delete tasks from the list
- Retrieve all tasks for a user

**Structures:**
- `Task`: Individual task with id, title, description, and completion status
- `TodoList`: User-owned list containing tasks and next ID counter

### Guestbook Module (`sources/guestbook.move`)

A shared guestbook using shared objects. Messages are append-only and accessible to all users.

**Features:**
- Initialize shared guestbook
- Post messages with name and content
- Read all messages from the guestbook
- Automatic timestamp recording and poster tracking

**Structures:**
- `Message`: Contains poster address, name, content, and timestamp
- `Guestbook`: Shared object storing all messages at package address

## Project Structure

```
sui_weekly_challenges/
├── Move.toml                    # Package configuration
├── sources/
│   ├── todo.move               # TODO list module
│   └── guestbook.move          # Guestbook module
├── tests/
│   ├── todo_tests.move         # TODO module tests
│   └── guestbook_tests.move    # Guestbook module tests
└── README.md                   # Project documentation
```

## Building and Testing

### Prerequisites

- Sui CLI installed and configured
- Rust toolchain (required by Sui)

### Build the Project

```bash
sui move build
```

### Run Unit Tests

```bash
sui move test
```

### Expected Test Output

Both test modules should pass successfully:
- `todo_tests::test_create_add_complete_delete` - Validates full TODO lifecycle
- `guestbook_tests::test_guestbook_post_and_read` - Validates guestbook messaging

## Publishing to Testnet

After building and testing successfully:

```bash
sui client publish --gas-budget 100000000
```

This will output a package ID that can be used to interact with your modules on the Sui testnet.

## Module Functions

### Todo Module

- `create_list(account: &signer)` - Initialize a new TODO list for the caller
- `add_task(account: &signer, title: vector<u8>, description: vector<u8>)` - Add a new task
- `mark_complete(account: &signer, task_id: u64, completed: bool)` - Update task status
- `delete_task(account: &signer, task_id: u64)` - Remove a task
- `get_tasks(account: &signer): vector<Task>` - Retrieve all tasks

### Guestbook Module

- `init_guestbook(account: &signer)` - Initialize the shared guestbook
- `post_message(caller: &signer, name: vector<u8>, content: vector<u8>, timestamp: u64)` - Post a message
- `read_messages(): vector<Message>` - Retrieve all messages

## Error Codes

### Todo Module
- `1` - TodoList already exists
- `2` - TodoList does not exist
- `3` - TodoList not found for mark_complete
- `4` - Task ID not found during mark_complete
- `5` - TodoList not found for delete_task
- `6` - Task ID not found during delete_task
- `7` - TodoList not found for get_tasks

### Guestbook Module
- `1` - Guestbook already exists
- `2` - Guestbook does not exist during post_message
- `3` - Guestbook does not exist during read_messages

## Advanced Improvements

Potential enhancements for the future:
- Replace `vector<u8>` with `string::String` for better string handling
- Implement lazy guestbook creation with guarded initialization
- Add `get_tasks_by_status()` helper function
- Add `get_task_by_id()` helper function
- Implement comprehensive error handling and validation
- Add edge-case tests for error scenarios
