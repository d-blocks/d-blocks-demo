## Prepare Teradata environment

- visit the address https://clearscape.teradata.com/, and create a new Teradata demo environment
  - new account can be created at [this address](https://www.teradata.com/getting-started/demos/clearscape-analytics?_gl=1*11or0mp*_gcl_au*NjAyODg4MjY3LjE3MzAyODIxNTk.*_ga*MjA5NzMzMDYwMi4xNzI3NzcwOTM4*_ga_7PE2TMW3FE*MTczNzg3NDE2Ni4xOC4wLjE3Mzc4NzQxNjYuNjAuMC4w&utm_medium=referral&utm_source=email)
  - if you already have an account, you can access it at https://clearscape.teradata.com/sign-in
  - follow the instructions on the website to create a new Teradata environment
  - take note of the following parameters:
    - `environment name` - in this example, we choose the name `d-bee01`
    - `database password` - in this example, we choose the password `d-bee01`
  - please not that it takes a few minutes for the new envvironment to spin up
  - start the environment, so that it is accessible

## Prepare the example git repository

Obtain fresh copy of this git repository. You can choose to download it as a zip file, although 
we would really encourage you to actually clone it to your local hard drive.

```bash
git clone ....
```

## Edit and test the configuration file

- navigate to the directory where you unzipped, or cloned this repository
- find the file named [dblocks.toml](./dblocks.toml) - which is stored in the root directory, and edit it
- follow the instructions in the configuration file, fill in the correct host name, user name, and database password
- test the configuration

```bash
d-bee cfg-check
d-bee env-test-connection d-blocks-demo
```

## Commit changes to your environment

```bash
git commit -m"updated dblocks.toml"
```

## Provision the playground environment

- run the following command

```bash
d-bee quickstart
```

This should create necessary databases under the default `demo_user` database, which is created 
when a new ClearScape environment is spin up.

## Deploy objects to the database

We are now going to demonstrate one of the functionalities offered by `d-bee`.

- navigate to the directory [meta](./meta/) - investigate directory structure, and available files
- each directory represents a Teradata database, directory structure is hierarchical in fashion simillar to structure of the Teradata database
- each file represents definition of a database object


We are now going to deploy these objects to the Teradata database.

```bash
d-bee env-deploy d-blocks-demo meta --assume-yes
```


## Make changes to your environment in Teradata

Logon to the ClearScape environment using the tool of your choice (Teradata Studio, DBeaver, ...).

Create a new object, like so:

```sql
create table DEV_STG_T.TEST_TABLE (
  test_id INTEGER NOT NULL
) UNIQUE PRIMARY INDEX (test_id)
;
```

## Test the extraction functionality


```bash
d-bee env-deploy d-blocks-demo meta --assume-yes
```

## Observe the git history

```bash
git log
```

