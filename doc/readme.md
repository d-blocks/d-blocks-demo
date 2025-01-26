## Prepare Teradata environment

- visit the address https://clearscape.teradata.com/, and create a new Teradata demo environment
  - new account can be created at [this address](https://www.teradata.com/getting-started/demos/clearscape-analytics?_gl=1*11or0mp*_gcl_au*NjAyODg4MjY3LjE3MzAyODIxNTk.*_ga*MjA5NzMzMDYwMi4xNzI3NzcwOTM4*_ga_7PE2TMW3FE*MTczNzg3NDE2Ni4xOC4wLjE3Mzc4NzQxNjYuNjAuMC4w&utm_medium=referral&utm_source=email)
  - if you already have an account, you can access it at https://clearscape.teradata.com/sign-in
  - follow the instructions on the website to create a new Teradata environment
  - take note of the following parameters:
    - `environment name` - in this example, we choose the name `debbie01`
    - `database password` - in this example, we choose the password `debbie01`
  - please not that it takes a few minutes for the new envvironment to spin up

## Prepare the example git repository

Obtain fresh copy of this git repository. You can choose to download it as a zip file, although 
we would really encourage you to actually clone it to your local hard drive.

```bash
git clone ....
```

## Edit the configuration file

- navigate to the directory where you unzipped, or cloned this repository
- find the file named [dblocks.toml](./dblocks.toml) 