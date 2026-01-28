/* ============================================================================
   Demo Environment Initialization Script
   This script creates a complete environment with:
   - Root user ({{env}}_env)
   - Admin database
   - Environment databases (staging, target, semantic, working)
   - Application user
   - Sample role
   - Sample profile
   - Privilege assignments
   ============================================================================ */

/* ============================================================================
   SECTION 1: Create Profile
   ============================================================================ */
CREATE PROFILE {{env}}_sample_profile AS
    SPOOL = 50000000
    TEMPORARY = 20000000
    DEFAULT ACCOUNT = ('{{env}}_account')
    DEFAULT DATABASE = {{env}}_admin;

COMMENT ON PROFILE {{env}}_sample_profile IS 'Sample profile for {{env}} environment users';

/* ============================================================================
   SECTION 2: Create Root User (main environment owner)
   ============================================================================ */
CREATE USER {{env}}_env FROM demo_user AS
    PASSWORD = "{{env}}_pass123"
    PERM = 300000000
    SPOOL = 100000000
    TEMPORARY = 50000000
    PROFILE = {{env}}_sample_profile
    ACCOUNT = ('{{env}}_account')
    DEFAULT DATABASE = {{env}}_env;

COMMENT ON USER {{env}}_env IS 'Root user for {{env}} environment - contains all environment databases';

/* ============================================================================
   SECTION 3: Create Admin Database
   ============================================================================ */
CREATE DATABASE {{env}}_admin FROM {{env}}_env AS PERM = 300000000;

COMMENT ON DATABASE {{env}}_admin IS 'Admin database for {{env}} environment';

/* ============================================================================
   SECTION 4: Create Environment Databases
   ============================================================================ */

/* Staging tables database */
CREATE DATABASE {{env}}_stg_t FROM {{env}}_admin AS PERM = 100000000;
COMMENT ON DATABASE {{env}}_stg_t IS 'Staging tables for {{env}} environment';

/* Target tables database */
CREATE DATABASE {{env}}_tgt_t FROM {{env}}_admin AS PERM = 100000000;
COMMENT ON DATABASE {{env}}_tgt_t IS 'Target tables for {{env}} environment';

/* Semantic tables database */
CREATE DATABASE {{env}}_sem_t FROM {{env}}_admin AS PERM = 90000000;
COMMENT ON DATABASE {{env}}_sem_t IS 'Semantic/Business layer tables for {{env}} environment';

/* View databases (no permanent space) */
CREATE DATABASE {{env}}_stg_v FROM {{env}}_admin AS PERM = 0;
COMMENT ON DATABASE {{env}}_stg_v IS 'Staging views for {{env}} environment';

CREATE DATABASE {{env}}_tgt_v FROM {{env}}_admin AS PERM = 0;
COMMENT ON DATABASE {{env}}_tgt_v IS 'Target views for {{env}} environment';

CREATE DATABASE {{env}}_sem_v FROM {{env}}_admin AS PERM = 0;
COMMENT ON DATABASE {{env}}_sem_v IS 'Semantic/Business layer views for {{env}} environment';

CREATE DATABASE {{env}}_tmp_v FROM {{env}}_admin AS PERM = 0;
COMMENT ON DATABASE {{env}}_tmp_v IS 'Temporary views for {{env}} environment';

/* Working database for procedures and temporary objects */
CREATE DATABASE {{env}}_wrk FROM {{env}}_admin AS PERM = 10000000;
COMMENT ON DATABASE {{env}}_wrk IS 'Working database for procedures and temp objects in {{env}} environment';

/* ============================================================================
   SECTION 5: Create Role
   ============================================================================ */
CREATE ROLE {{env}}_sample_role;

COMMENT ON ROLE {{env}}_sample_role IS 'Sample role for {{env}} environment with read/write privileges';

/* ============================================================================
   SECTION 6: Grant Privileges to Role
   ============================================================================ */

/* Privileges on working database */
GRANT CREATE PROCEDURE, ALTER PROCEDURE, DROP PROCEDURE ON {{env}}_wrk TO {{env}}_sample_role WITH GRANT OPTION;
GRANT CREATE TABLE, DROP TABLE ON {{env}}_wrk TO {{env}}_sample_role WITH GRANT OPTION;

/* Read privileges on target tables */
GRANT SELECT ON {{env}}_tgt_t TO {{env}}_sample_role WITH GRANT OPTION;

/* Read privileges on target views */
GRANT SELECT ON {{env}}_tgt_v TO {{env}}_sample_role WITH GRANT OPTION;

/* Read privileges on semantic tables */
GRANT SELECT ON {{env}}_sem_t TO {{env}}_sample_role;

/* Write privileges on semantic tables */
GRANT INSERT, UPDATE, DELETE ON {{env}}_sem_t TO {{env}}_sample_role;

/* Procedure management on semantic database */
GRANT CREATE PROCEDURE, DROP PROCEDURE ON {{env}}_sem_t TO {{env}}_sample_role;

/* ============================================================================
   SECTION 7: Create Application User
   ============================================================================ */
CREATE USER {{env}}_app_user FROM {{env}}_env AS
    PASSWORD = "{{env}}_app_pass123"
    PERM = 0
    SPOOL = 20000000
    TEMPORARY = 10000000
    PROFILE = {{env}}_sample_profile
    ACCOUNT = ('{{env}}_account')
    DEFAULT DATABASE = {{env}}_wrk;

COMMENT ON USER {{env}}_app_user IS 'Application user for {{env}} environment with role-based access';

/* ============================================================================
   SECTION 8: Assign Role to Application User
   ============================================================================ */
GRANT {{env}}_sample_role TO {{env}}_app_user;

/* ============================================================================
   SECTION 9: Grant Additional System Privileges
   ============================================================================ */

/* Allow DBC to create procedures in working database (if needed for system tasks) */
GRANT CREATE PROCEDURE ON {{env}}_wrk TO dbc;

/* Grant root user access to working database for maintenance */
GRANT CREATE PROCEDURE, ALTER PROCEDURE, DROP PROCEDURE ON {{env}}_wrk TO {{env}}_env;

/* Allow cross-database object access */
GRANT SELECT ON {{env}}_tgt_t TO {{env}}_wrk WITH GRANT OPTION;
GRANT SELECT ON {{env}}_tgt_t TO {{env}}_tgt_v WITH GRANT OPTION;
GRANT SELECT ON {{env}}_tgt_v TO {{env}}_wrk WITH GRANT OPTION;
GRANT INSERT, UPDATE, DELETE ON {{env}}_sem_t TO {{env}}_wrk WITH GRANT OPTION;

/* ============================================================================
   SECTION 10: Verification Queries (commented out - uncomment to verify)
   ============================================================================ */
-- SELECT * FROM DBC.UsersV WHERE DatabaseName LIKE '{{env}}%';
-- SELECT * FROM DBC.DatabasesV WHERE DatabaseName LIKE '{{env}}%';
-- SELECT * FROM DBC.Roles WHERE RoleName = '{{env}}_sample_role';
-- SELECT * FROM DBC.Profiles WHERE ProfileName = '{{env}}_sample_profile';
-- SELECT * FROM DBC.AllRightsV WHERE GranteeName = '{{env}}_sample_role' ORDER BY DatabaseName, TableName;