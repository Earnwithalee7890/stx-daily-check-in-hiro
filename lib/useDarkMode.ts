'use client';

import { useState, useEffect } from 'react';

/**
 * Custom hook to manage dark mode state and persistence.
 * Synchronizes with system preferences and localStorage.
 */
export function useDarkMode() {
    const [isDark, setIsDark] = useState<boolean>(true); // Default to dark for this premium app

    useEffect(() => {
        // Load preference from localStorage
        const savedTheme = localStorage.getItem('theme');
        if (savedTheme) {
            const dark = savedTheme === 'dark';
            setIsDark(dark);
            document.documentElement.classList.toggle('light-mode', !dark);
        } else {
            // Check system preference
            const systemDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
            setIsDark(systemDark);
            document.documentElement.classList.toggle('light-mode', !systemDark);
        }
    }, []);

    const toggleDarkMode = () => {
        const newDark = !isDark;
        setIsDark(newDark);
        localStorage.setItem('theme', newDark ? 'dark' : 'light');
        document.documentElement.classList.toggle('light-mode', !newDark);
    };

    return { isDark, toggleDarkMode };
}
