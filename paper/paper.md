---
title: 'DARE: A MATLAB package for Design and Analysis of Ramjet/scramjet Engines'
tags:
  - Matlab
  - Reduced order modeling
  - High-speed propulsion
  - Ramjet
  - Scramjet
  - Detailed chemistry 
 
authors:
  - name: Bore O. Cakir
    orcid: 0000-0002-3577-4730
    equal-contrib: true
    affiliation: "1, 2" # (Multiple affiliations must be quoted)
  - name: Ali Can Ispir
    orcid: 0000-0002-2396-6647
    equal-contrib: true # (This is how you can denote equal contributions between multiple authors)
    affiliation: 3
affiliations:
 - name: Department of Energy Sciences, Lund University, Sweden 
   index: 1
 - name: Department of Turbomachinery and Propulsion, von Karman Insitute for Fluid Dynamics, Belgium
   index: 2
 - name: Department of Mechanical Engineering, Eindhoven University of Technology, the Netherlands
   index: 3
date: 13 August 2017
bibliography: paper.bib

---

# Summary

The advancement of supersonic civil aviation, with a focus on improving both technical and environmental sustainability, requires a holistic approach to the design and performance assessment of supersonic aircraft. These designs must meet the demands of high-speed flight while also being adaptable to varying external conditions throughout their missions, necessitating optimization of aerodynamic and propulsion systems across different operating conditions [@kuchemann2012]. Therefore, configuring, optimizing, and analyzing a high-speed propulsion system is crucial to the development of supersonic and hypersonic aircraft. When considering propulsion system architectures that align with the mission requirements of high-speed aircraft, ramjet engines present notable advantages over rocket engines, as they eliminate the need for onboard oxidizer storage or rotating components. Although ramjets are structurally simpler than turbo-based aero-engines, their internal flow dynamics are intricate and require careful study to ensure stability and optimal performance [@murthy2001]. As such, conceptual design methods using zero- and one-dimensional approaches provide a cost-effective alternative to detailed numerical simulations. These methods enable the analysis of design parameters and operational variables for key components, as well as the evaluation of propulsion performance metrics like thrust, specific impulse, and fuel consumption.

# Statement of need

Since the 1960s, reduced-order models for high-speed propulsion systems, including ramjet and scramjet engines, have been developed and tested. Early models focused on fuel injection and mixing effects, simulating flow through intake contours with a two-shock approach [@bauer1966]. These studies addressed key combustion chamber conditions like pre-ignition states, fuel mixing, and ignition methods, and explored propulsion characteristics at different altitudes and speeds. Further on, numerical approaches combining finite-difference solutions with a stirred reactor model and finite-rate chemistry were proposed, focusing on the design acpects such as complete engine performance and weight optimizaiton [@harsha1978; @edelman1981]. Later, 1D models with Eulerian-Lagrangian were introudced to examine stable and unstable combustion modes and their impacts on cycle performance [@bhatia1990], as well as thrust losses due to incomplete combustion and entropy from irreversibility [@riggins1995]. Other models combined low-fidelity propulsion computations with structural integrity for hypersonic engines, estimating performance under aeroelastic conditions [@chavez1994; @bolender2007]. However, these models lacked sufficient combustion modeling. To address this, @torrez2011 developed a reduced-order engine model for mixing and combustion in ramjet and scramjet engines, and improved their MASIV tool with the Shapiro method to predict thermal choking position [@torrez2013new]. 

These are numerous examples of various low-fidelity design and analysis studies aimed at accurately characterizing the performance specifications of ramjet engines, most of these tools focus on individual components of the propulsion system rather than a comprehensive methodology. Hence, there exists no prior attempt to couple the intake design approaches with a combustion analysis module with only a few studies considering the combined influence of flight conditions and design parameters throughout the entire propulsive flow path. Although understanding and analysis of the performance criteria for each component is essential on capturing the relevant physical phenomena that influence various aspect of design considerations for ramjet and scramjet engines, proper exploration of the design envelope is necesary for accurate description of mission definition and appriate optimization of design choices for high-speed aircraft design. 

Therefore, `DARE` is proposed as a design and analysis tool that combines the individual design and analysis approaches for high-speed propulsive path components to achieve a holistic low-fidelity design method for cost-efficient characterization of a high-speed propulsive design space. Ramjet/scramjet propulsive flow path is composed of an intake, an isolator, a combustor and a nozzle. The analytical tool used aims to provide a fully integrated flow path analysis, which includes three main modules. First module, covers the design and investigation process of the intake which is used to provide the necessary freestream flow modulation prior to the isolator through which a normal shock assumption is applied in case of ramjet configurations. The resultant flow properties are utilized for the combustion module to compute the flow evolution within the combustion chamber based on 1D steady inviscid flow equations coupled with detailed chemistry approach and JANAF tables using the SUNDIALS (Suite of Nonlinear and Differential/Algebraic Equation Solvers) code [@hindmarsh2005], developed by Lawrence Livermore National Laboratory. Finally, the third model is the nozzle design and analysis module, in which flow expansion through various expansion ratios and nozzle geometries are calculated using the 1D steady inviscid flow equations under cold flow conditions. Consequently, the parameters such as thrust, fuel consumption and specific impulse are calculated to quantify the engine performance for each design.

# Research applications

- acta 2022
- hisst 2022 I: ramjet, hisst 2022 II: scramjet
- scitech 2023
- acta 2024
- astec 2024 

# Acknowledgements

This project has received funding from the European Union's Horizon 2020 research and innovation programme, MORE \& LESS (MDO and REgulations for Low-boom and Environmentally Sustainable Supersonic aviation) project under grant agreement No 101006856. 

# References
