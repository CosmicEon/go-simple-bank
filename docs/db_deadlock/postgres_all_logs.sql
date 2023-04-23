SELECT a.datname,
        a.application_name,
         l.relation::regclass,
         l.transactionid,
         l.mode,
         l.locktype,
         l.GRANTED,
         a.usename,
         a.query,
        --  a.query_start,
        --  age(now(), a.query_start) AS "age",
         a.pid
FROM pg_stat_activity a
JOIN pg_locks l ON l.pid = a.pid
WHERE a.application_name = 'psql' -- added filtration
-- ORDER BY a.query_start;
ORDER BY a.pid;