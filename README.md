# DARE: A MATLAB Toolbox for Design and Analysis of Ramjet/scramjet Engines

<a name="readme-top"></a>

<!--[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]-->

DARE (Design and Analysis of Ramjet/scramjet Engines) is a MATLAB toolbox for design and analysis of ramjet/scramjet engines tool that combines the individual design and analysis approaches for high-speed propulsive path components to achieve a holistic low-fidelity design method for cost-efficient characterization of a high-speed propulsive design space. 

## Table of contents ##

  * [What is DARE?](#toc1)
  * [Why DARE?](#toc2)
  * [Accompanying papers](#toc9)
  * [System requirements](#toc3)
  * [Installation](#toc4)
  * [Testing](#toc5)
  * [Examples](#toc6)
  * [API Documentation](#toc12)
  * [Contributing](#toc7)
  * [Known issues](#toc8)
  * [How to cite this code](#toc10)
  * [Contributors](#toc11)

## What is DARE? <a name="toc1"></a> ##

Ramjet/scramjet propulsive flow path is composed of an intake, an isolator, a combustor and a nozzle. DARE aims to provide a fully integrated flow path analysis, which includes three main modules. First module, covers the design and investigation process of the intake which is used to provide the necessary freestream flow modulation prior to the isolator through which a normal shock assumption is applied in case of ramjet configurations. The resultant flow properties are utilized for the combustion module to compute the flow evolution within the combustion chamber based on 1D steady inviscid flow equations coupled with detailed chemistry approach and JANAF tables using the SUNDIALS (Suite of Nonlinear and Differential/Algebraic Equation Solvers) code [@hindmarsh2005], developed by Lawrence Livermore National Laboratory. Finally, the third model is the nozzle design and analysis module, in which flow expansion through various expansion ratios and nozzle geometries are calculated using the 1D steady inviscid flow equations under cold flow conditions. Consequently, the parameters such as thrust, fuel consumption and specific impulse are calculated to quantify the engine performance for each design.

## Why DARE? <a name="toc2"></a> ##

Since the 1960s, reduced-order models for high-speed propulsion systems, including ramjet and scramjet engines, have been developed and tested. Although there are numerous examples of various low-fidelity design and analysis studies aimed at accurately characterizing the performance specifications of ramjet engines, most of these tools focus on individual components of the propulsion system rather than a comprehensive methodology. Hence, there exists no prior attempt to couple the intake design approaches with a combustion analysis module with only a few studies considering the combined influence of flight conditions and design parameters throughout the entire propulsive flow path. Although understanding and analysis of the performance criteria for each component is essential on capturing the relevant physical phenomena that influence various aspect of design considerations for ramjet and scramjet engines, proper exploration of the design envelope is necesary for accurate description of mission definition and appriate optimization of design choices for high-speed aircraft design.

## Hollistic propulsive flow path analysis <a name="toc3"></a> ##

The workflow of the holistic propulsive path design and analysis is provided in Fig. 5. The procedure starts with the selection of flight (Mach number, $M_{\infty}$, and altitude) and design conditions (intake exit Mach number, $M_{I,E}$, and $\beta$) based on the mission definition (Fig. 1, gray). Then, the intake design module utilizes the design parameters to determine the boundary conditions for the Busemann intakes. Once the intake exit Mach number is determined, a total pressure recovery factor ($\pi$) is selected to compute the flow properties upstream of the terminal conical shock wave. Afterwards, an upstream integration is performed solving the axisymmetric T-M equations to streamtrace a Busemann flow template. As the flow properties at the intake exit are determined based on the flight Mach number and the intake truncation angle, the upstream integration is terminated once the flow alignment at the intake exit meets the upstream boundary condition. Then the convergence of the intake design approach is checked against the intake inlet Mach number. If the converge criteria are not met, the design loop is iterated on by varying π to ensure the convergence tolerance of $|M_1^*-M_1|<10^\text{−4}$ is satisfied. If so, intake design module is terminated and flow properties alongside intake performance characteristics are extracted (Fig. 1, blue).

<figure>
  <img src="https://github.com/user-attachments/assets/8a6c66f9-3551-428a-a0e5-130249b8c8d6">
  <figcaption> Fig1. Workflow for reduced order design and analysis of RAM/SCRAMJET engines.</figcaption>
</figure>

In stage 3, a decision based on the engine mode (**RAM** or **SCRAM**) is made to direct the flow through the isolator. In case of **RAM** mode, the flow exiting the intake enters the isolator. First, the isolator approximated by a normal shock decelerates the flow to subsonic conditions. Then, as the flow enters the combustor, an equivalence ratio is selected to initiate fuel injection and combustion. Within the combustor, reactive one-dimensional Navier-Stokes equations are solved to propagate the flow towards the exit of the combustor where the flow is required to reach sonic conditions. Thus, at the exit of the combustor a second convergence criteria regarding the setting of the fuel injection in terms of thermal choking exists. In case of premature occurrence of thermal choking, the flow decelerates to subsonic velocities before the nozzle throat which causes further deceleration as the area expansion ratio increases. A similar outcome is valid when the flow does not reach sonic conditions by the end of the combustor duct. Thus, a second iterative solution loop is constructed for the combustor module where the equivalence ratio (ER) is adjusted to ensure thermal choking by the end of the combustion chamber (Fig. 1, red). Once the convergence criteria are met for thermal choking, combustor performance characteristics are extracted and the flow is allowed to proceed into the nozzle for expansion and reacceleration. To begin with, a nozzle length and corresponding area ratio is prescribed. Then, the reactive conditions are frozen within the nozzle and the non-reactive set of ODE is solved until the predetermined nozzle length is completed. Final and third converge criteria is set at the end of the nozzle to check for perfect expansion to atmospheric conditions at given altitude. In case this condition is not met, the nozzle length and area ratio is varied in an iterative loop. Then, final propulsive performance data is extracted upon convergence of step Fig. 1 (green).

## Accompanying papers <a name="toc9"></a> ##

For a comprehensive dive into the matemetical foundation of the propulsive cycle modelling, intake design approach, treatment of reactive flow solutions and extraction of propulsive performance parameters the users are encouraged to check out the following papers:



[1] S. Ha and S. Onori, “COBRAPRO: An Open-Source Software for the Doyle-Fuller-Newman Model with Co-Simulation Parameter Optimization Framework,” J. Electrochem. Soc., vol. 171, no. 9, p. 090522, Sep. 2024, doi: 10.1149/1945-7111/ad7292.

Our JOSS paper can also be viewed for additional information:

[2] S. Ha and S. Onori, “COBRAPRO: A MATLAB toolbox for Physics-based Battery Modeling and Co-simulation Parameter Optimization,” Apr. 16, 2024, arXiv: arXiv:2404.10022. 

## Software dependencies <a name="toc3"></a> ##
* MATLAB 2016a and later
* MATLAB Global Optimization Toolbox
*	MATLAB Parallel Computing Toolbox
*	SUNDIALS 2.6.2
*	CasADi (MATLAB version)
*	Xcode (for macOS users only)
*	MinGW (for Window users only)

Installation section below shows how to install the required software.

## Installation <a name="toc4"></a> ##

1. Download COBRAPRO by downloading the zip file or cloning this repository by typing in Terminal:
   ```
   git clone https://github.com/COBRAPROsimulator/COBRAPRO.git
   ```
2. Download [MATLAB](https://www.mathworks.com/downloads/) if not installed already. Make sure to select both the Global Optimization Toolbox and Parallel Computing Toolbox during the installation process.
   
3. Download [SUNDIALS 2.6.2](https://computing.llnl.gov/sites/default/files/inline-files/sundials-2.6.2.tar.gz) and unzip the folder. Relocate the sundials-2.6.2 folder inside the COBRAPRO folder.

4. Download the latest version of [CasADi (MATLAB version)](https://web.casadi.org/get/) corresponding to your operating system. Unzip and move your CasADi folder inside the COBRAPRO folder. Your COBRAPRO folder should now contain the sundials-2.6.2 and CasADi folders.
   - __IMPORTANT NOTE__: For Mac Apple Silicon users using the Apple Silicon version of MATLAB, note that you will need to download the Mac M1 version for [CasADi (MATLAB version)](https://web.casadi.org/get/). However, please download the "R2018b or later", _NOT_ the the "R2020b or later" for the Mac M1 version. We noticed that CasADi's "R2018b or later" of the Mac M1 version is not compatible with Apple Silicon version of MATLAB. This comment is valid as of CasADi v3.6.6.

6. Before we can install SUNDIALS, the following software are required to compile the mex files that will interface with the SUNDIALS IDA solver:
   - __Mac users__: Download [Xcode](https://developer.apple.com/xcode/) application (can be downloaded from Apple’s App Store). Once Xcode[^1] is installed, proceed to accept the license agreement. This can be done by opening the Xcode application, which will launch a license agreement window and click the “Agree” icon, or type
     ```
     sudo xcodebuild -license accept
     ```
     in Terminal. If the license is not accepted, MATLAB may give an error such as “Xcode is installed, but its license has not been accepted”.
   - __Window users__: Download [MinGW](https://www.mathworks.com/matlabcentral/fileexchange/52848-matlab-support-for-mingw-w64-c-c-fortran-compiler)
     
7. Now you are ready to run `install_COBRAPRO.m`, which is located in the main COBRAPRO folder. `install_COBRAPRO.m` will install SUNDIALS by calling the `sundials-2.6.2/sundialsTB/install_STB.m` file and automatically add the required folders to your MATLAB path. Run `install_COBRAPRO.m` and respond to the prompts displayed in the Command Window in the following manner:

```
MEX files will be compiled and built using the above options
   Proceed? (y/n)
```
&rarr; Type `y` and hit enter

```
Compile CVODES interface? (y/n)
```
&rarr; Type `n` and hit enter
```
Compile IDAS  interface? (y/n)
```
&rarr; Type `y` and hit enter
```
Compile KINSOL  interface? (y/n)
```
&rarr; Type `n` and hit enter
```
MEX files were successfully created.
    Install toolbox? (y/n) 
```
&rarr; Type `y` and hit enter
```
Specify the location where you wish to install the toolbox.
The toolbox will be installed in a subdirectory "sundialsTB".
Enter return to cancel the installation.
Installation directory:
```
&rarr; Just hit enter
```
Type the name of your CasADi folder (case-sensitive):
```
&rarr; Type the name of the CasADi folder exactly as it appears and hit enter

7. Successful installation will output to the Command Window:
```
COBRAPRO installed successfully! To get started, try running scripts in the Examples folder.
```
## Testing <a name="toc5"></a> ##

Automated test codes are provided in `test` folder:
- `test_1_casadiCheck.m` checks that CasADi is installed and working properly. Successful run will output to Command Window:
```
test_1 successful: CasADi is working properly!
```
- `test_2_comsolValidation.m` validates COBRAPRO against results generated from COMSOL Multiphysics[^2] as a benchmark. This ensures that COBRAPRO is installed properly and that the SUNDIALS IDA solver is working as expected. Successful validation will output to Command Window:
```
test_2 successful: COBRAPRO is working as expected! Results validated against COMSOL.
```
- `test_3_psoCheck.m` ensures that MATLAB's Global Optimization Toolbox and Parallel Computing Toolbox are installed, and makes sure that the PSO in parallel (required for parameter identification) is working correctly. Successful run will output to Command Window:
```
test_3 successful: PSO in parallel is working as expected!
```

## Examples <a name="toc6"></a> ##
In the ```Examples``` folder, you will find example codes that will help you get started.
* ```Examples/Cycling```: examples showing how to perform battery cycling simulations using experimentally identified parameters 
  * ```Examples/Cycling/cycle_CC.m```: simulating constant current (CC) cycling experiments and result visualization (voltage, state-of-charge, internal variable curves)
  * ```Examples/Cycling/cycle_HPPC.m```: simulating hybrid pulse power characterization (HPPC) profile and result visualization (voltage, state-of-charge, internal variable curves)
  * ```Examples/Cycling/cycle_UDDS.m```: simulating driving cycle profile and result visualization (voltage, state-of-charge, internal variable curves)
* ```Examples/Parameter_Identification_Routines```: examples showing how to perform parameter identification using PSO
&rarr; NOTE: In general, these scripts take a while to run. Using a processor with multiple cores, e.g., 12 or 24 cores, will significantly speed up the PSO. Also, PSO particle size and PSO exit conditions affect the PSO convergence accuracy and time.)
  * ```Examples/Parameter_Identification_Routines/DFN_pso_0_05C.m```: parameter identification using C/20 discharge data
  * ```Examples/Parameter_Identification_Routines/DFN_pso_HPPC.m```: parameter identification using HPPC data (given same number of PSO particles and PSO exit conditions, takes longer to run than ```DFN_pso_0_05C.m``` since HPPC takes much longer to run than C/20 discharge)
* ```Examples/Parameter_Identification_Results```: examples showing parameter identification results
  * ```Examples/Parameter_Identification_Results/DFN_pso_0_05C_identification.m```: parameter identification results using C/20 discharge data 
  * ```Examples/Parameter_Identification_Results/DFN_pso_HPPC_identification.m```: parameter identification results using HPPC data
  * ```Examples/Parameter_Identification_Results/DFN_pso_UDDS_validation.m```: parameter identification validation using UDDS data
* ```Examples/Parameter_Identifiability_Analysis```: examples showing how to perform LSA and correlation analysis to determine a subset of identifiable parameters for the given data
  * ```Examples/Parameter_Identifiability_Analysis/DFN_LSA_Corr_CC.m```: LSA and correlation analysis on CC profile
  * ```Examples/Parameter_Identifiability_Analysis/DFN_LSA_Corr_HPPC.m```: LSA and correlation analysis on HPPC profile
 
## Examples <a name="toc12"></a> ##

Refer to our [API documentation](https://cobrapro.readthedocs.io/en/latest/index.html) page for a list of all the functions as scripts in CORBAPRO. 

## Contributing <a name="toc7"></a> ##
We welcome contributions from the community to improve COBRAPRO!
* To report bugs, ask questions, and get help, please open a new issue through the Github issues page. Be as specific as possible (including screenshots, sample codes) for efficient communication. 
* To make changes to the code or add new functions, 1) fork the repo and create your branch from main, 2) make your changes to the code, and 3) open a Pull request. Once approved, your contribution will be merged into the master branch.
* For general discussions and project ideas, open a new Discussions through the Github issues page. You can also contact Sara Ha (<sungyeon.sara.ha@stanford.edu>).
  
## Known issues <a name="toc8"></a> ##
1. To run COBRAPRO, only the SUNDIALS IDAS interface is required. In Installation step 4, if you install the KINSOL interface, you may run into the following issue:
```
Error using mex
COBRAPRO/sundials-2.6.2/sundialsTB/kinsol/kim/src/kim.c:687:24: error: non-void function 'KIM_Stats' should return a value [-Wreturn-type]
if (kimData == NULL) return;
COBRAPRO/sundials-2.6.2/sundialsTB/kinsol/kim/src/kim.c:687:24: error: non-void function 'KIM_Free' should return a value [-Wreturn-type]
return;
2 errors generated.
```
To fix this issue, please go to `sundials-2.6.2/sundialsTB/kinsol/kim/src/kim.c` and modify line 687 to
```
if (kimData == NULL) return NULL;
```
and modify line 815 to
```
return NULL;
```
2. If you happen to run into the following error when installing/running COBRAPRO:
```
Error using mex
'idm.mexmaca64' locked by mexLock API.
``` 
This seems to occur when MATLAB is trying to compile the mex files and mexLock is triggered. To resolve the issue, please restart MATLAB. 

## How to cite this code <a name="toc10"></a> ##
If you use this code in your research, please cite our accompanying JES and JOSS papers:
```
@article{cobrapro_jes_2024,
   author = {Ha, Sara and Onori, Simona},
   doi = {10.1149/1945-7111/ad7292},
   journal = {Journal of The Electrochemical Society},
   year = {2024},
   title = {{COBRAPRO: An Open-Source Software for the Doyle-Fuller-Newman Model with Co-Simulation Parameter Optimization Framework}},
} 
```
```
@article{cobrapro_joss_2024,
   author = {Ha, Sara and Onori, Simona},
   doi = {arXiv:2404.10022},
   journal = {Journal of Open Source Software},
   year = {2024},
   title = {{COBRAPRO: A MATLAB toolbox for Physics-based Battery Modeling and Co-simulation Parameter Optimization}},
}
```

## Contributors <a name="toc11"></a> ##

[![All Contributors](https://img.shields.io/github/all-contributors/COBRAPROsimulator/COBRAPRO?color=ee8449&style=flat-square)](#contributors)

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

[^1]: Note that Xcode requires ~3.4 GB of storage space.  
[^2]: COMSOL Multiphsyics is a commerically available finite element analysis software.
