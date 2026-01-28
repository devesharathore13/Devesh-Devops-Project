# Docker Optimization Examples

## Key Improvements
1. Use slim/alpine base images
2. Combine RUN commands to reduce layers
3. Order layers by change frequency
4. Use .dockerignore
5. Run as non-root user
6. Clean up package manager caches

## Size Comparison
- Before: ~600MB
- After: ~150MB
