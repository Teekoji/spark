-- A test suite for simple IN predicate subquery
-- It includes correlated cases.

--CONFIG_DIM1 spark.sql.optimizeNullAwareAntiJoin=true
--CONFIG_DIM1 spark.sql.optimizeNullAwareAntiJoin=false
--ONLY_IF spark

create temporary view t1 as select * from values
  ("t1a", 6S, 8, 10L, float(15.0), 20D, 20E2BD, timestamp '2014-04-04 01:00:00.000', date '2014-04-04'),
  ("t1b", 8S, 16, 19L, float(17.0), 25D, 26E2BD, timestamp '2014-05-04 01:01:00.000', date '2014-05-04'),
  ("t1a", 16S, 12, 21L, float(15.0), 20D, 20E2BD, timestamp '2014-06-04 01:02:00.001', date '2014-06-04'),
  ("t1a", 16S, 12, 10L, float(15.0), 20D, 20E2BD, timestamp '2014-07-04 01:01:00.000', date '2014-07-04'),
  ("t1c", 8S, 16, 19L, float(17.0), 25D, 26E2BD, timestamp '2014-05-04 01:02:00.001', date '2014-05-05'),
  ("t1d", null, 16, 22L, float(17.0), 25D, 26E2BD, timestamp '2014-06-04 01:01:00.000', null),
  ("t1d", null, 16, 19L, float(17.0), 25D, 26E2BD, timestamp '2014-07-04 01:02:00.001', null),
  ("t1e", 10S, null, 25L, float(17.0), 25D, 26E2BD, timestamp '2014-08-04 01:01:00.000', date '2014-08-04'),
  ("t1e", 10S, null, 19L, float(17.0), 25D, 26E2BD, timestamp '2014-09-04 01:02:00.001', date '2014-09-04'),
  ("t1d", 10S, null, 12L, float(17.0), 25D, 26E2BD, timestamp '2015-05-04 01:01:00.000', date '2015-05-04'),
  ("t1a", 6S, 8, 10L, float(15.0), 20D, 20E2BD, timestamp '2014-04-04 01:02:00.001', date '2014-04-04'),
  ("t1e", 10S, null, 19L, float(17.0), 25D, 26E2BD, timestamp '2014-05-04 01:01:00.000', date '2014-05-04')
  as t1(t1a, t1b, t1c, t1d, t1e, t1f, t1g, t1h, t1i);

create temporary view t2 as select * from values
  ("t2a", 6S, 12, 14L, float(15), 20D, 20E2BD, timestamp '2014-04-04 01:01:00.000', date '2014-04-04'),
  ("t1b", 10S, 12, 19L, float(17), 25D, 26E2BD, timestamp '2014-05-04 01:01:00.000', date '2014-05-04'),
  ("t1b", 8S, 16, 119L, float(17), 25D, 26E2BD, timestamp '2015-05-04 01:01:00.000', date '2015-05-04'),
  ("t1c", 12S, 16, 219L, float(17), 25D, 26E2BD, timestamp '2016-05-04 01:01:00.000', date '2016-05-04'),
  ("t1b", null, 16, 319L, float(17), 25D, 26E2BD, timestamp '2017-05-04 01:01:00.000', null),
  ("t2e", 8S, null, 419L, float(17), 25D, 26E2BD, timestamp '2014-06-04 01:01:00.000', date '2014-06-04'),
  ("t1f", 19S, null, 519L, float(17), 25D, 26E2BD, timestamp '2014-05-04 01:01:00.000', date '2014-05-04'),
  ("t1b", 10S, 12, 19L, float(17), 25D, 26E2BD, timestamp '2014-06-04 01:01:00.000', date '2014-06-04'),
  ("t1b", 8S, 16, 19L, float(17), 25D, 26E2BD, timestamp '2014-07-04 01:01:00.000', date '2014-07-04'),
  ("t1c", 12S, 16, 19L, float(17), 25D, 26E2BD, timestamp '2014-08-04 01:01:00.000', date '2014-08-05'),
  ("t1e", 8S, null, 19L, float(17), 25D, 26E2BD, timestamp '2014-09-04 01:01:00.000', date '2014-09-04'),
  ("t1f", 19S, null, 19L, float(17), 25D, 26E2BD, timestamp '2014-10-04 01:01:00.000', date '2014-10-04'),
  ("t1b", null, 16, 19L, float(17), 25D, 26E2BD, timestamp '2014-05-04 01:01:00.000', null)
  as t2(t2a, t2b, t2c, t2d, t2e, t2f, t2g, t2h, t2i);

