# TLDR;

This repository shows how I use [a github action](.github/workflows/on-push-mirror-to-azdo.yaml) to automatically call a [bash script](.github/workflows-scripts/mirror-to-azdo.sh) which mirrors all pushes on my Github repository to my Azure Devops repository. This is done by cloning the Github repository, setting a new remote to Azure Devops and pushing to this new remote.

# What is needed before starting
- A Github repository which commits are to be mirrored on Azure Devops
- An Azure Devops Personal Access Token with permission "Code (Read & Write)".
- A Github Personal Access Token with read-only access on "Contents" and "Metadata (mandatory)" on the repository. If the Github repository is part of an organization, one will have to wait for an organization administrator to validate the token.

# Initializing the Azure Devops repository

- In the Azure Devops organization (say `azdo-org`), in the project (say `azdo-project`), create an Azure Devops repository (say `azdo-repo`) **Ensure to uncheck "Add a README", and leave "Add a .gitignore: None" as is** 
-  In the repository `azdo-repo`, click "Import" button under "Import a repository" section.
    - enter the Github repository url
    - check "Requires Authentication"
    - enter the github login as well as the Github Personal Access Token for the Github repository
    - click "Import", it should end up with a clone of the current state of the Github repository

The Azure Devops repository url should be like `https://dev.azure.com/azdo-org/azdo-project/_git/azdo-repo`

# Configuring the Github repository 

It should be noted that the `on-push-mirror-to-azdo.yaml` action file makes the assumption that the Github environment is named `Dev`. One need to change it to use it on a different environment name.
In this environment, `Dev`, there should be :
- an `AZUREPAT` environment **secret**, containing the Azure Devops Personal Access Token
- an `GITHUBPAT` environment **secret**, containg the Github Personal Access Token
- an `AZORG` environment **variable**, containing the name of the Azure Devops organization (say `azdo-org`)
- an `AZPROJECT` environment **variable** containing the name of the Azure Devops project (say `azdo-project`)
- an `AZREPOSITORY` environment **variable** containing the name of the Azure Devops repository (say `azdo-repo`)
- an `AZUSERNAME` environment **variable** containing the user name of the Azure Devops user the Azure Devops Personal Access Token belongs to
- a `GITHUBUSERNAME` environment **variable** containing the Github user name of the Github User the Github Personal Access Token belongs to.

# Enabling the mirroring
As soon as the `.github` subtree is included and pushed in the Github repository, each pushed branch containing it will be mirrored to the Azure Devops repository.

Warning : Force pushing on Github (hence trying to "forget" commits already mirrored on Azure Devops), or performing commits directly on Azure Devops, will most of the time create tricky merge conflicts which will block the mirroring process.
You can mitigate this issue by restricting the mirroring to the main branch ([see documentation](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#running-your-workflow-only-when-a-push-to-specific-branches-occurs)) and disallow force pushing on main branch.