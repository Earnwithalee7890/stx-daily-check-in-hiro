'use client';

import { useState, useEffect } from 'react';

interface Builder {
    rank: number;
    username: string;
    githubHandle: string;
    score: number;
    mainnetContracts: number;
    ecosystemPRs: number;
    projects: string[];
    change: number;
    avatar?: string;
}

export default function Leaderboard() {
    const [builders, setBuilders] = useState<Builder[]>([]);
    const [loading, setLoading] = useState(true);
    const [filter, setFilter] = useState<'all' | 'mainnet' | 'ecosystem'>('all');

    useEffect(() => {
        fetchBuilders();
    }, []);

    const fetchBuilders = async () => {
        try {
            // TODO: Replace with actual API call
            const mockData: Builder[] = [
                {
                    rank: 1,
                    username: 'theenlightened',
                    githubHandle: 'phessophissy',
                    score: 950,
                    mainnetContracts: 15,
                    ecosystemPRs: 25,
                    projects: ['ChainChat', 'SpinningB', 'achievementPOAP'],
                    change: 0,
                    avatar: `https://github.com/phessophissy.png`
                },
                {
                    rank: 2,
                    username: 'investorphem',
                    githubHandle: 'investorphem',
                    score: 890,
                    mainnetContracts: 12,
                    ecosystemPRs: 18,
                    projects: ['StackPay', 'STX-Portfolio-Tracker'],
                    change: 23,
                    avatar: `https://github.com/investorphem.png`
                },
                // Add your profile!
                {
                    rank: 11,
                    username: 'aleekhoso',
                    githubHandle: 'Earnwithalee7890',
                    score: 550,
                    mainnetContracts: 200,
                    ecosystemPRs: 0,
                    projects: ['stx-daily-check-in', 'StackCred', 'PostUP'],
                    change: -1,
                    avatar: `https://github.com/Earnwithalee7890.png`
                }
            ];

            setBuilders(mockData);
            setLoading(false);
        } catch (error) {
            console.error('Error fetching builders:', error);
            setLoading(false);
        }
    };

    const getRankColor = (rank: number) => {
        if (rank === 1) return 'text-yellow-400';
        if (rank === 2) return 'text-gray-300';
        if (rank === 3) return 'text-orange-400';
        if (rank <= 10) return 'text-blue-400';
        return 'text-gray-500';
    };

    const getChangeIndicator = (change: number) => {
        if (change === 0) return <span className="text-gray-500">—</span>;
        if (change > 0) return <span className="text-green-500">↑ {change}</span>;
        return <span className="text-red-500">↓ {Math.abs(change)}</span>;
    };

    if (loading) {
        return (
            <div className="flex items-center justify-center min-h-[400px]">
                <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-blue-500"></div>
            </div>
        );
    }

    return (
        <div className="w-full max-w-6xl mx-auto p-6">
            {/* Header */}
            <div className="mb-8">
                <h1 className="text-4xl font-bold mb-2 bg-gradient-to-r from-blue-500 to-purple-600 bg-clip-text text-transparent">
                    StacksRank Leaderboard
                </h1>
                <p className="text-gray-400">
                    Tracking the top builders in the Stacks ecosystem
                </p>
            </div>

            {/* Filters */}
            <div className="flex gap-4 mb-6">
                <button
                    onClick={() => setFilter('all')}
                    className={`px-4 py-2 rounded-lg transition-all ${filter === 'all'
                            ? 'bg-blue-600 text-white'
                            : 'bg-gray-800 text-gray-400 hover:bg-gray-700'
                        }`}
                >
                    All Builders
                </button>
                <button
                    onClick={() => setFilter('mainnet')}
                    className={`px-4 py-2 rounded-lg transition-all ${filter === 'mainnet'
                            ? 'bg-blue-600 text-white'
                            : 'bg-gray-800 text-gray-400 hover:bg-gray-700'
                        }`}
                >
                    Most Mainnet Deploys
                </button>
                <button
                    onClick={() => setFilter('ecosystem')}
                    className={`px-4 py-2 rounded-lg transition-all ${filter === 'ecosystem'
                            ? 'bg-blue-600 text-white'
                            : 'bg-gray-800 text-gray-400 hover:bg-gray-700'
                        }`}
                >
                    Top Contributors
                </button>
            </div>

            {/* Leaderboard Table */}
            <div className="bg-gray-900 rounded-xl overflow-hidden border border-gray-800">
                <div className="overflow-x-auto">
                    <table className="w-full">
                        <thead className="bg-gray-800">
                            <tr>
                                <th className="px-6 py-4 text-left text-sm font-semibold text-gray-300">
                                    Rank
                                </th>
                                <th className="px-6 py-4 text-left text-sm font-semibold text-gray-300">
                                    Builder
                                </th>
                                <th className="px-6 py-4 text-center text-sm font-semibold text-gray-300">
                                    Score
                                </th>
                                <th className="px-6 py-4 text-center text-sm font-semibold text-gray-300">
                                    Mainnet
                                </th>
                                <th className="px-6 py-4 text-center text-sm font-semibold text-gray-300">
                                    PRs
                                </th>
                                <th className="px-6 py-4 text-left text-sm font-semibold text-gray-300">
                                    Projects
                                </th>
                                <th className="px-6 py-4 text-center text-sm font-semibold text-gray-300">
                                    Change
                                </th>
                            </tr>
                        </thead>
                        <tbody className="divide-y divide-gray-800">
                            {builders.map((builder) => (
                                <tr
                                    key={builder.username}
                                    className="hover:bg-gray-800/50 transition-colors cursor-pointer"
                                >
                                    {/* Rank */}
                                    <td className="px-6 py-4">
                                        <span
                                            className={`text-2xl font-bold ${getRankColor(
                                                builder.rank
                                            )}`}
                                        >
                                            #{builder.rank}
                                        </span>
                                    </td>

                                    {/* Builder Info */}
                                    <td className="px-6 py-4">
                                        <div className="flex items-center gap-3">
                                            {builder.avatar && (
                                                <img
                                                    src={builder.avatar}
                                                    alt={builder.username}
                                                    className="w-10 h-10 rounded-full"
                                                />
                                            )}
                                            <div>
                                                <div className="font-semibold text-white">
                                                    {builder.username}
                                                </div>
                                                <div className="text-sm text-gray-500">
                                                    @{builder.githubHandle}
                                                </div>
                                            </div>
                                        </div>
                                    </td>

                                    {/* Score */}
                                    <td className="px-6 py-4 text-center">
                                        <span className="text-lg font-bold text-purple-400">
                                            {builder.score}
                                        </span>
                                    </td>

                                    {/* Mainnet Contracts */}
                                    <td className="px-6 py-4 text-center">
                                        <span className="inline-flex items-center px-3 py-1 rounded-full text-sm bg-green-900/30 text-green-400">
                                            {builder.mainnetContracts}
                                        </span>
                                    </td>

                                    {/* Ecosystem PRs */}
                                    <td className="px-6 py-4 text-center">
                                        <span className="inline-flex items-center px-3 py-1 rounded-full text-sm bg-blue-900/30 text-blue-400">
                                            {builder.ecosystemPRs}
                                        </span>
                                    </td>

                                    {/* Projects */}
                                    <td className="px-6 py-4">
                                        <div className="flex flex-wrap gap-2">
                                            {builder.projects.slice(0, 2).map((project) => (
                                                <span
                                                    key={project}
                                                    className="px-2 py-1 text-xs rounded bg-gray-800 text-gray-300"
                                                >
                                                    {project}
                                                </span>
                                            ))}
                                            {builder.projects.length > 2 && (
                                                <span className="px-2 py-1 text-xs rounded bg-gray-800 text-gray-500">
                                                    +{builder.projects.length - 2}
                                                </span>
                                            )}
                                        </div>
                                    </td>

                                    {/* Change */}
                                    <td className="px-6 py-4 text-center text-sm font-semibold">
                                        {getChangeIndicator(builder.change)}
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            </div>

            {/* Footer Stats */}
            <div className="mt-8 grid grid-cols-1 md:grid-cols-3 gap-4">
                <div className="bg-gray-900 rounded-lg p-6 border border-gray-800">
                    <div className="text-sm text-gray-500 mb-1">Total Builders</div>
                    <div className="text-3xl font-bold text-white">{builders.length}</div>
                </div>
                <div className="bg-gray-900 rounded-lg p-6 border border-gray-800">
                    <div className="text-sm text-gray-500 mb-1">Mainnet Contracts</div>
                    <div className="text-3xl font-bold text-white">
                        {builders.reduce((acc, b) => acc + b.mainnetContracts, 0)}
                    </div>
                </div>
                <div className="bg-gray-900 rounded-lg p-6 border border-gray-800">
                    <div className="text-sm text-gray-500 mb-1">Ecosystem PRs</div>
                    <div className="text-3xl font-bold text-white">
                        {builders.reduce((acc, b) => acc + b.ecosystemPRs, 0)}
                    </div>
                </div>
            </div>
        </div>
    );
}
