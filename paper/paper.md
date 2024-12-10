---
title: 'Gala: A Python package for galactic dynamics'
tags:
  - Python
  - astronomy
  - dynamics
  - galactic dynamics
  - milky way
authors:
  - name: Adrian M. Price-Whelan
    orcid: 0000-0000-0000-0000
    equal-contrib: true
    affiliation: "1, 2" # (Multiple affiliations must be quoted)
  - name: Author Without ORCID
    equal-contrib: true # (This is how you can denote equal contributions between multiple authors)
    affiliation: 2
affiliations:
 - name: Lyman Spitzer, Jr. Fellow, Princeton University, United States
   index: 1
   ror: 00hx57361
 - name: Institution Name, Country
   index: 2
 - name: Independent Researcher, Country
   index: 3
date: 13 August 2017
bibliography: paper.bib

---

# Summary

The forces on stars, galaxies, and dark matter under external gravitational
fields lead to the dynamical evolution of structures in the universe. The orbits
of these bodies are therefore key to understanding the formation, history, and
future state of galaxies. The field of "galactic dynamics," which aims to model
the gravitating components of galaxies to study their structure and evolution,
is now well-established, commonly taught, and frequently used in astronomy.
Aside from toy problems and demonstrations, the majority of problems require
efficient numerical tools, many of which require the same base code (e.g., for
performing numerical orbit integration).

The development of supersonic civil aviation with an emphasis on enhanced technical and environmental sustainability calls for a comprehensive approach to supersonic aircraft design and performance characterization. These designs must not only meet high-speed flight demands but also accommodate diverse external conditions throughout their missions, requiring optimization across multiple operating points for aerodynamic and propulsive systems \cite{kuchemann2012}. Thus, configuring, optimizing, and investigating a high-speed propulsion system is a pivotal step in realizing supersonic and hypersonic aircraft. 

# Statement of need

In terms of a propulsion system architecture that can comply with the mission definitions of high-speed aircraft, ramjet engines offer significant advantages over rocket engines, as they do not require onboard oxidizer storage or rotating parts. Despite their simpler structure compared to turbo-based aero-engines, the internal flow dynamics of ramjets are complex and must be meticulously studied to ensure system stability and high performance \cite{murthy2001scramjet}. 

Conceptual design methods using zero- and one-dimensional approaches are therefore cost-effective alternatives to high-fidelity numerical simulations. They allow analysis of the design parameters and operational variables of each major component, as well as assessing propulsive performance metrics such as thrust, specific impulse, and fuel consumption \cite{ma2019control, tian2014quasi}. In this regard, reduced order models for high-speed propulsion systems, including ramjet and scramjet engine configurations, have been developed and tested since the mid-1960s. Early low-fidelity models analyzed how fuel injection and mixing affect the ramjet/scramjet cycle by simulating flow through intake contours using a two-shock approach \cite{bauer1966}. These models examined critical conditions in the combustion chamber, such as pre-ignition states, fuel mixing, ignition methods, and combustor length reduction, while exploring propulsion system characteristics at various altitudes and speeds. To enhance performance and reduce weight of ramjet engines, a numerical approach combining finite-difference solutions with a well-stirred reactor model and finite-rate chemistry was proposed, incorporating a shear layer model to account for viscous effects \cite{harsha1978, edelman1981}. Schindel developed a performance estimation framework for ramjet/scramjet engines, using a mix of non-isentropic and isentropic compression properties, variable cross-sectional area combustor chambers with continuous fuel burn, and isentropic expansion through the nozzle for integrated airframe performance characterization \cite{schindel1990}. Later studies introduced 1D models with Eulerian-Lagrangian coupling to examine both stable and unstable combustion modes and their impacts on cycle performance \cite{bhatia1990}. Riggins and Clinton also modeled thrust losses due to incomplete fuel burning and entropy losses from irreversibility using aerothermodynamics principles \cite{riggins1995}.

%In this regard, Li et al. developed one- and two-dimensional steady-state segmented models to investigate design parameters impact on the heat transfer performance of hydrocarbon fuel precoolers for precooled-Turbine Based Combined Cycle (TBCC) engines \cite{hui2022refined}.

