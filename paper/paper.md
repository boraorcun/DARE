---
title: 'DARE: A MATLAB Toolbox for Design and Analysis of Ramjet/scramjet Engines'
tags:
  - Matlab
  - Reduced order modeling
  - High-speed propulsion
  - Ramjet
  - Scramjet
  - Detailed chemistry 
 
authors:
  - name: Bora O. Cakir
    orcid: 0000-0002-3577-4730
    equal-contrib: true
    affiliation: 1 # (Multiple affiliations must be quoted)
  - name: Ali Can Ispir
    orcid: 0000-0002-2396-6647
    equal-contrib: true # (This is how you can denote equal contributions between multiple authors)
    affiliation: 2
affiliations:
 - name: Department of Energy Sciences, Lund University, Sweden 
   index: 1
 - name: Department of Mechanical Engineering, Eindhoven University of Technology, the Netherlands
   index: 2
date: 13 August 2017
bibliography: paper.bib

---

# Summary

Advancing supersonic civil aviation with a focus on technical and environmental sustainability demands a comprehensive approach to the design and performance evaluation of supersonic aircraft. These designs must not only support the requirements of high-speed flight but also adapt to varying external conditions throughout their missions, making the optimization of aerodynamic and propulsion systems essential across diverse operating scenarios [@kuchemann2012]. Consequently, the configuration, optimization, and analysis of high-speed propulsion systems are critical for developing supersonic and hypersonic aircraft. Among the propulsion architectures suited for high-speed missions, ramjet engines offer significant advantages over rocket engines by eliminating the need for onboard oxidizer storage and rotating components. Despite their structural simplicity compared to turbo-based aero-engines, ramjets feature complex internal flow dynamics that require detailed investigation to ensure stability and optimal performance [@murthy2001]. To address this, conceptual design methods employing zero- and one-dimensional approaches provide a cost-effective alternative to detailed numerical simulations, enabling the analysis of design parameters, operational variables, and propulsion performance metrics such as thrust, specific impulse, and fuel consumption.

# Statement of need

Since the 1960s, researchers have developed and evaluated reduced-order models for high-speed propulsion systems, including ramjet and scramjet engines. Early models concentrated on simulating fuel injection and mixing effects, using a two-shock approach to analyze flow through intake contours [@bauer1966]. These efforts investigated critical combustion chamber parameters such as pre-ignition conditions, fuel mixing, and ignition techniques, while also assessing propulsion performance across varying altitudes and speeds. Later advancements introduced numerical methods that integrated finite-difference solutions with stirred reactor models and finite-rate chemistry, emphasizing design aspects like overall engine performance and weight optimization [@harsha1978; @edelman1981]. Subsequently, one-dimensional models incorporating Eulerian-Lagrangian frameworks were developed to study stable and unstable combustion modes and their influence on cycle performance [@bhatia1990]. These models also evaluated thrust losses caused by incomplete combustion and entropy generated from irreversibility [@riggins1995]. Some approaches combined low-fidelity propulsion analysis with structural integrity considerations for hypersonic engines, enabling performance assessments under aeroelastic conditions [@chavez1994; @bolender2007]. Despite these advancements, combustion modeling remained a limitation. To address this, @torrez2011 introduced a reduced-order engine model for ramjet and scramjet mixing and combustion, further enhancing the MASIV tool with the Shapiro method to predict thermal choking positions [@torrez2013new].

Numerous low-fidelity design and analysis studies have been conducted to characterize the performance of ramjet engines. However, most of these tools focus on individual propulsion system components rather than providing a holistic methodology. To date, there has been no significant effort to integrate intake design approaches with combustion analysis modules, and only a limited number of studies consider the combined effects of flight conditions and design parameters across the entire propulsion flow path. While analyzing the performance of individual components is crucial for understanding the physical phenomena that influence various design considerations for ramjet and scramjet engines, a thorough exploration of the design envelope is essential. This approach ensures an accurate definition of mission requirements and enables the effective optimization of design choices for high-speed aircraft.

The `DARE` tool is introduced as a design and analysis framework that integrates individual approaches for high-speed propulsion components into a unified low-fidelity methodology. This tool aims to enable cost-effective characterization of the design space for high-speed propulsion systems. The ramjet/scramjet propulsion flow path comprises four primary components: the intake, isolator, combustor, and nozzle. The proposed analytical tool provides a fully integrated flow path analysis divided into three main modules. The first module focuses on the intake, facilitating the necessary freestream flow modulation before entering the isolator. For ramjet configurations, this module incorporates a normal shock assumption. The resulting flow properties are then used in the second module, which models combustion. This module calculates flow evolution within the combustion chamber using one-dimensional steady, inviscid flow equations coupled with detailed chemical kinetics and JANAF tables, employing the SUNDIALS code [@hindmarsh2005], developed by Lawrence Livermore National Laboratory.
The third module addresses nozzle design and analysis, simulating flow expansion across various expansion ratios and nozzle geometries using one-dimensional steady, inviscid flow equations under cold flow conditions. Key performance metrics, including thrust, fuel consumption, and specific impulse, are then calculated to evaluate engine performance for each design.

# Research application

`DARE` has been primarily used within the EU funded Stratofly and More\&Less projects to focus on the design, analysis, and optimization of ramjet and dual-mode ramjet/scramjet propulsion systems, which are critical for supersonic and hypersonic vehicles operating beyond Mach 3 (@zhang2016quasi; @cvode; @cakir2022]. DARE provided assessments for flow development, combustion performance, and overall propulsive characteristics such as thrust, fuel consumption, specific impulse, and efficiency are analyzed under varying conditions, including flight Mach number, altitude, intake geometry, and fuel-air equivalence ratio [@ispir2024; @cakir2024]. Sensitivity analyses, including Shapley Additive Explanations (SHAP) and feature importance studies, identify key design parameters influencing engine performance. These methodologies are demonstrated to efficiently explore the design space, generate performance maps, and quantify propulsion system feasibility for high-supersonic cruise vehicles at an affordable computational cost. `DARE` has also been used in conjunction to machine learning techniques to apply artificial neural networks to each operational and design variable within the ramjet and dual-mode ramjet/scramjet design space in order to make a comprehensive exploration of the design space and build machine learning models to represent the propulsive performance of the ramjet [@ispir2022; @cakir2023] and scramjet [@ispir2024design].
 
# Acknowledgements

This project has received funding from the European Union's Horizon 2020 research and innovation programme, STRATOFLY (Stratospheric Flying Opportunities for High-Speed Propulsion Concepts) and MORE \& LESS (MDO and REgulations for Low-boom and Environmentally Sustainable Supersonic aviation) projects under grant agreement numbers 769246 and 101006856 respectively. 

# References
