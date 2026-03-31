# StacksRank - Real-Time Talent Leaderboard

> 🚀 **This is THE project to build for your top 10 breakthrough!**

## Why This Project Will Get You to Top 10

1. ✅ **Meta & Useful** - You'll use it while building it
2. ✅ **Community Value** - Everyone wants to track rankings
3. ✅ **Showcases Skills** - API integration, smart contracts, frontend
4. ✅ **Viral Potential** - Developers will share their rankings
5. ✅ **7-Day Build** - Fast iteration to production

## Project Architecture

```
stacksrank/
├── contracts/              # Clarity smart contracts
│   ├── ranking-tracker.clar
│   ├── achievement-badges.clar
│   └── reputation-system.clar
├── frontend/               # Next.js app
│   ├── app/
│   │   ├── page.tsx       # Leaderboard
│   │   ├── profile/[id]/  # User profile
│   │   └── api/           # API routes
│   ├── components/
│   └── lib/
├── backend/                # Data aggregation
│   ├── github-scraper.ts
│   ├── stacks-indexer.ts
│   └── rank-calculator.ts
└── README.md
```

## Core Features

### Phase 1: MVP (Days 1-3)
- [ ] Aggregate GitHub activity from Stacks repos
- [ ] Fetch on-chain contract deployments
- [ ] Basic ranking algorithm
- [ ] Simple leaderboard UI
- [ ] User search functionality

### Phase 2: Enhanced (Days 4-5)
- [ ] Deploy smart contract to track verified addresses
- [ ] Achievement badge system (SIP-009 NFTs)
- [ ] Historical ranking chart
- [ ] Profile pages with detailed stats
- [ ] Social sharing cards

### Phase 3: Polish (Days 6-7)
- [ ] Real-time updates via WebSocket
- [ ] Advanced filters (by project type, technology)
- [ ] Reputation points system
- [ ] Tournament/challenge mode
- [ ] Public API for others to use

## Ranking Algorithm (Initial)

```typescript
interface RankingScore {
  githubScore: number;      // 0-100
  contractScore: number;    // 0-100
  ecosystemScore: number;   // 0-100
  impactScore: number;      // 0-100
}

function calculateRank(user: User): number {
  const weights = {
    mainnetContracts: 10,
    ecosystemContributions: 15,
    brandedProjects: 20,
    technicalDepth: 5,
    communityEngagement: 8
  };
  
  return (
    user.mainnetContracts * weights.mainnetContracts +
    user.ecosystemPRs * weights.ecosystemContributions +
    user.brandedProjects * weights.brandedProjects +
    user.technicalDepth * weights.technicalDepth +
    user.communityEngagement * weights.communityEngagement
  );
}
```

## Data Sources

1. **GitHub API**
   - User repos
   - Contributions to ecosystem projects
   - Stars, forks, issues

2. **Stacks Blockchain API**
   - Contract deployments (mainnet vs testnet)
   - Transaction count
   - Contract interactions

3. **Manual Verification** (Future)
   - Verified developer badge
   - Project audits
   - Community vouches

## Tech Stack

```json
{
  "frontend": {
    "framework": "Next.js 14 (App Router)",
    "styling": "Tailwind CSS",
    "charts": "Recharts",
    "stacks": "@stacks/connect, @stacks/transactions"
  },
  "backend": {
    "api": "Next.js API Routes",
    "database": "Supabase (PostgreSQL)",
    "caching": "Redis (Upstash)",
    "cron": "Vercel Cron Jobs"
  },
  "contracts": {
    "language": "Clarity 4",
    "testing": "Clarinet",
    "deployment": "Hiro Platform"
  }
}
```

## Smart Contract: Ranking Tracker

```clarity
;; stacksrank-tracker.clar
;; Track verified builder addresses and achievements

(define-map verified-builders 
  principal 
  {
    github-username: (string-ascii 50),
    total-score: uint,
    verified-at: uint,
    achievement-count: uint
  }
)

(define-map builder-achievements
  { builder: principal, achievement-id: uint }
  {
    name: (string-ascii 100),
    awarded-at: uint,
    metadata-uri: (optional (string-ascii 256))
  }
)

;; Register as verified builder
(define-public (register-builder (github (string-ascii 50)))
  (begin
    (map-set verified-builders tx-sender {
      github-username: github,
      total-score: u0,
      verified-at: block-height,
      achievement-count: u0
    })
    (ok true)
  )
)

;; Award achievement (only contract owner)
(define-public (award-achievement 
  (builder principal)
  (achievement-id uint)
  (name (string-ascii 100))
  (metadata (optional (string-ascii 256)))
)
  ;; Add admin check here
  (begin
    (map-set builder-achievements 
      { builder: builder, achievement-id: achievement-id }
      {
        name: name,
        awarded-at: block-height,
        metadata-uri: metadata
      }
    )
    (ok true)
  )
)
```

## Frontend Components

### 1. Leaderboard Component
```typescript
'use client';

import { useState, useEffect } from 'react';

interface Builder {
  rank: number;
  username: string;
  score: number;
  mainnetContracts: number;
  ecosystemPRs: number;
  projects: string[];
  change: number; // rank change from last week
}

export function Leaderboard() {
  const [builders, setBuilders] = useState<Builder[]>([]);
  
  useEffect(() => {
    fetch('/api/rankings')
      .then(res => res.json())
      .then(data => setBuilders(data));
  }, []);
  
  return (
    <div className="rankings-table">
      {builders.map((builder) => (
        <div key={builder.username} className="rank-row">
          <span className="rank">#{builder.rank}</span>
          <span className="username">{builder.username}</span>
          <span className="score">{builder.score}</span>
          <span className="change">
            {builder.change > 0 ? '↑' : '↓'} {Math.abs(builder.change)}
          </span>
        </div>
      ))}
    </div>
  );
}
```

## API Routes

### GET /api/rankings
Returns current leaderboard

### GET /api/profile/[username]
Returns detailed user profile

### POST /api/verify
Links GitHub username to Stacks address

### GET /api/stats
Returns ecosystem-wide statistics

## Launch Strategy

### Pre-Launch (Day 6)
1. Tweet teaser: "Tracking the top Stacks builders... 👀"
2. Share screenshot in Stacks Discord
3. Get 5 beta testers from community

### Launch Day (Day 7)
1. Deploy to Vercel
2. Tweet launch announcement with screenshot
3. Post in r/stacks, Stacks Discord
4. DM top 10 current rankers - "You're on StacksRank! 🎉"
5. Submit to Stacks newsletter

### Post-Launch (Day 8+)
1. Daily tweets with "Builder of the Day"
2. Weekly "Biggest Mover" spotlight
3. Monthly challenges/tournaments
4. API access for others to build on

## Why This Will Work

1. **Network Effect**: Top builders will share their rank
2. **Gamification**: People love leaderboards
3. **Utility**: Solves real need (tracking talent)
4. **Visibility**: Gets you in front of entire Stacks community
5. **Portfolio**: Perfect showcase piece

## Immediate Next Steps

1. **Today**: Set up Next.js project
2. **Tomorrow**: Build basic GitHub scraper
3. **Day 3**: Create leaderboard UI
4. **Day 4**: Deploy smart contract
5. **Day 5**: Add profile pages
6. **Day 6**: Polish & test
7. **Day 7**: LAUNCH! 🚀

## Success Metrics

- [ ] 100+ unique visitors in week 1
- [ ] 10+ builders verify their profile
- [ ] 5+ shares on Twitter
- [ ] Featured in Stacks Discord
- [ ] Your rank goes UP while building it! 📈

---

**Start building TODAY. This is your ticket to top 10!**