In subsequent research, O'Brien and colleagues proposed a one-dimensional model for high-speed propulsion flow paths, incorporating finite-rate chemistry to examine how fuel mixing and ignition timescales affect various engine operating conditions \cite{brien2001}. They studied the impact of area changes, friction, mass injection, fuel mixing, and heat transfer to the combustor walls on performance of rocket-based combined-cycle (RBCC) and scramjet engines. Other studies developed physics-based models to combine low-fidelity propulsion computations with structural integrity considerations for air-breathing hypersonic engines, estimating propulsive performance under different aeroelastic modes \cite{chavez1994, bolender2007}. Similarly, Birzer and Doolan developed a model for a hydrogen-fueled scramjet combustor using a set of one-dimensional ordinary differential equations, validating their approach with experimental data from the Hyshot-II cases \cite{birzer2009quasi}. They highlighted the model's ability to estimate thrust but acknowledged that it could not predict the two-dimensional pressure peaks arising from supersonic combustion. However, these models lacked adequate combustion modeling, failing to consider the aerothermochemical effects of gas mixing and burning in the combustion chamber. 

In order to resolve these issues, Torrez et al. created a reduced-order engine model for high-speed propulsion systems, simulating mixing and combustion in ramjet and scramjet engines \cite{torrez2011}. This model, called MASIV, used tabulated presumed probability distribution function flamelet chemistry to generate low-fidelity combustion data, making it suitable for design and optimization due to significantly shorter computation times compared to numerical and experimental methods. The authors improved their MASIV numerical tool by coupling it with the Shapiro method to predict the thermal choking position, which is a mathematical singularity in the ramjet engine duct \cite{torrez2013new}. Additionally, Tian et al. introduced a quasi-1D strength-adaptable shock approach to estimate pre-combustion conditions, modeling the interactions between flow development in the isolator and the combustion modes of dual-mode scramjets or ramjets \cite{tian2014}. 

This approach was used to estimate heat release distributions accounting for area changes, friction, and mass injection within the combustion chamber. Moreover, the European Commission has initiated a hypersonic research program to achieve high flight speeds in civil aviation. Various concepts, including LAPCAT-MR1~\cite{steelant2009sustained}, LAPCAT-MR2~\cite{Meerts2013},  LAPCAT-MR2.4~\cite{Roncioni2013}, Stratofly-MR3~\cite{Viola2021}, and most recently M\&L-MR5~\cite{viola2022}, have been investigated under this program. Accordingly, in order to contribute to the recent effort to explore high-speed civil air transportation, a holistic propulsive path design and analysis 60 tool is proposed by Cakir et al. \cite{cakir2022}. The analysis framework is utilized to investigate both ramjet intake characteristics in terms of its contribution to the overall propulsive system performance and to analyze the scramjet engine design space \cite{ispir2024}.

Although there are numerous low-fidelity design and analysis studies aimed at accurately characterizing the performance specifications of ramjet engines, most focus on individual components of the propulsion system rather than a comprehensive methodology. Few studies consider the combined influence of flight conditions and design parameters throughout the entire propulsive flow path. Therefore, this study integrates individual design and analysis approaches for high-speed propulsion components to develop a holistic, low-fidelity design method for cost-efficient characterization of the ramjet engine design space. Accordingly, `RASDAS` is developed.

# Holistic Framework

The workflow of the holistic propulsive path design and analysis is provided in Fig.\ref{fig8}. The procedure starts with the selection of flight ($M_{\infty}$ and altitude) and design conditions ($M_{I,E}$ and $\beta$) based on the mission definition (Fig.\ref{fig8}, gray). Then, the intake design module utilizes the design parameters to determine the boundary conditions for the Busemann intakes. Once the intake exit Mach number is determined, a total pressure recovery factor ($\pi$) is selected to compute the flow properties upstream of the terminal conical shock wave. Afterwards, an upstream integration is performed solving the axisymmetric T-M equations to streamtrace a Busemann flow template. As the flow properties at the intake exit are determined based on the flight Mach number and the intake truncation angle, the upstream integration is terminated once the flow alignment at the intake exit meets the upstream boundary condition. Then the convergence of the intake design approach is checked against the intake inlet Mach number ($M_1$). If the converge criteria is not met, the design loop is iterated on by varying $\pi$ to ensure the convergence tolerance of $|M_1^*-M_1|$$<$10$^{-4}$ is satisfied. If so, intake design module is terminated and flow properties alongside intake performance characteristics are extracted (Fig.\ref{fig8}, blue).

