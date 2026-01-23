# Simple Contracts Collection

20 production-ready Clarity smart contracts with **zero STX transfers** to avoid deployment errors.

## Why Simple Contracts?

These contracts focus on:
- Pure data storage and retrieval
- No complex `as-contract` patterns
- No `stx-transfer?` operations
- Guaranteed deployment success

## Contract List

### Social & Communication
1. **message-board.clar** - On-chain messaging
2. **profile-registry.clar** - User profiles
3. **follower-system.clar** - Social following
4. **status-update.clar** - Status updates
5. **guestbook.clar** - Public guestbook

### Productivity
6. **todo-list.clar** - Task management
7. **note-storage.clar** - Personal notes
8. **bookmark-manager.clar** - URL bookmarks
9. **event-log.clar** - Event logging

### Voting & Governance
10. **voting-poll.clar** - Simple polls

### Utilities
11. **counter-registry.clar** - Custom counters
12. **tag-registry.clar** - Tagging system
13. **link-shortener.clar** - URL shortening
14. **config-store.clar** - Config storage
15. **checkin-tracker.clar** - Daily check-ins

### Access Control
16. **whitelist.clar** - Address whitelist
17. **blacklist.clar** - Address blacklist

### Community
18. **announcement-board.clar** - Announcements
19. **leaderboard.clar** - Score tracking
20. **rating-system.clar** - User ratings

## Usage Example

```clarity
;; Deploy message-board
clarinet deploy message-board

;; Post a message
(contract-call? .message-board post-message u"Hello Stacks!")

;; Read message
(contract-call? .message-board get-message u1)
```

## Testing

All contracts pass `clarinet check` validation.
