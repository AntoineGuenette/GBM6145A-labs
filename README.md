# GBM6145A-labs
This repository contains all the code used to complete lab assignements for the GBM6145A _Ingénierie de la réadaptation_ course at Polytechnique Montreal.

---

## Requirements for the installation

### Git
Check that git is installed:
```bash
git --version
```
If it is not installed, please follow the official installation instructions for your operating system:
https://git-scm.com/downloads

## Installation

### 1 - Clone the repository
Open a terminal (Command Prompt, PowerShell, or shell) and navigate to the directory where you want to clone the repository.
```bash
cd <path/to/the/repository>
```
Clone the repository:
```bash
git clone https://github.com/AntoineGuenette/GBM6145A-labs
cd GBM6145A-labs
```

### 2 – Open the project folder in MATLAB
1. Launch **MATLAB**.
2. In the **Current Folder** panel, navigate to the cloned repository.
3. Select the folder `GBM6145A-labs`.
4. Right-click the folder and choose **Add to Path → Selected Folders and Subfolders**.

### 3 – Install the required MATLAB toolbox

This project requires the **Signal Processing Toolbox**.

1. In MATLAB, go to the **Home** tab.
2. Click **Add-Ons → Get Add-Ons**.
3. Search for **Signal Processing Toolbox**.
4. Click **Install**.

### 4 – Verify the installation

To confirm that the toolbox is installed, run:

```matlab
ver
```

You should see **Signal Processing Toolbox** in the list of installed products.