create temporary view t3 as select * from values
  ("t3a", 6S, 12, 110L, float(15), 20D, 20E2BD, timestamp '2014-04-04 01:02:00.000', date '2014-04-04'),
  ("t3a", 6S, 12, 10L, float(15), 20D, 20E2BD, timestamp '2014-05-04 01:02:00.000', date '2014-05-04'),
  ("t1b", 10S, 12, 219L, float(17), 25D, 26E2BD, timestamp '2014-05-04 01:02:00.000', date '2014-05-04'),
  ("t1b", 10S, 12, 19L, float(17), 25D, 26E2BD, timestamp '2014-05-04 01:02:00.000', date '2014-05-04'),
  ("t1b", 8S, 16, 319L, float(17), 25D, 26E2BD, timestamp '2014-06-04 01:02:00.000', date '2014-06-04'),
  ("t1b", 8S, 16, 19L, float(17), 25D, 26E2BD, timestamp '2014-07-04 01:02:00.000', date '2014-07-04'),
  ("t3c", 17S, 16, 519L, float(17), 25D, 26E2BD, timestamp '2014-08-04 01:02:00.000', date '2014-08-04'),
  ("t3c", 17S, 16, 19L, float(17), 25D, 26E2BD, timestamp '2014-09-04 01:02:00.000', date '2014-09-05'),
  ("t1b", null, 16, 419L, float(17), 25D, 26E2BD, timestamp '2014-10-04 01:02:00.000', null),
  ("t1b", null, 16, 19L, float(17), 25D, 26E2BD, timestamp '2014-11-04 01:02:00.000', null),
  ("t3b", 8S, null, 719L, float(17), 25D, 26E2BD, timestamp '2014-05-04 01:02:00.000', date '2014-05-04'),
  ("t3b", 8S, null, 19L, float(17), 25D, 26E2BD, timestamp '2015-05-04 01:02:00.000', date '2015-05-04')
  as t3(t3a, t3b, t3c, t3d, t3e, t3f, t3g, t3h, t3i);

-- correlated IN subquery
-- simple select
-- TC 01.01
SELECT *
FROM   t1
WHERE  t1a IN (SELECT t2a
               FROM   t2);

-- TC 01.02
SELECT *
FROM   t1
WHERE  t1b IN (SELECT t2b
               FROM   t2
               WHERE  t1a = t2a);

-- TC 01.03
SELECT t1a,
       t1b
FROM   t1
WHERE  t1c IN (SELECT t2b
               FROM   t2
               WHERE  t1a != t2a);

-- TC 01.04
SELECT t1a,
       t1b
FROM   t1
WHERE  t1c IN (SELECT t2b
               FROM   t2
               WHERE  t1a = t2a
                       OR t1b > t2b);

-- TC 01.05
SELECT t1a,
       t1b
FROM   t1
WHERE  t1c IN (SELECT t2b
               FROM   t2
               WHERE  t2i IN (SELECT t3i
                              FROM   t3
                              WHERE  t2c = t3c));

-- TC 01.06
SELECT t1a,
       t1b
FROM   t1
WHERE  t1c IN (SELECT t2b
               FROM   t2
               WHERE  t2a IN (SELECT t3a
                              FROM   t3
                              WHERE  t2c = t3c
                                     AND t2b IS NOT NULL));

-- simple select for NOT IN
-- TC 01.07
SELECT DISTINCT( t1a ),
               t1b,
               t1h
FROM   t1
WHERE  t1a NOT IN (SELECT t2a
                   FROM   t2);

-- DDLs
create temporary view a as select * from values
  (1, 1), (2, 1), (null, 1), (1, 3), (null, 3), (1, null), (null, 2)
  as a(a1, a2);

create temporary view b as select * from values
  (1, 1, 2), (null, 3, 2), (1, null, 2), (1, 2, null)
  as b(b1, b2, b3);

-- TC 02.01
SELECT a1, a2
FROM   a
WHERE  a1 NOT IN (SELECT b.b1
                  FROM   b
                  WHERE  a.a2 = b.b2)
;

-- TC 02.02
SELECT a1, a2
FROM   a
WHERE  a1 NOT IN (SELECT b.b1
                  FROM   b
                  WHERE  a.a2 = b.b2
                  AND    b.b3 > 1)
;
