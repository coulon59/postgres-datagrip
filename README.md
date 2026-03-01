# SQL Optimization Training - Chinook Database Sandbox

A comprehensive training environment for learning and practicing SQL optimization techniques using the Chinook database on PostgreSQL.

## 📚 Project Overview

This project provides a sandbox environment for developers, data analysts, and database administrators to learn SQL optimization strategies through hands-on practice with a realistic dataset. The Chinook database represents a digital media store, including tables for artists, albums, tracks, invoices, customers, and employees.

## 🎯 Learning Objectives

- **Query Performance Analysis**: Learn to identify slow queries and understand execution plans
- **Index Optimization**: Master the art of creating and utilizing indexes effectively
- **Join Strategies**: Understand different join types and when to use them
- **Query Refactoring**: Practice rewriting queries for better performance
- **Database Design Principles**: Learn how schema design impacts performance
- **Advanced PostgreSQL Features**: Explore window functions, CTEs, and optimization hints

## 🗄️ Database Schema

The Chinook database consists of the following main tables:

- **`artists`** - Artist information
- **`albums`** - Album details linked to artists
- **`tracks`** - Individual tracks with genre and media type information
- **`genres`** - Music genres
- **`media_types`** - Audio media formats
- **`playlists`** - User-created playlists
- **`playlist_track`** - Many-to-many relationship between playlists and tracks
- **`customers`** - Customer information and support details
- **`employees`** - Employee information and reporting structure
- **`invoices`** - Customer invoices
- **`invoice_items`** - Individual line items for invoices

### Database Diagram

![Chinook Database Schema](show_diagram.png)

## 🚀 Getting Started

### Prerequisites

- PostgreSQL 12+ installed and running
- JetBrains DataGrip (recommended) or any PostgreSQL client
- Basic understanding of SQL fundamentals

### Setup Instructions

1. **Clone this repository**:
   ```bash
   git clone <repository-url>
   cd postgres-datagrip
   ```

2. **Create the database**:
   ```sql
   CREATE DATABASE chinook;
   ```

3. **Load the schema**:
   ```bash
   psql -d chinook -f chinook.ddl
   ```

4. **Verify the setup**:
   ```sql
   SELECT COUNT(*) FROM artists;
   SELECT COUNT(*) FROM albums;
   SELECT COUNT(*) FROM tracks;
   ```

## 📋 Training Exercises

### Module 1: Basic Query Analysis

**Exercise 1.1**: Find the top 10 customers by total spending
```sql
-- Write a query to find customers who spent the most
-- Analyze the execution plan
EXPLAIN ANALYZE
SELECT c.customer_id, c.first_name, c.last_name, SUM(i.total) as total_spent
FROM customers c
JOIN invoices i ON c.customer_id = i.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 10;
```

**Exercise 1.2**: Identify missing indexes
```sql
-- Run this query and check for sequential scans
SELECT t.name, a.title, ar.name as artist_name
FROM tracks t
JOIN albums a ON t.album_id = a.album_id
JOIN artists ar ON a.artist_id = ar.artist_id
WHERE t.name LIKE '%Love%';
```

### Module 2: Index Optimization

**Exercise 2.1**: Create appropriate indexes
```sql
-- Create indexes for frequently queried columns
CREATE INDEX idx_tracks_name ON tracks(name);
CREATE INDEX idx_invoices_customer_id ON invoices(customer_id);
CREATE INDEX idx_invoice_items_invoice_id ON invoice_items(invoice_id);
```

**Exercise 2.2**: Analyze index usage
```sql
-- Check which indexes are being used
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;
```

### Module 3: Advanced Optimization Techniques

**Exercise 3.1**: Window functions for performance
```sql
-- Use window functions instead of self-joins
SELECT 
    customer_id,
    first_name,
    last_name,
    total,
    ROW_NUMBER() OVER (ORDER BY total DESC) as ranking,
    PERCENT_RANK() OVER (ORDER BY total DESC) as percentile
FROM (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(i.total) as total
    FROM customers c
    JOIN invoices i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
) customer_totals;
```

**Exercise 3.2**: CTE optimization
```sql
-- Compare CTE vs subquery performance
WITH customer_spending AS (
    SELECT 
        customer_id,
        SUM(total) as total_spent
    FROM invoices
    GROUP BY customer_id
)
SELECT 
    c.first_name,
    c.last_name,
    cs.total_spent,
    CASE 
        WHEN cs.total_spent > 100 THEN 'Premium'
        WHEN cs.total_spent > 50 THEN 'Standard'
        ELSE 'Basic'
    END as customer_tier
FROM customers c
JOIN customer_spending cs ON c.customer_id = cs.customer_id;
```