In stage 3, flow exiting the intake enters the isolator. First, the isolator approximated by a normal shock decelerates the flow to subsonic conditions. Then, as the flow enters the combustor, an equivalence ratio is selected to initiate fuel injection and combustion. Within the combustor, reactive one-dimensional Navier-Stokes equations are solved to propagate the flow towards the exit of the combustor where the flow is required to reach sonic conditions. Thus, at the exit of the combustor a second convergence criteria regarding the setting of the fuel injection in terms of thermal choking exists. In case of premature occurrence of thermal choking, the flow decelerates to subsonic velocities before the nozzle throat which causes further deceleration as the area expansion ratio increases. A similar outcome is valid when the flow does not reach sonic conditions by the end of the combustor duct. Thus, a second iterative solution loop is constructed for the combustor module where the equivalence ratio (ER) is adjusted to ensure thermal choking by the end of the combustion chamber (Fig.\ref{fig8}, red). Once the convergence criteria is met for thermal choking, combustor performance characteristics are extracted and the flow is allowed to proceed into the nozzle for expansion and reacceleration. To begin with, a nozzle length and corresponding area ratio is prescribed. Then, the reactive conditions are frozen within the nozzle and the non-reactive set of ODE is solved until the predetermined nozzle length is completed. Final and third converge criteria is set at the end of the nozzle to check for perfect expansion to atmospheric conditions at given altitude. In case this condition is not met, the nozzle length and area ratio is varied in an iterative loop. Then, final propulsive performance data is extracted upon convergence of step Fig.\ref{fig8} (green).

# Validation and verification

The verification of the intake design and analysis module of the full propulsive path investigation methodology introduced in this study is performed by means of comparative numerical simulations of higher fidelity and the capability of the design approach to represent physically realizable intakes is demonstrated in comparison to experimental studies \cite{cakir2022}. The design parameters for the intake contours are provided as boundary conditions to the numerical simulations directly to assess the validity of the streamtraced contours in terms of providing the desired flow field properties. The numerical investigations included a mesh independency analysis. Accordingly, a mesh convergence history is extracted to document the convergence of the computed performance parameters with the values indicated by the reduced order analysis. The proposed reduced order model yielded results with a maximum of $\sim$1\% deviation from the values predicted by RANS in terms of intake exit Mach number ($\epsilon(M_{C,I})$=0.26\%), mass flow rate ($\epsilon(\dot{m}_{air})$=1.35\%), total pressure recovery ($\epsilon(TPR)$=0.81\%), compression pressure ratio ($\epsilon(CPR)$=1.21\%), and temperature ratio ($\epsilon(TR)$=0.41\%).

The validation of the combustor and nozzle analysis module is conducted by comparing the predicted flow properties with the experimental and numerical data provided by Torrez \textit{et al.} \cite{torrez2011reduced}. Throughout the experiments conducted on a dual-mode ramjet combustor, the facility is operated in ramjet mode during which pressure measurements along the combustor and isolator sections are acquired. The corresponding experimental data is utilized for the validation studies of the MASIV code, developed for solving flow within ramjet and scramjet engines using various reduced-order approaches. Additionally, higher order numerical investigations are performed using the Ansys Fluent commercial code for comparison with the MASIV results. The results obtained with MASIV code, Fluent and the experimental campaigns are compared against the ones provided by the methodology of the present study under similar boundary and operating conditions. Although any fuel-air mixing model is not defined in the combustor module of the present work, the results of pressure drop, Mach number increase and temperature rise were perfectly matched with the ones of the MASIV and significant agreement is denoted with the experimental data \cite{cakir2022}. The comparisons of flow pressure evolution in the nozzle also yielded good agreement with the experimental results.

# Research applications



# Citations

Citations to entries in paper.bib should be in
[rMarkdown](http://rmarkdown.rstudio.com/authoring_bibliographies_and_citations.html)
format.

If you want to cite a software repository URL (e.g. something on GitHub without a preferred
citation) then you can do it with the example BibTeX entry below for @fidgit.

For a quick reference, the following citation commands can be used:
- `@author:2001`  ->  "Author et al. (2001)"
- `[@author:2001]` -> "(Author et al., 2001)"
- `[@author1:2001; @author2:2001]` -> "(Author1 et al., 2001; Author2 et al., 2002)"

# Acknowledgements

This project has received funding from the European Union's Horizon 2020 research and innovation programme, MORE \& LESS (MDO and REgulations for Low-boom and Environmentally Sustainable Supersonic aviation) project under grant agreement No 101006856. 

# References
