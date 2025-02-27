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
  * [Hollistic propulsive flow path analysis](#toc3)
  * [Accompanying papers](#toc9)
  * [Installation](#toc4)
  * [Testing](#toc5)
  * [Examples](#toc6)
  * [Contributing](#toc7)
  * [How to cite this code](#toc10)
  * [Contributors](#toc11)

## What is DARE? <a name="toc1"></a> ##

Ramjet/scramjet propulsive flow path is composed of an intake, an isolator, a combustor and a nozzle. DARE aims to provide a fully integrated flow path analysis, which includes three main modules. First module, covers the design and investigation process of the intake which is used to provide the necessary freestream flow modulation prior to the isolator through which a normal shock assumption is applied in case of ramjet configurations. The resultant flow properties are utilized for the combustion module to compute the flow evolution within the combustion chamber based on 1D steady inviscid flow equations coupled with detailed chemistry approach and JANAF tables using the SUNDIALS (Suite of Nonlinear and Differential/Algebraic Equation Solvers) code [@hindmarsh2005], developed by Lawrence Livermore National Laboratory. Finally, the third model is the nozzle design and analysis module, in which flow expansion through various expansion ratios and nozzle geometries are calculated using the 1D steady inviscid flow equations under cold flow conditions. Consequently, the parameters such as thrust, fuel consumption and specific impulse are calculated to quantify the engine performance for each design.

## Why DARE? <a name="toc2"></a> ##

Since the 1960s, reduced-order models for high-speed propulsion systems, including ramjet and scramjet engines, have been developed and tested. Although there are numerous examples of various low-fidelity design and analysis studies aimed at accurately characterizing the performance specifications of ramjet engines, most of these tools focus on individual components of the propulsion system rather than a comprehensive methodology. Hence, there exists no prior attempt to couple the intake design approaches with a combustion analysis module with only a few studies considering the combined influence of flight conditions and design parameters throughout the entire propulsive flow path. Although understanding and analysis of the performance criteria for each component is essential on capturing the relevant physical phenomena that influence various aspect of design considerations for ramjet and scramjet engines, proper exploration of the design envelope is necesary for accurate description of mission definition and appriate optimization of design choices for high-speed aircraft design.

## Hollistic propulsive flow path analysis <a name="toc3"></a> ##

The workflow of the holistic propulsive path design and analysis is provided in Fig. 5. The procedure starts with the selection of flight (Mach number, $M_{\infty}$, and altitude) and design conditions (intake exit Mach number, $M_{I,E}$, and intake truncation angle, $\beta$) based on the mission definition (Fig. 1, gray). Then, the intake design module utilizes the design parameters to determine the boundary conditions for the Busemann intakes. Once the intake exit Mach number is determined, a total pressure recovery factor ($\pi$) is selected to compute the flow properties upstream of the terminal conical shock wave. Afterwards, an upstream integration is performed solving the axisymmetric T-M equations to streamtrace a Busemann flow template. As the flow properties at the intake exit are determined based on the flight Mach number and the intake truncation angle, the upstream integration is terminated once the flow alignment at the intake exit meets the upstream boundary condition. Then the convergence of the intake design approach is checked against the intake inlet Mach number. If the converge criteria are not met, the design loop is iterated on by varying π to ensure the convergence tolerance of $|M_1^*-M_1|<10^\text{−4}$ is satisfied. If so, intake design module is terminated and flow properties alongside intake performance characteristics are extracted (Fig. 1, blue).

<figure>
  <img src="https://github.com/user-attachments/assets/8a6c66f9-3551-428a-a0e5-130249b8c8d6">
 <br/>
  <figcaption>Fig 1. Workflow for reduced order design and analysis of RAM/SCRAMJET engines.</figcaption>
</figure>

<br/>

In stage 3, a decision based on the engine mode (**RAM** or **SCRAM**) is made to direct the flow through the isolator. 

* In case of **RAM** mode, the flow exiting the intake enters the isolator. First, the isolator approximated by a normal shock decelerates the flow to subsonic conditions. Then, as the flow enters the combustor, an equivalence ratio is selected to initiate fuel injection and combustion. Within the combustor, reactive 1D Navier-Stokes equations are solved to propagate the flow towards the exit of the combustor where the flow is required to reach sonic conditions. Thus, at the exit of the combustor a second convergence criteria regarding the setting of the fuel injection in terms of thermal choking exists. In case of premature occurrence of thermal choking, the flow decelerates to subsonic velocities before the nozzle throat which causes further deceleration as the area expansion ratio increases. A similar outcome is valid when the flow does not reach sonic conditions by the end of the combustor duct. Therefore, a second iterative solution loop is constructed for the combustor module where the equivalence ratio (ER) is adjusted to ensure thermal choking by the end of the combustion chamber (Fig. 1, red). Once the convergence criteria are met for thermal choking, combustor performance characteristics are extracted and the flow is allowed to proceed into the nozzle for expansion and reacceleration.

* In case of **SCRAM** mode, the isolator module is bypassed and the flow directly proceeds to the combustor. As the flow remains supersonic within the combustor the ER setting becomes an user-defined design choice provided that the selected value does not lead to thermal chocking within the combustor. Accordingly, the reactive 1D Navier-Stokes equations are solved within the combustor with the given ER value. If the selected design choice leads to thermal chocking the solution is terminated and an error message is outputed. Otherwise the flow reaches the end of the combustor at supersonic conditions after which the combustor exit conditions are provided directly to the nozzle module without the need of iteration.

Proceeding with the nozzle module, first a nozzle length and corresponding area ratio is prescribed. Then, the reactive conditions are frozen within the nozzle and the non-reactive set of ODE is solved until the predetermined nozzle length is completed. Final and third converge criteria is set at the end of the nozzle to check for perfect expansion to atmospheric conditions at given altitude. In case this condition is not met, the nozzle length and area ratio is varied in an iterative loop. Then, final propulsive performance data is extracted upon convergence of step Fig. 1 (green). At the nozzle exit, the flow pressure is expected to be at least 30% of the ambient pressure, in accordance with the Summerfield criterion. [@fernandez2013simulation].

## Accompanying papers <a name="toc9"></a> ##

For a comprehensive dive into the matemetical foundation of the propulsive cycle modelling, intake design approach, treatment of reactive flow solutions and extraction of propulsive performance parameters the users are encouraged to check out the following papers:

[1] Cakir, B. O., Ispir, A. C. & Saracoglu, B. (2022). Low fidelity design and analysis of propulsion systems for high-supersonic cruiser concepts. In HiSST: 2nd international conference on high-speed vehicle science & technology.

[2] Ispir, A. C., Cakir, B. O. & Saracoglu, B. (2022). Design space exploration for a scramjet engine by using data mining and low-fidelity design techniques. In HiSST: 2nd international conference on high-speed vehicle science & technology.

[3] Cakir, B. O., Ispir, A. C., & Saracoglu, B. H. (2022). Reduced order design and investigation of intakes for high speed propulsion systems. Acta Astronautica, 199, 259–276. https://doi.org/https://doi.org/10.1016/j.actaastro.2022.07.037

[4] Cakir, B. O., Ispir, A. C., Civerra, F., & Saracoglu, B. H. (2023). Reduced order design space analysis of for ramjet engines with data mining techniques. In AIAA SCITECH 2023 forum. https://doi.org/10.2514/6.2023-2017

[5] Ispir, A. C., Cakir, B. O., & Saracoglu, B. H. (2024). Design space investigations of scramjet engines using reduced-order modeling. Acta Astronautica, 217, 349–362. https://doi.org/https://doi.org/10.1016/j.actaastro.2024.01.036

[6] Cakir, B. O., & Ispir, A. C. (2025). Reduced order design space analysis and operational mapping for ramjet engines. Aerospace Science and Technology, 157, 109811. https://doi.org/10.1016/j.ast.2024.109811

## Software dependencies <a name="toc3"></a> ##
* MATLAB 2016a and later
*	SUNDIALS 2.6.2

Installation section below shows how to install the required software.

## Installation <a name="toc4"></a> ##

1. Download DARE by downloading the zip file or cloning this repository by typing in Terminal:
   ```
   git clone https://github.com/DARE/DARE.git
   ```
2. Download [MATLAB](https://www.mathworks.com/downloads/) if not installed already.
   
3. Download [SUNDIALS 2.6.2](https://computing.llnl.gov/sites/default/files/inline-files/sundials-2.6.2.tar.gz) and unzip the folder. Relocate the sundials-2.6.2 folder inside the DARE folder.

4. Run MATLAB and call `sundials-2.6.2\sundials-2.6.2\sundialsTB\install_STB.m` file. The installation of SUNDIALS will start.

5. Respond to the prompts displayed in the Command Window in the following manner: 

```
    MEX files will be compiled and built using the above options
    Proceed? (y/n)
```
&rarr; Type `y` and hit enter

```
    Compile CVODES interface? (y/n) 
```
&rarr; Type `y` and hit enter

```
    Compile IDAS interface? (y/n) 
```
&rarr; Type `y` and hit enter

```
    Compile KINSOL interface? (y/n) 
```
&rarr; Type `y` and hit enter

```
    Install toolbox? (y/n)  
```
&rarr; Type `y` and hit enter

```
    Installation directory:
```
&rarr; Type the address of a folder that you want to install it into inside Matlab Toolbox, e.g., ~\Matlab\Toolbox\Sundials and hit enter

Successful installation of SUNDIALS will output to the Command Window:
```
Enjoy!
```

6. To set up the dependencies in your main DARE folder, go to your DARE folder, click on DARE.m file, and do necessary changes:

```
    pathCVODE = 
```
&rarr; Type the address where SUNDIALS was installed into e.g., ~\Matlab\Toolbox\Sundials.

```
    pathAtmos = 
```
&rarr; Type the address of where the codes used for calculating atmospheric standards are kept e.g., DARE\StandardAtm.

```
    pathFunc = 
```
&rarr; Type the address of where the codes used for calculating thermophysical properties and the combustor and nozzle duct geometric parameters are kept e.g., DARE\Codes.

```
    combCond{3} = 
```
&rarr; Type the combustor cross-sectional geometry e.g., "circular". The default type of the geometry in DARE code is "circular".

```
    combCond{4} = 
```
&rarr; Provide the input of the combustor duct profile e.g., '~\Dependencies\area_duct_profile.mat'.

```
    combCond{6} = 
```
&rarr; Provide the input of the molecular weights data of the species in the Hydrogen-Air combustion e.g., '~\Dependencies\MW_H2_Air.mat'.

```
    nozzCond{4} = 
```
&rarr; Provide the input of the nozzle duct profile e.g., '~\Dependencies\area_duct_profile.mat'.

7. To run a simulation in DARE, the following flight and design conditions must also be specified: Flight Altitude [m] ('flightComb(1)'), Flight Mach number ('flightComb(2)'), Intake exit Mach Number ('inCond{1}'), Intake truncation angle ('inCond{2}'), Intake exit area ('inCond{3}') [m²], Engine Mode: 'RAM' or 'SCRAM' ('engineMode'), Friction coefficient of the engine duct wall (Cf), Combustor Length [m] ('combCond{1}'), Combustor Inlet Area [m²] ('combCond{2}'), Equivalence Ratio ('combCond{5}'), Nozzle Length [m] ('nozzCond{1}'), and Nozzle Pressure Ratio ('nozzCond{2}'). These parameters define the operating conditions and geometry of the propulsion system within the simulation environment. The Janaf Table must be also provided for calculating thermophysical properties of the species in the hydrogen-air reaction.

## Examples <a name="toc6"></a> ##
In the ```Examples``` folder, you will find four examples of ramjet and scramjet engine designs to help you get started. Two of these examples demonstrate the design study of an engine having constant-area combustor with an 8m length and a 4m² inlet area and pre-defined diverged nozzle profile with a 10m² exit section, operating for ramjet and scramjet modes. The duct profile is shown below:

<figure>
  <img src="https://github.com/user-attachments/assets/8a6c66f9-3551-428a-a0e5-130249b8c8d6">
 <br/>
  <figcaption>Fig 2. Engine profile designed in the examples for operation in ramjet and scramjet modes.</figcaption>
</figure>

In other two examples, an engine having same combustor properties, but undefined nozzle profile were designed by user-defined nozzle expansion ratio and using perfect expansion.

* ```Examples/Scramjet/1/```: shows the design solution of a scramjet engine with pre-defined nozzle profile which is detailed above.
* ```Examples/Scramjet/2/```: shows the design solution of a scramjet engine, assuming perfect expansion at the nozzle, with the flow exiting at a pressure 10% higher than the ambient atmospheric pressure. Nozzle divergence angle is defined as 15°.
* ```Examples/Ramjet/1/```: shows the design solution of a ramjet engine with pre-defined nozzle profile which is detailed above.
* ```Examples/Ramjet/2/```: shows the design solution of a ramjet engine, assuming perfect expansion at the nozzle, with the flow exiting at a pressure 10% higher than the ambient atmospheric pressure. Nozzle divergence angle is defined as 15°.
* In these examples of the scramjet and ramjet, the functions of the codes are given below:
   * ```Examples/Functions/thermophysical_properties_calculation_fun.m```: calculating thermophysical properties of the species, including enthalpy [kJ/kg], entropy [kJ/kg/K], specific heat [kJ/kg].
   * ```Examples/Functions/enthalpy_calculation_fun.m```: calculating enthalpy of each species.
   * ```Examples/Functions/entropy_calculation_fun.m```: calculating entropy of each species.
   * ```Examples/Functions/specific_heat_calculation_fun.m```: calculating specific heat of each species.
   * ```Examples/Functions/geometric_calculation_fun.m```: calculating geometric parameters of the duct, including Hydraulic diameter [m], Wall Perimeter [m], Area Gradient [m].
   * ```Examples/Functions/reaction_rates_calculation_fun.m```: calculating reaction rates for hydrogen-air combustion using detailed kinetics provided in [@jachimowski1984chemical].
   * ```Examples/Functions/BusemannIntake.m```: calculating intake parameters based on Busemann intake design approach.
   * ```Examples/Functions/oblique_angle_calc.m```: BORA!!!
   * ```Examples/Functions/ramjet_combustor_nozzle.m```: calculating flow variables and species mass fractions along with combustor and nozzle parts in ramjet operational mode.
   * ```Examples/Functions/scramjet_combustor_nozzle.m```: calculating flow variables and species mass fractions along with combustor and nozzle parts in scramjet operational mode.
   * ```Examples/Dependencies/area_duct_profile.mat```: combustor + nozzle duct profile along with duct axis.
   * ```Examples/StandardAtm```: containing functions that calculate air properties.
   * 

For these examples, the flight conditions for scramjet engine operation were assumed to be a Mach number of 6 and an altitude of 25km, while a Mach number of 4 and an altitude of 20km were selected for ramjet engine operation. In the scramjet engine design examples, the intake exit Mach number and truncation angle were chosen as [...] and [...], respectively, whereas for the ramjet examples, these values were [...] and [...]. The equivalence ratio was set to 0.2 for scramjet operation, while for the ramjet, it was optimized to 0.1356 to induce thermal choking at the throat of the combustor.

For the ramjet and scramjet engine examples with a predefined nozzle profile, the calculated performance values and design parameters are expected to be as follows:
| Calculated Parameters | Ramjet | Scramjet |
| ------------- | ------------- | ------------- |
| Intake length [m] | Content Cell | Content Cell | BORA!!!
| Uninstalled thrust [kN] | Content Cell | 1411 |
| Specific impulse [ks] | Content Cell | 29 |
| Fuel consumption [kg/s] | Content Cell | 5 |
| Mass flow rate of air [kg/s] | Content Cell | 872.4 |

For the ramjet and scramjet engine examples with a perfectly expanded nozzle and a predefined expansion ratio (exit pressure will be 10% higher than atmospheric pressure), the calculated performance values and design parameters, such as intake and nozzle lengths, are expected to be as follows:
| Calculated Parameters | Ramjet | Scramjet |
| ------------- | ------------- | ------------- |
| Intake length [m] | Content Cell | Content Cell | BORA!!!
| Nozzle length [m] | Content Cell | 20.4 |
| Nozzle exit area [m²] | Content Cell | 136 |
| Uninstalled thrust [kN] | Content Cell | 917 |
| Specific impulse [ks] | Content Cell | 18.82 |
| Fuel consumption [kg/s] | Content Cell | 5 |
| Mass flow rate of air [kg/s] | Content Cell | 872.4 |

## Contributing <a name="toc7"></a> ##
We welcome contributions from the community to improve COBRAPRO!
* To report bugs, ask questions, and get help, please open a new issue through the Github issues page. Be as specific as possible (including screenshots, sample codes) for efficient communication. 
* To make changes to the code or add new functions, 1) fork the repo and create your branch from main, 2) make your changes to the code, and 3) open a Pull request. Once approved, your contribution will be merged into the master branch.
* For general discussions and project ideas, open a new Discussions through the Github issues page. You can also contact Ali Can Ispir (<a.c.ispir@tue.nl>) and Bora O. Cakir (<bora.cakir@vectoflow.de>).

## How to cite this code <a name="toc10"></a> ##
If you use this code in your research, please cite our accompanying journal articles [3], [5] and [6], and the JOSS paper:
```
@article{cobrapro_joss_2024,
   author = {Cakir, B. O. and Ispir, A. C.},
   doi = {@@},
   journal = {Journal of Open Source Software},
   year = {2025},
   title = {{DARE: A MATLAB Toolbox for Design and Analysis of Ramjet/scramjet Engines}},
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