## 🔍 Performance Monitoring Tools

### PostgreSQL Built-in Tools

1. **EXPLAIN ANALYZE**: Get detailed execution plans
2. **pg_stat_statements**: Track query performance over time
3. **pg_stat_user_tables**: Monitor table access patterns
4. **pg_stat_user_indexes**: Analyze index usage

### DataGrip Features

1. **Query Console**: Execute and analyze queries
2. **Execution Plan Viewer**: Visual representation of query plans
3. **Database Explorer**: Navigate schema efficiently
4. **SQL Formatter**: Maintain clean, readable code

## 📊 Common Optimization Patterns

### 1. Proper Indexing Strategy

```sql
-- Good: Composite index for multi-column queries
CREATE INDEX idx_invoices_customer_date ON invoices(customer_id, invoice_date);

-- Bad: Index on low-cardinality columns
CREATE INDEX idx_tracks_genre ON tracks(genre_id); -- Usually not beneficial
```

### 2. Avoid SELECT *

```sql
-- Bad: Returns unnecessary data
SELECT * FROM customers WHERE country = 'USA';

-- Good: Specify only needed columns
SELECT customer_id, first_name, last_name, email 
FROM customers WHERE country = 'USA';
```

### 3. Use EXISTS instead of IN for subqueries

```sql
-- Bad: Can be slow with large datasets
SELECT c.first_name, c.last_name
FROM customers c
WHERE c.customer_id IN (SELECT customer_id FROM invoices WHERE total > 10);

-- Good: More efficient
SELECT c.first_name, c.last_name
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM invoices i 
    WHERE i.customer_id = c.customer_id AND i.total > 10
);
```

## 🧪 Benchmarking Queries

Use these queries to test optimization techniques:

```sql
-- Test query 1: Complex aggregation
SELECT 
    g.name as genre,
    COUNT(t.track_id) as track_count,
    AVG(t.milliseconds) as avg_duration,
    SUM(ii.quantity) as total_sold
FROM genres g
JOIN tracks t ON g.genre_id = t.genre_id
JOIN invoice_items ii ON t.track_id = ii.track_id
GROUP BY g.genre_id, g.name
HAVING COUNT(t.track_id) > 100
ORDER BY total_sold DESC;

-- Test query 2: Multi-table joins
SELECT 
    c.first_name,
    c.last_name,
    COUNT(DISTINCT a.album_id) as albums_purchased,
    SUM(ii.quantity) as tracks_purchased,
    SUM(ii.unit_price * ii.quantity) as total_spent
FROM customers c
JOIN invoices i ON c.customer_id = i.customer_id
JOIN invoice_items ii ON i.invoice_id = ii.invoice_id
JOIN tracks t ON ii.track_id = t.track_id
JOIN albums a ON t.album_id = a.album_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 20;
```

## 📈 Performance Metrics

Track these key metrics to measure optimization success:

- **Query Execution Time**: Total time to complete query
- **Sequential Scans**: Number of full table scans (minimize these)
- **Index Usage**: Percentage of queries using indexes
- **Memory Usage**: Amount of memory allocated for sorting/hashing
- **Disk I/O**: Number of disk reads/writes

## 🛠️ Troubleshooting Common Issues

### Slow Queries

1. **Check execution plan**: Use `EXPLAIN ANALYZE`
2. **Missing indexes**: Look for sequential scans on large tables
3. **Outdated statistics**: Run `ANALYZE` on affected tables
4. **Lock contention**: Check for blocking queries

### High Memory Usage

1. **Reduce work_mem**: Lower memory allocation for complex operations
2. **Break large queries**: Split into smaller, manageable chunks
3. **Use LIMIT**: Restrict result sets when possible

### Index Bloat

1. **Monitor index size**: Check for oversized indexes
2. **Rebuild indexes**: Use `REINDEX INDEX` command
3. **Remove unused indexes**: Drop indexes that aren't being used

## 📚 Additional Resources

- [PostgreSQL Performance Tuning Guide](https://www.postgresql.org/docs/current/performance-tips.html)
- [DataGrip Documentation](https://www.jetbrains.com/datagrip/)
- [SQL Optimization Best Practices](https://wiki.postgresql.org/wiki/Performance_Optimization)

## 🤝 Contributing

Feel free to contribute additional exercises, optimization examples, or improvements to the training materials:

1. Fork the repository
2. Create a feature branch
3. Add your improvements
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Chinook database for providing a realistic dataset
- PostgreSQL community for excellent documentation
- JetBrains for DataGrip IDE support
