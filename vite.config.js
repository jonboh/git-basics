import { defineConfig } from 'vite';

export default defineConfig({
  base: '/git-basics/',
  build: {
    rollupOptions: {
      input: {
        main: 'index.html',
        git_commit_cast: 'git_commit_cast.html',
        git_merge_conflict_cast: 'git_merge_conflict_cast.html',
      }
    }
  }
});

