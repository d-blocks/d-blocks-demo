/* Root database for entire environment */
create database {{env}}_admin from {{env}}_env as perm=300000000;
/* Environment databases */
create database {{env}}_stg_t from {{env}}_admin as perm=100000000;
create database {{env}}_tgt_t from {{env}}_admin as perm=100000000;
create database {{env}}_sem_t from {{env}}_admin as perm=90000000;
create database {{env}}_stg_v from {{env}}_admin as perm=0;
create database {{env}}_tgt_v from {{env}}_admin as perm=0;
create database {{env}}_sem_v from {{env}}_admin as perm=0;
create database {{env}}_tmp_v from {{env}}_admin as perm=0;
create database {{env}}_wrk from {{env}}_admin as perm=10000000;
/* Grant required privileges */
grant create procedure on {{env}}_wrk to dbc;
grant select on {{env}}_tgt_t to {{env}}_wrk with grant option;
grant select on {{env}}_tgt_t to {{env}}_tgt_v with grant option;
grant select on  {{env}}_tgt_v to {{env}}_wrk with grant option;
grant insert, update, delete on {{env}}_sem_t to {{env}}_wrk with grant option;
